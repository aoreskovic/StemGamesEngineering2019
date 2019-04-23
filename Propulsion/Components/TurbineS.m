classdef TurbineS < matlab.System & matlab.system.mixin.Propagates
    % Untitled8 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.


    properties(Nontunable)
        p_evap = 18; %Evaporation pressure [bar]
        p2 = 0.6; %Condensation pressure [bar]
    end
    
    properties(Access = protected)
        h1
        s1
        h2s
        h2
        theta2
        s2
        P
        eta
        tsat
        x2
        p1
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.h1 = 0;
            obj.s1 = 0;
            obj.h2s = 0;
            obj.h2 = 0;
            obj.theta2 = 0;
            obj.s2 = 0;
            obj.P = 0;
            obj.eta = 0;
            obj.tsat = 0;
            obj.p1 = 0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.p_evap > 5, 'Turbine inlet pressure below 5 bar!')
            assert(obj.p_evap <= 50, 'Turbine inlet pressure over 50 bar!')
            assert(obj.p2 < obj.p_evap, 'Turbine inlet pressure below outlet!')
            assert(obj.p2 >= 0.2, 'Turbine outlet pressure below 0.2 bar!')
        end

        function [out,out2,out3,out4] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
            out2 = [1 1];
            out3 = [1 1];
            out4 = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out2,out3,out4] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out2 = "double";
            out3 = "double";
            out4 = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out,out2,out3,out4] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out2 = false;
            out3 = false;
            out4 = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out2,out3,out4] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out2 = true;
            out3 = true;
            out4 = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function [ thetaOut, hOut, xOut, Power]  = stepImpl(obj, p_turb, theta_d1, qm_d, eta_turb)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.eta = eta_turb;
            assert(p_turb > 1, 'turbine pressure too low!')
            assert(p_turb <= obj.p_evap, 'turbine pressure too high!')
            obj.p1 = p_turb; % pressure at turbine inlet
            obj.h1=XSteam('h_pT', obj.p1, theta_d1); %kJ/kg steam specific enthalpy on turbine inlet
            obj.s1=XSteam('s_pT', obj.p1, theta_d1); %kJ/kgK  steam specific entropy on turbine inlet
            obj.h2s=XSteam('h_ps', obj.p2, obj.s1); %kJ/kg steam specific enthalpy on turbine outlet if the proces was isentropic
            obj.h2=obj.h1-obj.eta*(obj.h1-obj.h2s); %kJ/kg steam specific enthalpy on turbine outlet 
            obj.theta2=XSteam('T_ph', obj.p2, obj.h2); %°C steam temperature on turbine outlet
            obj.s2=XSteam('s_ph', obj.p2, obj.h2); %kJ/kgK team specific entropy on turbine outlet
            obj.P=qm_d * (obj.h1-obj.h2); % kW turbine power
            obj.tsat = XSteam('Tsat_p', obj.p2); % °C saturation temperature for outlet pressure
            if obj.theta2 == obj.tsat % test if steam is not superheated on turbine outlet
                obj.x2 = XSteam('x_ph', obj.p2, obj.h2); % -, vapour fraction
                if obj.x2 < 0.9
                    error('Vapour fraction below 90%')
                end
            elseif obj.theta2 > obj.tsat
                obj.x2 = 1; % if outlet temperature > saturation temperature, vapour fraction is 1
            else
                error('Unsaturated water after condensation!')
            end  
            Power=obj.P;
            thetaOut = obj.theta2;
            hOut = obj.h2;
            xOut = obj.x2;
        end
    end
end
