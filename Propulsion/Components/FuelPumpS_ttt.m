classdef FuelPumpS_ttt < matlab.System & matlab.system.mixin.Propagates 
    % Untitled3 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.


    properties(Nontunable)
        Q_nom = 5.4/320; %Fuel pump nominal volume flow rate [m3/h]
        h_nom =  4.2/320; %Fuel pump nominal head [m]
        P_nom = 100.7/320; %Fuel pump nominal power consumption [W]
        n_ref = 0.76; %Pump nominal relative speed [-]
        rho_ethanole = 789; %Ethanole density [kg/m3]
        pump_type (1, 1) PumpType = PumpType.type1 %Pump type
    end
    
    properties(Nontunable, Access = protected)
        a
        b_ref
        c_ref
        a_max
        b_max
        c_max
        h_max
        k_pipe
        n_min
        aP
        bP_ref
        cP_ref
        dP_ref
        inverterP
        aP_max
        bP_max
        cP_max
        dP_max
        Pmax
    end
    
     properties(Access = protected)
        b
        c
        Q
        h
        poly
        r
        h_max_cav
        qm
        bP
        cP
        dP
        P
        P_max2
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            [obj.a, obj.b_ref, obj.c_ref, obj.a_max, obj.b_max, obj.c_max, ...
                obj.h_max, obj.k_pipe, obj.n_min, obj.aP, obj.bP_ref, ...
                obj.cP_ref, obj.dP_ref, obj.inverterP, obj.aP_max, obj.bP_max, ...
                obj.cP_max, obj.dP_max, obj.Pmax] = fuel_pump_parameters...
                (obj.Q_nom, obj.h_nom,  obj.P_nom, char(obj.pump_type));
            obj.b=0;
            obj.c=0;
            obj.Q = 0;
            obj.h = 0;
            obj.poly=[0,0,0];
            obj.r=[0,0];
            obj.h_max_cav=0;
            obj.qm=0;
            obj.bP=0;
            obj.cP=0;
            obj.dP=0;
            obj.P=0;
            obj.P_max2=0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.Q_nom>0, 'Nominal fuel pump flow rate less than 0!');
            assert(obj.h_nom>0, 'Nominal fuel pump head less than 0!');
            assert(obj.P_nom>0, 'Nominal fuel pump power consumption less than 0!');
            assert(obj.n_ref>0, 'Nominal fuel pump relative speed less than 0!');
            assert(obj.rho_ethanole>0, 'Density less than 0!');
            
            
        end



        function [qm_out, P_out] = stepImpl(obj,relative_speed)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(relative_speed >= obj.n_min, 'Pump speed too low!')
            obj.b = obj.b_ref * relative_speed / obj.n_ref;
            obj.c = obj.c_ref * (relative_speed/obj.n_ref)* (relative_speed/obj.n_ref);
            obj.poly = [obj.a-obj.k_pipe, obj.b, obj.c];
            obj.r = roots(obj.poly);
            obj.r = real(obj.r);
            %assert(isreal(obj.r), 'Roots not real')
            %assert(any(obj.r>0), 'negative roots')
            obj.Q = obj.r(obj.r>0);
            assert(isscalar(obj.Q), 'both roots positive')
            obj.h = obj.a*obj.Q*obj.Q+obj.b*obj.Q+obj.c;
            
            if obj.h > obj.h_max
                obj.poly = [-obj.k_pipe, 0, obj.h_max];
                obj.r = roots(obj.poly);
                obj.r = real(obj.r);
                assert(isreal(obj.r), 'Roots not real')
                %assert(any(obj.r>0), 'negative roots')
                obj.Q = obj.r(obj.r>0);
                assert(isscalar(obj.Q), 'both roots positive')
                obj.h = obj.h_max;
            end
            obj.h_max_cav = obj.a_max*obj.Q*obj.Q+obj.b_max*obj.Q+obj.c_max;
            if obj.h>obj.h_max_cav
                obj.poly = [obj.a_max-obj.k_pipe, obj.b_max, obj.c_max];
                obj.r = roots(obj.poly);
                obj.r = real(obj.r);
                assert(isreal(obj.r), 'Roots not real')
                %assert(any(obj.r>0), 'negative roots')
                obj.Q = obj.r(obj.r>0);
                assert(isscalar(obj.Q), 'both roots positive')
                obj.h = obj.a_max*obj.Q*obj.Q+obj.b_max*obj.Q+obj.c_max;
            end
            obj.qm = obj.Q * obj.rho_ethanole / 3600; % [kg/s] pump mass flow rate
            qm_out=real(obj.qm(1));
            
            
            obj.bP = obj.bP_ref * relative_speed / obj.n_ref;
            obj.cP = obj.cP_ref * (relative_speed/obj.n_ref)* (relative_speed/obj.n_ref);
            obj.dP = obj.dP_ref * (relative_speed/obj.n_ref)* (relative_speed/obj.n_ref)* (relative_speed/obj.n_ref);
            obj.P = obj.aP*obj.Q*obj.Q*obj.Q + obj.bP*obj.Q*obj.Q + obj.cP*obj.Q + obj.dP + obj.inverterP;

            if obj.P>obj.Pmax
                obj.P=obj.Pmax;
            end
            obj.P_max2 = obj.aP_max*obj.Q*obj.Q*obj.Q + obj.bP_max*obj.Q*obj.Q + obj.cP_max*obj.Q + obj.dP_max + obj.inverterP;
            if obj.P > obj.P_max2
                obj.P = obj.P_max2;
            end
            
            P_out=real(obj.P(1));
            
        end
        function [out,out2] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
            out2 = [1 1];
            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out2] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out2 = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out,out2] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out2 = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out2] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out2 = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end
    end
end
