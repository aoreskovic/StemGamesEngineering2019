function [sub] = createSub(TurbID,PipeID, PipeLen, EvapPipeNr, SuperPipeNr, CompID, FuelPumpID)
%fuel tank parameters
Sub.Fuel.Tank.initMass = 50000000000; %kg, initial fuel mass

%turbine parameters
Sub.Turb.id = TurbID; %selected turbine

%heat exchanger parameters
Sub.HE.Pipe.id = PipeID; %selected heat exchanger pipe
Sub.HE.Pipe.length = PipeLen; %m, heat exchanger pipe length
Sub.HE.Evap.nr = EvapPipeNr;  % number of tubes in evaporator
Sub.HE.Super.nr = SuperPipeNr; % number of tubes in superheater section

%compressor parameters
Sub.Compr.id = CompID; % selected compressor

%fuel pump parameters
Sub.Fuel.Pump.id = FuelPumpID; %selected fuel pump

%initial guess
Sub.Compr.Tret = 240; %°C, initial flue gas return temperature
sub = SubmarineParameters(Sub);
sub.Fuel.Tank.fuelMass = sub.Fuel.Tank.initMass;
end

