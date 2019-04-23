classdef CondenserS < matlab.System & matlab.system.mixin.Propagates
    % CondenserS Calculation of condenser heat rejection

    % Public, tunable properties
    properties(Nontunable)
        p2 = 0.6; %Condensation pressure [bar]
    end

    properties(Access = protected)
        h3
    end




    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.h3=0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.p2 >= 0.2, 'Condenser pressure below 0,2 bar!')
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

        function [hLiquid, Fi_kond] = stepImpl(obj, qmSteam, hSteam)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            
            obj.h3 = XSteam('hL_p', obj.p2); % kJ/kg, liquid water specific enthalpy on condenser outlet
            Fi_kond = qmSteam * (hSteam-obj.h3); % kW, condenser rejected heat flow
            hLiquid = obj.h3;
        end

    end
end
