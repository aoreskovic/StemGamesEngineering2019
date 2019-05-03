classdef CounterReset < matlab.System & matlab.system.mixin.Propagates
   % CounterReset Count values above a threshold
    
   properties
      Threshold = 1
   end
  
   properties (DiscreteState)
      Count
   end
  
   methods (Access = protected)
      function setupImpl(obj)
         obj.Count = 0;
      end
    
      function y = stepImpl(obj,u1,u2)
         % Add to count if u1 is above threshold
         % Reset if u2 is true
         if (u2)
           obj.Count = 0;
         elseif (any(u1 > obj.Threshold))
           obj.Count = obj.Count + 1;
         end
         y = obj.Count;
      end
    
      function resetImpl(obj)
         obj.Count = 0;
      end
    
      function [sz,dt,cp] = getDiscreteStateSpecificationImpl(~,name)
         if strcmp(name,'Count')
            sz = [1 1];
            dt = 'double';
            cp = false;
         else
            error(['Error: Incorrect State Name: ', name.']);
         end
      end
      function dataout = getOutputDataTypeImpl(~)
         dataout = 'double';
      end
      function sizeout = getOutputSizeImpl(~)
         sizeout = [1 1];
      end
      function cplxout = isOutputComplexImpl(~)
         cplxout = false;
      end
      function fixedout = isOutputFixedSizeImpl(~)
         fixedout = true;
      end
      function flag = isInputSizeMutableImpl(~,idx)
         if idx == 1
           flag = true;
         else
           flag = false;
         end
      end
   end
end