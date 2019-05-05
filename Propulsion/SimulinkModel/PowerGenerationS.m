classdef PowerGenerationS < matlab.System & matlab.system.mixin.Propagates
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    properties(Nontunable)
        InitMass = 5000;
        %turbine parameters
        TurbID = 18 %selected turbine
    
        %heat exchanger parameters
        PipeID = 1; %selected heat exchanger pipe
        PipeL = 3.29; %m, heat exchanger pipe length
        EvapPipeNR = 280;  % number of tubes in evaporator
        SuperPipeNr = 63; % number of tubes in superheater section
        EvapFGfrac = 0.949643535090430; %-, fraction of flue gas that enters evaporator
        
        %compressor parameters
        ComprID = 23; % selected compressor
        N1= 0.91; %-, fuel pump relative speed at which compressor load is L1
        L1=0.41;  %-, compressor load at fuel pump speed N1
        N2= 1; %-, fuel pump relative speed at which compressor load is L2
        L2= 0.6; %-, compressor load at fuel pump speed N2
        TretInit = 210; %°C, initial return flue gas temperature
        
        %fuel pump parameters
        FuelPumpID = 13; %selected fuel pump
        
    end

    properties(Access = protected)
        
        sub
        
    end


    methods(Access = protected)
        function setupImpl(obj)
        obj.sub = subCreationSim(obj.InitMass,obj.TurbID, obj.PipeID, obj.PipeL, obj.EvapPipeNR, obj.SuperPipeNr, obj.EvapFGfrac, obj.ComprID, obj.N1, obj.L1, obj.N2, obj.L2, obj.FuelPumpID, obj.TretInit);
        end

        function [out] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
        end

        function [out] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
        end

        function [out] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
        end

        function [out] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
        end
        
        function Power = stepImpl(obj,pumpSpeed, depth)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(pumpSpeed>=obj.sub.Fuel.Pump.Nmin, 'pump speed too low!')
            assert(pumpSpeed<=1, 'pump speed too high!')
            assert(depth>=1, 'depth negative!')
            assert(depth<=obj.sub.Env.maxDepth, 'depth too big!')

            [obj.sub] = SubmarineStepCalc(obj.sub, pumpSpeed, depth);
            Power=obj.sub.Turb.Power;
        end

        function resetImpl(obj)
            clear obj.sub
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
        end
    end
end
