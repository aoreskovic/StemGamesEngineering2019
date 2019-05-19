function [sub] = subCreationSim(InitMass,TurbID, PipeID, PipeL, EvapPipeNR, SuperPipeNr, EvapFGfrac, ComprID, N1, L1, N2, L2, FuelPumpID, TretInit)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
            sub.Fuel.Tank.initMass = InitMass; %kg, initial fuel mass

            %turbine parameters
            sub.Turb.id = TurbID; %selected turbine

            %heat exchanger parameters
            sub.HE.Pipe.id = PipeID; %selected heat exchanger pipe
            sub.HE.Pipe.length = PipeL; %m, heat exchanger pipe length
            sub.HE.Evap.nr = EvapPipeNR;  % number of tubes in evaporator
            sub.HE.Super.nr = SuperPipeNr; % number of tubes in superheater section
            sub.FG.HE.Evap.FGfraction = EvapFGfrac; %-, fraction of flue gas that enters evaporator
            
            %compressor parameters
            sub.Compr.id = ComprID; % selected compressor
            sub.Compr.N1 = N1; %-, fuel pump relative speed at which compressor load is L1
            sub.Compr.L1 =L1; %-, compressor load at fuel pump speed N1
            sub.Compr.N2 = N2; %-, fuel pump relative speed at which compressor load is L2
            sub.Compr.L2 = L2; %-, compressor load at fuel pump speed N2

            %fuel pump parameters
            sub.Fuel.Pump.id = FuelPumpID; %selected fuel pump

            %initial guess
            sub.Compr.Tret = TretInit; %°C, initial flue gas return temperature
            sub.Fuel.Tank.fuelMass = sub.Fuel.Tank.initMass; %at first step remaining fuel mass is exual to initial
            sub = SubmarineParameters(sub);
end

