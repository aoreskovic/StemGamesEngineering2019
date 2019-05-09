function [Vload, MaxDepth, velocityMaxSpeed, kmMaxRange,...
CombTempFlagRange, TurbTempFlagRange, SaturatedFlagRange, deadFlagRange, evapErosionFlagRange, evapSuperFlagRange, pumpSpeedExceedFlagRange,...
CombTempFlagSpeed, TurbTempFlagSpeed, SaturatedFlagSpeed, deadFlagSpeed, evapErosionFlagSpeed, evapSuperFlagSpeed, pumpSpeedExceedFlagSpeed,...
CombTempFlagDepth, TurbTempFlagDepth, SaturatedFlagDepth, deadFlagDepth, evapErosionFlagDepth, evapSuperFlagDepth, pumpSpeedExceedFlagDepth] =...
SolutionEval(file_name)

params = xlsread(file_name);

TurbID = params(1); 
PipeLength = params(2);
EvapPnr = params(3);
SuperPnr = params(4);
ComprID =params(5);
FuelPumpID =params(6);
CompN1 =params(7);
CompLoad1 =params(8);
CompN2 =params(9);
CompLoad2 = params(10);
EvapFGfrac = params(1);
mFuel =params(12);
mOxy =params(13);
PumpSpeedMaxVel=params(14);
depthMaxVel = params(15);
PumpSpeedMaxRange =params(16);
depthMaxRange = params(17);
speedMaxDepth = params(18);
MaxDepth = params(19);

PowerReqConst = 4.5; %kW
PowerReqLin = 0.05;



Lsub = 15;

%propulsion length
aProp = 18;
bProp = 2500;
[PowerNom, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, TmaxTurb] = Turbines(TurbID);
Lturb = (aProp*PowerNom+bProp)/1000;

%fuel and oxy tank length
Rtank = 1.5; %fuel tank radius
roOxy = 1141; %density oxygen
roFuel = 789; %fuel density
Loxy = mOxy/roOxy/pi()/(Rtank*Rtank);
Lfuel = mFuel/roFuel/pi()/(Rtank*Rtank);


Lload = Lsub-Lturb-Loxy-Lfuel; % remaining length for load storage
Vload = Lload*pi()*Rtank*Rtank;

OxyMol = mOxy/18;
FuelMolOxy = OxyMol/3;
FuelOxyMass = FuelMolOxy*46;
mFuelMin = min(FuelOxyMass, mFuel);
[qmG_kg_sMaxRange, Turbine_power_kW_maxRange, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency,...
 CombTempFlagRange, TurbTempFlagRange, SaturatedFlagRange, deadFlagRange, evapErosionFlagRange, evapSuperFlagRange, pumpSpeedExceedFlagRange] = ...
        evalSystem(TurbID, PipeLength, EvapPnr, SuperPnr, ComprID,...
        FuelPumpID, CompN1,CompLoad1,CompN2,CompLoad2,  EvapFGfrac, PumpSpeedMaxRange, depthMaxRange, mFuelMin);
PowerPropMaxRange = Turbine_power_kW_maxRange - PowerNom*PowerReqLin - PowerReqConst;
Cspeed = 2.0135;
expSpeed = 0.3518;
knot2ms = 0.514444;
velocityMaxRange = knot2ms*Cspeed.*PowerPropMaxRange.^expSpeed; %
timeMaxRange = mFuelMin/qmG_kg_sMaxRange;
distanceMaxRange = velocityMaxRange*timeMaxRange;
hoursMaxRange = timeMaxRange/3600;
kmMaxRange = distanceMaxRange/1000;
    

[qmG_kg_sMaxSpeed, Turbine_power_kW_maxSpeed, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency,...
 CombTempFlagSpeed, TurbTempFlagSpeed, SaturatedFlagSpeed, deadFlagSpeed, evapErosionFlagSpeed, evapSuperFlagSpeed, pumpSpeedExceedFlagSpeed] = ...
        evalSystem(TurbID, PipeLength, EvapPnr, SuperPnr, ComprID,...
        FuelPumpID, CompN1,CompLoad1,CompN2,CompLoad2,  EvapFGfrac, PumpSpeedMaxVel, depthMaxVel, mFuelMin);

PowerPropMaxSpeed = Turbine_power_kW_maxSpeed - PowerNom*PowerReqLin - PowerReqConst;
velocityMaxSpeed = knot2ms*Cspeed.*PowerPropMaxSpeed.^expSpeed; %m/s

[qmG_kg_sMaxDepth, Turbine_power_kW_maxDepth, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency,...
 CombTempFlagDepth, TurbTempFlagDepth, SaturatedFlagDepth, deadFlagDepth, evapErosionFlagDepth, evapSuperFlagDepth, pumpSpeedExceedFlagDepth] = ...
        evalSystem(TurbID, PipeLength, EvapPnr, SuperPnr, ComprID,...
        FuelPumpID, CompN1,CompLoad1,CompN2,CompLoad2,  EvapFGfrac, PumpSpeedMaxVel, speedMaxDepth, mFuelMin);

PowerConst=2;
PowerLin = 0.05;
Pmin = PowerConst + PowerLin*PowerNom;
if Turbine_power_kW_maxDepth < Pmin
    flag_MAX_DEPTR = true;
else
    flag_MAX_DEPTR = false;
end


%return Vload, velocityMaxSpeed, kmMaxRange, maxDepth