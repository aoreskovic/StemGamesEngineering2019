function [Vload, MaxDepth, velocityMaxSpeed, kmMaxRange,...
CombTempFlagRange, TurbTempFlagRange, SaturatedFlagRange, deadFlagRange, evapErosionFlagRange, evapSuperFlagRange, pumpSpeedExceedFlagRange,...
CombTempFlagSpeed, TurbTempFlagSpeed, SaturatedFlagSpeed, deadFlagSpeed, evapErosionFlagSpeed, evapSuperFlagSpeed, pumpSpeedExceedFlagSpeed,...
CombTempFlagDepth, TurbTempFlagDepth, SaturatedFlagDepth, deadFlagDepth, evapErosionFlagDepth, evapSuperFlagDepth, pumpSpeedExceedFlagDepth, flag_MAX_DEPTR] =...
SolutionEval(file_name)

params = xlsread(file_name);

TurbID = params(1); 
assert(TurbID<=24, 'turbine number too high')
PipeLength = params(2);
assert(PipeLength>0, 'pipe length 0')
EvapPnr = params(3);
SuperPnr = params(4);
assert((EvapPnr+SuperPnr) <= 500, 'number of pipes too big')
ComprID =params(5);
assert(ComprID <= 30, 'compressor number too high')
FuelPumpID =params(6);
assert(FuelPumpID <= 24, 'compressor number too high')
CompN1 =params(7);
assert(CompN1 >= 0, 'comp N1 too low')
assert(CompN1 <=0.99, 'comp N1 too high')
CompLoad1 =params(8);
assert(CompLoad1 > 0, 'CompLoad1 too low')
assert(CompLoad1 <= 100, 'CompLoad1 too high')
CompN2 =params(9);
assert(CompN2 > CompN1, 'CompN2 too low')
assert(CompN2 <=1, 'CompN2 too high')
CompLoad2 = params(10);
assert(CompLoad2 > 0, 'CompLoad2 too low')
assert(CompLoad2 <= 100, 'CompLoad2 too high')
EvapFGfrac = params(11);
assert(EvapFGfrac >0, 'EvapFGfrac too low')
assert(EvapFGfrac <=1, 'EvapFGfrac too high')
mFuel =params(12);
mOxy =params(13);

PumpSpeedMaxVel=params(14);
assert(PumpSpeedMaxVel >=0, 'PumpSpeedMaxVel too low')
assert(PumpSpeedMaxVel <=1, 'PumpSpeedMaxVel too high')
depthMaxVel = params(15);
PumpSpeedMaxRange =params(16);
assert(PumpSpeedMaxRange >=0, 'PumpSpeedMaxRange too low')
assert(PumpSpeedMaxRange <=1, 'PumpSpeedMaxRange too high')
depthMaxRange = params(17);

speedMaxDepth = params(18);
assert(speedMaxDepth >=0, 'speedMaxDepth too low')
assert(speedMaxDepth <=1, 'speedMaxDepth too high')
MaxDepth = params(19);


PowerReqConst = 2; %kW
PowerReqLin = 0.05;



Lsub = 18;

%propulsion length
aProp = 18;
bProp = 2500;
[PowerNom, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, TmaxTurb] = Turbines(TurbID);
Lturb = (aProp*PowerNom+bProp)/1000;
assert(PipeLength <= Lturb, 'pipe length over limit %f', Lturb)

%fuel and oxy tank length
Rtank = 1.5; %fuel tank radius
roOxy = 1141; %density oxygen
roFuel = 789; %fuel density
Loxy = mOxy/roOxy/pi()/(Rtank*Rtank);
Lfuel = mFuel/roFuel/pi()/(Rtank*Rtank);


Lload = Lsub-Lturb-Loxy-Lfuel - 2; % remaining length for load storage

Vload = Lload*pi()*Rtank*Rtank;

OxyMol = mOxy/18;
FuelMolOxy = OxyMol/3;
FuelOxyMass = FuelMolOxy*46;
mFuelMin = min(FuelOxyMass, mFuel);
%try
    [qmG_kg_sMaxRange, Turbine_power_kW_maxRange, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency,...
     CombTempFlagRange, TurbTempFlagRange, SaturatedFlagRange, deadFlagRange, evapErosionFlagRange, evapSuperFlagRange, pumpSpeedExceedFlagRange] = ...
            evalSystem(TurbID, PipeLength, EvapPnr, SuperPnr, ComprID,...
            FuelPumpID, CompN1,CompLoad1,CompN2,CompLoad2,  EvapFGfrac, PumpSpeedMaxRange, depthMaxRange, mFuelMin);
