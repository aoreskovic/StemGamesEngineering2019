classdef EvaporatorS < matlab.System & HeatTransferCoefficient & matlab.system.mixin.Propagates
    % Untitled7 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    properties(Nontunable)
        p1 = 18; %Evaporation pressure [bar]
        A_evap = 22.6195; %Evaporator heat transfer area [m2]
        flueGasFlowArea = 0.0181; %Evaporator overall internal tube crossection area [m2]
        pipeDiameterExternal = 0.02; %Evaporator pipe external diameter [m]
        pipeThickness = 0.002; %Evaporator pipe thickness [m]
        AlfaS = 3500; %Evaporation heat transfer coefficient [W/m2K]
        pipeConductivity = 58; % Tube material thermal conductivity [W/(mK)]
        
    end

    properties(Access = protected)
        h4
        h5
        Cfg_in
        qn_H2O
        qn_CO2
        theta_fg2
        theta_fg2_prv
        AlfaT
        w_pipe
        k_evap
        Cfg_out
        Cfg
        pi2
        pi1

    end

    properties(Nontunable, Access = private)
        theta_evap
        pipeDiameterInternal
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.h4 = 0;
            obj.h5 = 0;
            obj.Cfg_in = 0;
            obj.qn_H2O = 0;
            obj.qn_CO2 = 0;
            obj.theta_fg2 = 0;
            obj.theta_fg2_prv = 0;
            obj.AlfaT = 0;
            obj.w_pipe = 0;
            obj.Cfg_out = 0;
            obj.Cfg = 0;
            obj.pi2 = 0;
            obj.theta_evap = XSteam('Tsat_p', obj.p1);
            obj.pipeDiameterInternal = obj.pipeDiameterExternal - 2*obj.pipeThickness;
            obj.k_evap=0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.p1 > 4, 'Evaporation pressure below 4 bar!')
            assert(obj.p1 <= 50, 'Evaporation pressure over 50 bar!')
            assert(obj.A_evap > 0, 'Evaporator heat transfer area below 0 m2!')
          
        end

        function [out,out2,out3,out4,out5,out6] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
            out2 = [1 1];
            out3 = [1 1];
            out4 = [1 1];
            out5 = [1 1];
            out6 = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out2,out3,out4,out5,out6] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out2 = "double";
            out3 = "double";
            out4 = "double";
            out5 = "double";
            out6 = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out,out2,out3,out4,out5,out6] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out2 = false;
            out3 = false;
            out4 = false;
            out5 = false;
            out6 = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out2,out3,out4,out5,out6] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out2 = true;
            out3 = true;
            out4 = true;
            out5 = true;
            out6 = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function [thetaFGout, qm_d, Fi_evap, w_fg_evap, alfaFGevap, kEvap] = stepImpl(obj, theta_fg1, qnH20, qnCO2, hWater)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.h4 = hWater;
            obj.qn_H2O=qnH20;
            obj.qn_CO2=qnCO2;
            obj.h5 = XSteam('hV_p',obj.p1); %kJ/kg, enthalpy evaporated water
            obj.Cfg_in = heatCapacity(obj, obj.qn_H2O, obj.qn_CO2, theta_fg1); %kJ/K, flue gas heat capacity at evaporator inlet
            %initial guess
            obj.theta_fg2 = theta_fg1 - 300; %°C, flue gas temperature at evaporator outlet
            obj.theta_fg2_prv = theta_fg1; %°C, flue gas temperature at evaporator outlet calculated in previous ineration
            obj.Cfg_out = heatCapacity(obj, obj.qn_H2O, obj.qn_CO2, obj.theta_fg2); %kJ/K, flue gas heat capacity at evaporator outlet
            obj.Cfg = (obj.Cfg_in * theta_fg1 - obj.Cfg_out * obj.theta_fg2) / (theta_fg1 - obj.theta_fg2); %kJ/K, mean flue gas heat capacity in evaporator

            iter = 0; %first iteration
            while abs(obj.theta_fg2_prv- obj.theta_fg2) > 0.1 %calculate until convergence
                iter = iter + 1; %new iteration
                assert(iter<1000, 'Evaporator - convergence not achieved')
                obj.theta_fg2_prv = obj.theta_fg2; %°C, flue gas evaporator exit temperature calculated in previous iteration
                [obj.AlfaT, obj.w_pipe] = alphaTube(obj, obj.qn_H2O, obj.qn_CO2, (obj.theta_fg2+theta_fg1)/2, obj.flueGasFlowArea, obj.pipeDiameterInternal);
                obj.k_evap = HTCoverall(obj, obj.AlfaT, obj.AlfaS, obj.pipeDiameterInternal, obj.pipeDiameterExternal, obj.pipeConductivity);
                assert(obj.k_evap > 0, 'Evaporator overall heat transfer coefficient below 0 W/m2K!')
                assert(obj.k_evap < 500, 'Evaporator overall heat transfer coefficient over 500 W/m2K!')
                obj.pi2=obj.k_evap*obj.A_evap/(1000*obj.Cfg); %-, pi2 dimensionless parameter (NTU)
                obj.pi1=1-exp(-obj.pi2); %-, pi1 dimensionless parameter (effectiveness)
                obj.theta_fg2 = theta_fg1 - obj.pi1 * (theta_fg1 - obj.theta_evap); %°C, flue gas temperature at evaporator outlet calculated in this iteration
            end
            thetaFGout=obj.theta_fg2;
            Fi_evap = obj.Cfg * (theta_fg1 - obj.theta_fg2); %kW, evaporator heat flow rate
            qm_d = Fi_evap/(obj.h5-obj.h4); %kg/s, mass flow of evaporated water
            w_fg_evap = obj.w_pipe;
            alfaFGevap = obj.AlfaT;
            kEvap = obj.k_evap;
        end
    end
end
