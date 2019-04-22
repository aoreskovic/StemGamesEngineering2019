classdef CondensatePumpS < matlab.System & matlab.system.mixin.Propagates
    % Untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        p1 = 18; %Evaporation pressure [bar]
        p2 = 0.6; %Condensation pressure [bar]
        eta = 0.75; %Pump efficiency  [-]
    end

    properties(Access = protected)
        s3
        h3
        h4s
        h4
        theta4
    end


    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.s3 = 0;
            obj.h3 = 0;
            obj.h4s = 0;
            obj.h4 = 0;
            obj.theta4 = 0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.p1 > 5, 'Pump outlet (evaporation) pressure below 5 bar!')
            assert(obj.p1 <= 50, 'Pump outlet (evaporation) pressure over 50 bar!')
            assert(obj.p2 < obj.p1, 'Pump inlet (condensation) greater than outlet!')
            assert(obj.p2 >= 0.2, 'Pump inlet (condensation) below 0.2 bar!')
            assert(obj.eta >= 0.1, 'Pump efficiency below 10 % !')
            assert(obj.eta <= 1, 'Pump efficiency over 100 % !')
           

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

        function [hWater, waterT, FiPump] = stepImpl(obj,qm)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.s3 = XSteam('sL_p', obj.p2); % kJ/kgK, pump inlet specific entropy
            obj.h3 = XSteam('hL_p', obj.p2);% kJ/kgK, pump inlet specific enthalpy
            obj.h4s=XSteam('h_ps', obj.p1, obj.s3); %kJ/kg, pump outlet specific enthalpy if proces was isentropic
            obj.h4 = obj.h3 + (obj.h4s-obj.h3)/obj.eta;  %kJ/kg, pump outlet specific enthalpy
            obj.theta4 = XSteam('T_ph', obj.p1, obj.h4); %°C, pump outlet temperature
            FiPump = qm * (obj.h4-obj.h3); % kW, pump power
            waterT = obj.theta4;
            hWater = obj.h4;
        end
    end
end
