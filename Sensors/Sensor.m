classdef (Abstract) Sensor
    %SENSOR Sensor interface
    
    properties (Hidden)
        outputNum
        bias
        stdDeviation
        resolution
        inputRange
        outputRange
    end
    
    % Abstract method which should be implemented for a specific sensor
    methods (Abstract)
        dynamicFiltering(obj, input)
    end
    
    methods (Hidden)
        function output = quantization(obj, input)
            quant = obj.resolution;
            output = sign(input)*floor(abs(input)/quant)*quant;
        end
    end
    
    methods
        % Constuctor
        function obj = Sensor(num, bias, stdDeviation, resolution, inputRange, outputRange)
                obj.outputNum = num; % For future upgrade.
                obj.bias = bias;
                obj.stdDeviation = stdDeviation;
                obj.resolution = resolution;
                obj.inputRange = inputRange;
                obj.outputRange = outputRange;
        end
       
        % Setter methods for property check
        function obj = set.outputNum(obj, value)
            if(value > 0 && mod(value,1) == 0)
                obj.outputNum = value;
            else
                error('Number of outputs must be positive integer!');
            end
        end
        
        function obj = set.bias(obj, value)
            if(isreal(value) && isscalar(value))
                obj.bias = value;
            else
               error('Bias must be real scalar!');
            end
        end
        
        function obj = set.stdDeviation(obj, value)
            if(isreal(value) && isscalar(value) && value > 0)
                obj.stdDeviation = value;
            else
               error('Standard deviation must be real positive scalar!');
            end
        end
        
        function obj = set.resolution(obj, value)
            if(isreal(value) && isscalar(value) && value > 0)
                obj.resolution = value;
            else
                error('Resolution must be real positive scalar!');
            end
        end
        
        function obj = set.inputRange(obj, value)
            if(isreal(value) && sum(size(value) == [1,2]) == 2)
                if(value(1) < value(2))
                    obj.inputRange = value;
                else
                    error('Minimum input value must be lower than maximum input value!');
                end
            else
                error('Input range must be 2 column vector with real values!');
            end
        end
        
        function obj = set.outputRange(obj, value)
            if(isreal(value) && sum(size(value) == [1,2]) == 2)
                if(value(1) < value(2))
                    obj.outputRange = value;
                else
                    error('Minimum output value must be lower than maximum otuput value!');
                end
            else
                error('Output range must be 2 column vector with real values!');
            end
        end
        
        % Measurement function performs preprocesing and postprocesing of
        % real simulated values and gives them real uncertainties and
        % imperfections caused by sensor
        function output = measure(obj, realInput)
            % Add input saturation
            saturatedInput = min(obj.inputRange(2), max(obj.inputRange(1), realInput));
            % Measurement from the sensor
            input = dynamicFiltering(obj, saturatedInput);
            % Add bias and standard deviation
            noiseInput = input + normrnd(obj.bias, obj.stdDeviation);
            % Add resolution
            quantInput = obj.quantization(noiseInput);
            % Add output saturation
            output = min(obj.outputRange(2), max(obj.outputRange(1), quantInput));
        end
    end
end

