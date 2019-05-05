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

        function [out,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16,out17,out18] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
            out1 = [1 1];
            out2 = [1 1];
            out3 = [1 1];
            out4 = [1 1];
            out5 = [1 1];
            out6 = [1 1];
            out7 = [1 1];
            out8 = [1 1];
            out9 = [1 1];
            out10 = [1 1];
            out11 = [1 1];
            out12 = [1 1];
            out13 = [1 1];
            out14 = [1 1];
            out15 = [1 1];
            out16 = [1 1];
            out17 = [1 1];
            out18 = [1 1];
        end

        function [out,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16,out17,out18] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out1 = "double";
            out2 = "double";
            out3 = "double";
            out4 = "double";
            out5 = "double";
            out6 = "double";
            out7 = "double";
            out8 = "double";
            out9 = "double";
            out10 = "double";
            out11 = "double";
            out12 = "double";
            out13 = "double";
            out14 = "double";
            out15 = "double";
            out16 = "double";
            out17 = "double";
            out18 = "double";
        end

        function [out,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16,out17,out18] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out1 = false;
            out2 = false;
            out3 = false;
            out4 = false;
            out5 = false;
            out6 = false;
            out7 = false;
            out8 = false;
            out9 = false;
            out10 = false;
            out11 = false;
            out12 = false;
            out13 = false;
            out14 = false;
            out15 = false;
            out16 = false;
            out17 = false;
            out18 = false;
        end

        function [out,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16,out17,out18] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out1 = true;
            out2 = true;
            out3 = true;
            out4 = true;
            out5 = true;
            out6 = true;
            out7 = true;
            out8 = true;
            out9 = true;
            out10 = true;
            out11 = true;
            out12 = true;
            out13 = true;
            out14 = true;
            out15 = true;
            out16 = true;
            out17 = true;
            out18 = true;           
        end
        
        function [Power, fuelFlow_kgs,fuel_kg,Tcomb ,TevapOut,TsuperOut,...
                Tret,qmSteam_kg_s,pThr_bar,TsteamTurb,vapFrac,eta_turb,...
                evapSpeed,superSpeed,evapAlfaFG,superAlfaFG,evapHTC,superHTC,...
                system_efficiency] = stepImpl(obj,pumpSpeed, depth)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(pumpSpeed>=obj.sub.Fuel.Pump.Nmin, 'pump speed too low!')
            assert(pumpSpeed<=1, 'pump speed too high!')
            assert(depth>=1, 'depth negative!')
            assert(depth<=obj.sub.Env.maxDepth, 'depth too big!')

            [obj.sub] = SubmarineStepCalc(obj.sub, pumpSpeed, depth);
            Power=obj.sub.Turb.Power;
            
            fuelFlow_kgs = obj.sub.Fuel.Pump.qm; % [kg/s] Fuel mass flow rate
            fuel_kg = obj.sub.Fuel.Tank.fuelMass; %[kg] remaining fuel mass
            Tcomb= obj.sub.FG.Comb.Tout; % [°C] flue gas temperature on combustion chamber exit vector
            TevapOut = obj.sub.FG.HE.Evap.Tout; % [°C] flue gas temperature on evaporator  exit vector
            TsuperOut = obj.sub.FG.HE.Super.Tout; % [°C] flue gas temperature on superheater  exit vector
            Tret = obj.sub.Compr.Tret; % [°C] returning flue gas temperature vector
            qmSteam_kg_s = obj.sub.Steam.qmSteam; % [kg/s] evaporated vapour mass flow rate vector
            pThr_bar = obj.sub.Steam.Turb.pIn; % [bar] pressure after throttling
            TsteamTurb = obj.sub.Steam.Turb.Tin; % [°C] temperature after throttling
            vapFrac = obj.sub.Steam.Turb.xOut; % [-] turbine outlet vapour fraction vector
            eta_turb = obj.sub.Turb.eta; % [-] turbine efficiency vector
            evapSpeed = obj.sub.FG.HE.Evap.wPipe; % [m/s] mean steam velocity at evaporator
            superSpeed = obj.sub.FG.HE.Super.wPipe; % [m/s] mean flue gas velocity at evaporator
            evapAlfaFG = obj.sub.FG.HE.Evap.tubeHTC; % [W/m2K] evaporator heat transfer coefficient on tube side (fg)
            superAlfaFG = obj.sub.FG.HE.Super.tubeHTC; % [W/m2K] superheater heat transfer coefficient on tube side (fg)
            evapHTC = obj.sub.HE.Evap.k; % [W/m2K] evaporator overall heat transfer coefficient
            superHTC = obj.sub.HE.Super.k; % [W/m2K] superheater overall heat transfer coefficient
            system_efficiency = obj.sub.Turb.Power/(obj.sub.FG.fuelHeatVal * obj.sub.Fuel.Pump.qm / obj.sub.FG.M_ethanol); % system overall efficiency


            
            
            
            
        end

        function resetImpl(obj)
            clear obj.sub
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
        end
    end
end
