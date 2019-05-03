classdef ValveS < matlab.System & matlab.system.mixin.Propagates 
    % Untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        p1 = 18; %Evaporation pressure [bar]
        p2 = 0.6; %Condensation pressure [bar]
        theta1_nom = 297.14; %Nominal superheating temperature [°C]
        qmd_nom = 0.2040; %Nominal steam mass flow rate [kg/s]
        eta_nom = 0.8; %Efficiency at nominal working conditions [-]
        a = -2; % Quadratic efficiency coefficient
        K = 0.1254; % Stodola coefficient
    end
    properties(Nontunable, Access = private)
        
        b
        c
        qv_inlet_nom
        s1_nom
        qv_outlet_nom
        qv_nom
    end
    properties(Access = protected)
        qm_steam
        theta_super
        theta_thr
        theta_thr_prv
        h1
        p_thr
        v_inlet
        qv_inlet
        s_inlet
        v_outlet
        qv_outlet
        qv_mean
        qv_rel
        eta_stage
        eta
    end
        
    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.qm_steam = 0;
            obj.theta_super = 0;
            obj.theta_thr = 0;
            obj.theta_thr_prv = 0;
            obj.h1 = 0;
            obj.p_thr = 0;
            obj.v_inlet = 0;
            obj.qv_inlet = 0;
            obj.s_inlet = 0;
            obj.v_outlet = 0;
            obj.qv_outlet = 0;
            obj.qv_mean = 0;
            obj.b = -2 * obj.a;
            obj.c = 1 - obj.b - obj.a;
            obj.qv_rel = 0;
            obj.eta_stage = 0;
            obj.eta = 0;
            obj.qv_inlet_nom = obj.qmd_nom * XSteam('v_pT', obj.p1, obj.theta1_nom); %m3/s, nominal inlet steam volume flow rate
            obj.s1_nom = XSteam('s_pT', obj.p1, obj.theta1_nom); % nominal inlet steam enthalpy
            obj.qv_outlet_nom = obj.qmd_nom*XSteam('v_ps', obj.p2, obj.s1_nom); %m3/s, nominal outlet steam volume flow rate
            obj.qv_nom = sqrt(obj.qv_inlet_nom*obj.qv_outlet_nom);  %m3/s, nominal mean steam volume flow rate      
        end

        function [p_turb, theta_turb, eta_turb] = stepImpl(obj,qm_d, theta1)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.qm_steam=qm_d; %steam flow rate, kg/s
            obj.theta_super = theta1; %steam temperature at valve inlet
            if obj.qm_steam*sqrt(obj.theta_super+273.15) <= obj.qmd_nom*sqrt(obj.theta1_nom+273.15) %pressure after valve can't increase!
                obj.theta_thr = obj.theta_super-2; % initial guess of temperature after throttling
                obj.theta_thr_prv = obj.theta_super; % initial guess
                obj.h1 = XSteam('h_pT', obj.p1, obj.theta_super); % enthalpy on valve inlet, kJ/kg
                while abs(obj.theta_thr-obj.theta_thr_prv) > 0.01 %iterate until convergence
                    obj.p_thr = sqrt(obj.p2*obj.p2+obj.qm_steam*obj.qm_steam/(obj.K*obj.K)*(obj.theta_thr+273.15)); %bar, pressure after throttling
                    obj.theta_thr_prv = obj.theta_thr; %  °C, temperature after throttling in previous iteration
                    obj.theta_thr = XSteam('T_ph', obj.p_thr, obj.h1);  %°C, new temperature after throttling
                end
            else
                obj.p_thr = obj.p1; %bar, no pressure drop in valve
                obj.theta_thr = obj.theta_super;  %°C, no temperature change in valve
            end
            if obj.p_thr>obj.p1 %making sure pressure was not increased in valve
                obj.p_thr=obj.p1; %bar, no pressure drop in valve
                obj.theta_thr = obj.theta_super; %°C, no temperature change in valve
            end
            
            %efficiency calculation
            obj.v_inlet=XSteam('v_pT', obj.p_thr, obj.theta_thr); % specific volume, m^3/kg
            obj.qv_inlet =  obj.qm_steam*obj.v_inlet; %steam volume flow at turbine inlet, m^3/s
            obj.s_inlet = XSteam('s_pT', obj.p_thr, obj.theta_thr);

            
            obj.v_outlet = XSteam('v_ps', obj.p2, obj.s_inlet);
            obj.qv_outlet = obj.qm_steam*obj.v_outlet;
            obj.qv_mean = sqrt(obj.qv_inlet*obj.qv_outlet);
            obj.qv_rel = obj.qv_mean/obj.qv_nom; %-, relative steam volume flow rate
            obj.eta_stage = obj.qv_rel*obj.qv_rel*obj.a+obj.qv_rel*obj.b+obj.c; %stage efficiency, -
            obj.eta_stage = max(0, obj.eta_stage); %stage efficiency, can't be negative
            assert(obj.eta_stage >= 0, 'eta_stage <0!')
            assert(obj.eta_stage <= 1, 'eta_stage >1!')
            assert(obj.p_thr <= obj.p1, 'pressure above maximum')
            obj.eta = obj.eta_nom*obj.eta_stage; %turbine overall efficiency, -
            
            %outputs
            p_turb = obj.p_thr;
            theta_turb = obj.theta_thr;
            eta_turb = obj.eta;
        end


        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.p1>obj.p2, 'Condensation pressure > evaporation!')
            assert(obj.p2 >= 0.2, 'Condensation pressure too low!')
            assert(obj.p2 < 10, 'Condensation pressure too high!')
            assert(obj.p1 < 50, 'Evaporation pressure too high!')
            assert(obj.theta1_nom > XSteam('Tsat_p', obj.p1), 'superheating temperature below saturation temperature!')
            assert(obj.theta1_nom < 600, 'Superheating temperature too high!')
            assert(obj.qmd_nom > 0, 'Nominal valve mass flow negative!')
            assert(obj.qmd_nom < 2, 'Nominal valve mass flow too high!')
            assert(obj.a < 0, 'turbine efficiency quadratic coefficient positive!')   
            assert(obj.K > 0, 'Stodola coefficient negative!')   

        end

        function [out,out2,out3] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
            out2 = [1 1];
            out3 = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out2,out3] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out2 = "double";
            out3 = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out,out2,out3] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out2 = false;
            out3 = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out2,out3] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out2 = true;
            out3 = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end
% 
%         function [out,out2,out3] = getOutputSizeImpl(obj)
%             % Return size for each output port
%             out = [1 1];
%             out2 = [1 1];
%             out3 = [1 1];
% 
%             % Example: inherit size from first input port
%             % out = propagatedInputSize(obj,1);
%         end
    end
end