%catch
%     qmG_kg_sMaxRange =0;
%     Turbine_power_kW_maxRange =0;
%     CombTempFlagRange =0;
%     TurbTempFlagRange =0;
%     SaturatedFlagRange =0;
%     deadFlagRange =0;
%     evapErosionFlagRange =0;
%     evapSuperFlagRange =0;
%      pumpSpeedExceedFlagRange =0;
% end
PowerPropMaxRange = Turbine_power_kW_maxRange - PowerNom*PowerReqLin - PowerReqConst;
Cspeed = 2.0135;
expSpeed = 0.3518;
knot2ms = 0.514444;
velocityMaxRange = knot2ms*Cspeed.*PowerPropMaxRange.^expSpeed; %
timeMaxRange = mFuelMin/qmG_kg_sMaxRange;
distanceMaxRange = velocityMaxRange*timeMaxRange;
hoursMaxRange = timeMaxRange/3600;
kmMaxRange = distanceMaxRange/1000;
    
%  try
    [qmG_kg_sMaxSpeed, Turbine_power_kW_maxSpeed, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency,...
     CombTempFlagSpeed, TurbTempFlagSpeed, SaturatedFlagSpeed, deadFlagSpeed, evapErosionFlagSpeed, evapSuperFlagSpeed, pumpSpeedExceedFlagSpeed, maxDepth] = ...
            evalSystem(TurbID, PipeLength, EvapPnr, SuperPnr, ComprID,...
            FuelPumpID, CompN1,CompLoad1,CompN2,CompLoad2,  EvapFGfrac, PumpSpeedMaxVel, depthMaxVel, mFuelMin);
    assert(depthMaxRange<=maxDepth, 'range depth too low, max is  %f',  depthMaxRange)
    assert(depthMaxVel<=maxDepth, 'velocity depth too low, max is  %f',  depthMaxRange)
    assert(MaxDepth<=maxDepth, 'max given depth too low, max is  %f',  depthMaxRange)
% catch
%     Turbine_power_kW_maxSpeed = 0;
%     CombTempFlagSpeed =0;
%     TurbTempFlagSpeed =0;
%     SaturatedFlagSpeed = 0;
%     deadFlagSpeed = 0;
%     evapErosionFlagSpeed = 0;
%     evapSuperFlagSpeed = 0;
%     pumpSpeedExceedFlagSpeed =0;
%     maxDepth =0;
% end

    





PowerPropMaxSpeed = Turbine_power_kW_maxSpeed - PowerNom*PowerReqLin - PowerReqConst;
velocityMaxSpeed = knot2ms*Cspeed.*PowerPropMaxSpeed.^expSpeed; %m/s

%try
    [qmG_kg_sMaxDepth, Turbine_power_kW_maxDepth, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency,...
     CombTempFlagDepth, TurbTempFlagDepth, SaturatedFlagDepth, deadFlagDepth, evapErosionFlagDepth, evapSuperFlagDepth, pumpSpeedExceedFlagDepth] = ...
            evalSystem(TurbID, PipeLength, EvapPnr, SuperPnr, ComprID,...
            FuelPumpID, CompN1,CompLoad1,CompN2,CompLoad2,  EvapFGfrac, PumpSpeedMaxVel, speedMaxDepth, mFuelMin);
% catch
%     Turbine_power_kW_maxDepth = 0;
%     CombTempFlagDepth =0;
%     TurbTempFlagDepth = 0;
%     SaturatedFlagDepth =0;
%     deadFlagDepth =0;
%     evapErosionFlagDepth =0;
%     evapSuperFlagDepth =0;
%     pumpSpeedExceedFlagDepth =0;
% end
    
PowerConst=2;
PowerLin = 0.05;
Pmin = PowerConst + PowerLin*PowerNom;
if Turbine_power_kW_maxDepth < Pmin
    flag_MAX_DEPTR = true;
else
    flag_MAX_DEPTR = false;
end


%return Vload, velocityMaxSpeed, kmMaxRange, maxDepth