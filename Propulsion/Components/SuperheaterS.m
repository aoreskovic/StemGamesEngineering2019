classdef SuperheaterS < matlab.System & HeatTransferCoefficient & matlab.system.mixin.Propagates
    % Calculation of superheater temperature and flue gas outlet
%temperatures

    % Public, tunable properties
    properties(Nontunable)
        p1 = 18; %Evaporation pressure [bar]
        A_super = 2.5133; %Superheater heat transfer area [m2]
        flueGasFlowArea = 0.002; %Superheater overall internal tube crossection area [m2]
        pipeDiameterExternal = 20/1000; %External pipe diameter [m]
        pipeThickness = 2/1000; %Superheater pipe thickness [m]
        AlfaS = 70; %Evaporation heat transfer coefficient [W/m2K]
        pipeConductivity = 58; % Tube material thermal conductivity [W/(mK)]
        pipeLength = 4; %Pipe length [m]
    end

    properties(Access = protected)
        theta_evap
        hd_in
        Cfg_in
        theta_1
        theta_1_prv
        theta_fg3
        theta_fg3_prv
        hd_out
        cpd_mean
        C_steam
        Cfg_out
        Cfg
        C1
        C2
        pi2
        pi3
        exponent
        pi1
        Fi_super
        weaker
        AlfaT
        w_pipe
        qn_H2O
        qn_CO2
        k_super
    end
    properties(Nontunable, Access = private)
        pipeDiameterInternal
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.theta_evap = XSteam('Tsat_p', obj.p1);
            obj.hd_in = XSteam('hV_T', obj.theta_evap);
            obj.Cfg_in = 0;
            obj.theta_1 = 0;
            obj.theta_1_prv = 0;
            obj.theta_fg3 = 0;
            obj.theta_fg3_prv = 0;
            obj.hd_out = 0;
            obj.cpd_mean = 0;
            obj.C_steam = 0;
            obj.Cfg_out = 0;
            obj.Cfg = 0;
            obj.C1 = 0;
            obj.C2 = 0;
            obj.pi2  = 0;
            obj.pi3  = 0;
            obj.exponent = 0;
            obj.pi1 = 0;
            obj.Fi_super = 0;
            obj.weaker = 'default';
            obj.AlfaT = 0;
            obj.w_pipe = 0;
            obj.qn_H2O =0;
            obj.qn_CO2 =0;
            obj.pipeDiameterInternal = obj.pipeDiameterExternal - 2*obj.pipeThickness;
            obj.k_super = 0;

        end

        function [theta_fgOut, theta1Out, Fi, w_fg_super, alfaFGsuper, kSuper] = stepImpl(obj, theta_fg2, qm_d, qnH20, qnCO2)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.qn_H2O = qnH20;
            obj.qn_CO2 = qnCO2;
            obj.Cfg_in = heatCapacity(obj, obj.qn_H2O, obj.qn_CO2, theta_fg2); %kJ/K inlet flue gas heat capacity
            
            %steam initial guesses
            obj.theta_1 = obj.theta_evap + 100; %°C steam superheating temperature
            obj.theta_1_prv = obj.theta_evap; %°C steam superheating temperatures at previous iteration
            %flue gas initial guesses
            obj.theta_fg3 = theta_fg2 - 200; %°C flue gas outlet temperature guess
            obj.theta_fg3_prv = theta_fg2; %°C flue gas outlet temperature at previous iteration
       
            iter = 0; %first iteration
            while (abs(obj.theta_fg3_prv- obj.theta_fg3) > 0.1) || (abs(obj.theta_1_prv- obj.theta_1) > 0.1)  %calculate until convergence of flue gas and steam outlet temperature
                iter = iter + 1; %new iteration
                assert(iter<1000, 'Superheater - convergence not achieved');
                obj.theta_fg3_prv = obj.theta_fg3; % °C flue gas outlet temperature at previous iteration
                obj.theta_1_prv = obj.theta_1; %°C steam superheating temperatures at previous iteration

                obj.hd_out = XSteam('h_pT', obj.p1, obj.theta_1); % kJ/kg, outlet steam specific enthalpy
                obj.cpd_mean = (obj.hd_out - obj.hd_in) / (obj.theta_1 - obj.theta_evap); % kJ/kgK, mean specific heat capacity of water steam in superheater
                obj.C_steam = obj.cpd_mean * qm_d; %kJ/K steam mean heat capacity in superheater

                obj.Cfg_out = heatCapacity(obj, obj.qn_H2O, obj.qn_CO2, obj.theta_fg3);  %kJ/K outlet flue gas heat capacity
                obj.Cfg = (obj.Cfg_in * theta_fg2 - obj.Cfg_out * obj.theta_fg3) / (theta_fg2 - obj.theta_fg3);  %kJ/K mean flue gas heat capacity
                if obj.Cfg > obj.C_steam
                    obj.C1 = obj.C_steam; %slabija struja
                    obj.C2 = obj.Cfg; %jaca struja
                    obj.weaker = 'steam';
                else
                    obj.C1 = obj.Cfg; %slabija struja
                    obj.C2 = obj.C_steam; %jaca struja
                    obj.weaker = 'flueGas';
                end
                [obj.AlfaT, obj.w_pipe] = alphaTube(obj, obj.qn_H2O, obj.qn_CO2, (obj.theta_fg3+theta_fg2)/2, obj.flueGasFlowArea, obj.pipeDiameterInternal, obj.pipeLength);
                obj.k_super = HTCoverall(obj, obj.AlfaT, obj.AlfaS, obj.pipeDiameterInternal, obj.pipeDiameterExternal, obj.pipeConductivity);
                assert(obj.k_super>0, 'Superheater k less than 0!')
                assert(obj.k_super<300, 'Superheater k over 300!')
                obj.pi2 = obj.k_super*obj.A_super/(1000*obj.C1); %-, pi2 dimensionless parameter (NTU)
                obj.pi3=obj.C1/obj.C2; %-, pi3 dimensionless parameter (heat capacity ratio)
                assert(obj.pi3 >= 0, 'pi3 manji od 0!');
                assert(obj.pi3 <= 1, 'pi3 veci od 1!');
                obj.exponent = exp(-(1-obj.pi3)*obj.pi2);
                obj.pi1 = (1-obj.exponent)/(1-obj.pi3*obj.exponent); %-, pi1 dimensionless parameter (effectiveness)
                switch obj.weaker
                    case 'flueGas'
                        obj.theta_fg3 = theta_fg2 - obj.pi1 * (theta_fg2 - obj.theta_evap); %°C flue gas outlet temperature
                        obj.Fi_super = obj.Cfg * (theta_fg2 - obj.theta_fg3); %kW, superheater heat flow rate
                        obj.theta_1 = obj.Fi_super/obj.C_steam + obj.theta_evap; %°C steam superheating temperature
                    case 'steam'
                        obj.theta_1 = obj.theta_evap - obj.pi1 * (obj.theta_evap - theta_fg2); %°C steam superheating temperature
                        obj.Fi_super = obj.C_steam * (obj.theta_1 - obj.theta_evap); %kW, superheater heat flow rate
                        obj.theta_fg3 = theta_fg2 - obj.Fi_super/obj.C_steam; %°C flue gas outlet temperature
                    case 'default'
                        obj.Fi_super = -1;
                        obj.theta_1 = -1;
                        obj.theta_fg3 = -1;
                        error('No weaker flow set!')
                    otherwise
                        obj.Fi_super = -2;
                        obj.theta_1 = -2;
                        obj.theta_fg3 = -2;
                        error('Unknown weaker flow error!')
                end
                obj.weaker = 'default';
                %h1 = XSteam('h_pT', p1, theta_1); %[kJ/kg] superheated steam specific enthalpy
            end
            Fi = obj.Fi_super;
            theta_fgOut = obj.theta_fg3;
            theta1Out = obj.theta_1;
            w_fg_super = obj.w_pipe;
            alfaFGsuper = obj.AlfaT;
            kSuper = obj.k_super;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.p1>5, 'Superheater pressure below 5 bar!')
            assert(obj.A_super > 0, 'Superheater wall area less than zero!')
            assert(obj.A_super < 500, 'Superheater wall area too big!')
            assert(obj.flueGasFlowArea  > 0, 'Superheater gas flow area less han 0!')
            assert(obj.flueGasFlowArea  < 10, 'Superheater gas flow area too big!')
            assert(obj.pipeDiameterExternal  > 2*obj.pipeThickness, 'Superheater external diameter less than tube thickness!')
            assert(obj.pipeDiameterExternal  < 1, 'Superheater external diameter too big!')
            assert(obj.pipeThickness >= 0.0005, 'Superheater pipe thickness less than 0.5 mm!')
            assert(obj.pipeThickness < 0.5, 'Superheater pipe thickness too big!')
            assert(obj.AlfaS > 0 , 'Superheater steam heat transfer coefficient less than 0!')
            assert(obj.AlfaS < 2000 , 'Superheater steam heat transfer coefficient too big!')
            assert(obj.pipeConductivity > 0, 'Superheater pipe thermal conductivty less than zero!')
            assert(obj.pipeConductivity < 350, 'Superheater pipe thermal conductivty too big!')
            assert(obj.pipeLength > 0, 'Superheater pipe length less than zero!')
            assert(obj.pipeLength <= 5, 'Superheater pipe length too big!')
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

    end
end
