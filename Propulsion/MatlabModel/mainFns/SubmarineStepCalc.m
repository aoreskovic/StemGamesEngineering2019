function [sub] = SubmarineStepCalc(sub, Npump, depth)
%% fuel pump
pFG=depth*sub.Env.g*sub.Env.density + sub.Env.pAtm+sub.Fuel.Pump.dPcomb;
[sub.Fuel.Pump] = fuel_pump_pos(Npump, pFG, sub.Fuel.Pump, sub.Env);

%% fuel tank
sub.Fuel = fuel_tank(sub.Fuel);
assert(sub.Fuel.Tank.fuelMass >= 0, 'Fuel tank empty')

%% combustion
sub.Compr = compressor(sub.Fuel.Pump.Nallowed, sub.Compr);
[sub.FG] = Combustion_chamber( sub.Fuel.Pump.qm, sub.FG, sub.Compr);

%% evaporation
[sub.HE, sub.FG, sub.Steam] =Evaporator(sub.HE, sub.FG, sub.Steam, pFG);

%% superheating
[sub.HE, sub.FG, sub.Steam] = Superheater( sub.HE, sub.FG, sub.Steam, pFG);

%% mixing
[sub.Compr.Tret] = flueGasMix(sub.FG.HE.Evap, sub.FG.HE.Super);
%% turbine
[sub.Steam, sub.Turb, ~, ~, ~] = throttling(sub.Steam, sub.Turb);
[sub.Steam, sub.Turb] = Turbine(sub.Steam, sub.Turb);

%% condensation
[sub.Steam] = Condenser(sub.Steam);

%% pump
[sub.CondPump, sub.Steam] = Condensate_pump(sub.CondPump, sub.Steam);

%% test functions
[sub.x, sub.y, sub.vx, sub.vy, sub.t] = RandomPosition(); %This has to be replaced by mechanics function

end


