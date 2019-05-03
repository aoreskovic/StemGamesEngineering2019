classdef CompressorS < matlab.System & matlab.system.mixin.Propagates
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        qmRetMin = 0.0064
        qmRetMax = 1.2106
        qmRetlow = 0.010585505714826
        qmRethigh = 1.2106
        Nretlow = 0.8
        Nrethigh = 1
        
    end


    methods(Access = protected)

       function [out] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function qmRet = stepImpl(obj,N)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            qmRet = obj.qmRethigh+(obj.qmRetlow-obj.qmRethigh)/(obj.Nretlow-obj.Nrethigh)*(N-obj.Nrethigh);
            qmRet=max(obj.qmRetMin, qmRet);
            qmRet=min(obj.qmRetMax, qmRet);
        end


    end
end
