classdef linkError < handle
    %LINKERROR Design error tracer
    
    properties(Access=private)
        errorCount = 0;
        critical = false;
        triggerredErrors = [];
        
        %ERRORMAP Defined error codes and their description, and
        %criticality flag
        errorMap = containers.Map( ...
            {'trxMethod', 'arrayLength', 'freqRange', 'freqLicense', 'arrayParameter'}, ...
            {
                {'Unsupported TRX method', true}
                {'Antenna array is larger than the submarine', true}
                {'Frequency out of bounds', true}
                {'No frequency license', false}
                {'Array parameter error', true}
            } ...
        );
    end

    methods(Static)
      function obj = instance()
         persistent singleton
         if isempty(singleton)
            obj = linkError();
            singleton = obj;
         else
            obj = singleton;
         end
      end
   end
    
    methods(Access=public)
        function printErrors(obj)
            %PRINTERROR Display all errors that occured
            fprintf('Total link errors: %d\n', obj.errorCount);
            for idx = 1:size(obj.triggerredErrors,1)
                obj.printSingleError(obj.triggerredErrors(idx,:));
            end
        end
        
        function invokeError(obj,errorCode)
            %INVOKEERROR Trigger an error. Fail if it was critical
            obj.triggerredErrors = [obj.triggerredErrors; errorCode];
            obj.errorCount = obj.errorCount + 1;
            obj.printSingleError(errorCode);
            if isKey(obj.errorMap, errorCode)
                errorDesc = obj.errorMap(errorCode);
                if cell2mat(errorDesc(2))
                    error('Link error was critical');
                end
            end
        end
    end

    methods(Access=private)
        function obj = linkError()
        end

        function delete(obj)
            obj.printErrors;
        end

        function printSingleError(obj, errorCode)
            if (isKey(obj.errorMap, errorCode))
                errorDesc = obj.errorMap(errorCode);
                fprintf('Link error %s: %s\n', errorCode, string(errorDesc(1)));
                if cell2mat(errorDesc(2))
                    fprintf('Error %s is critical\n', errorCode);
                end
            else
                fprintf('Link error: Unknown error key %s\n', errorCode);
            end
        end
    end
end

