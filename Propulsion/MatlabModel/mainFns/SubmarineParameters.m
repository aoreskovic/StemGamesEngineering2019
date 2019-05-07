function [Sub] = SubmarineParameters(Sub)
%% Parameters that should not be changed

%heat exchanger parameters
Sub.Steam.HE.Evap.steamHTC = 3500; %W/m2K, steam side (shell side) evaporator heat transfer coefficient
Sub.Steam.HE.Super.steamHTC = 70; %W/m2K, steam side (shell side) superheater heat transfer coefficient

%fuel parameters
Sub.Fuel.Tank.density = 789; %kg/m3, fuel density
Sub.Fuel.Tank.timestep = 1; %s, calculation timestep
Sub.Fuel.Pump.density = 789;
%environmental parameters
Sub.Env.density = 1000; %kg/m3, density of water which surrounds submarine
Sub.Env.g = 9.81; % m/s2, standard acceleration due to gravity
Sub.Env.pAtm = 101325; %Pa, atmospheric pressure on surface

%combustion chamber parameters
Sub.FG.Comb.ToxyIn = 10; %°C, temperature at which oxygen enters combustion chamber
Sub.FG.Comb.TfuelIn = 10; %°C, temperature at which fuel enters combustion chamber
Sub.FG.M_ethanol = 46; %kg/kmol, ethanol molar mass 
Sub.FG.M_CO2 = 44;  %kg/kmol, carbon dioxide molar mass 
Sub.FG.M_H2O = 18; %kg/kmol, water molar mass
Sub.FG.fuelHeatVal = 1366940; % kJ/kmol, ethano lower heating value
Sub.FG.O2ratio = 3; % oxygen to ethanol combustion ratio
Sub.FG.CO2ratio = 2; % carbon dioxide to ethanol combustion ratio
Sub.FG.H2Oratio = 3; % carbon dioxide to ethanol combustion ratio
Sub.FG.fuelMeancp = 2.503;
Sub.FG.Mfg = Sub.FG.H2Oratio/(Sub.FG.H2Oratio+Sub.FG.CO2ratio)*Sub.FG.M_H2O...
    + Sub.FG.CO2ratio/(Sub.FG.H2Oratio+Sub.FG.CO2ratio)*Sub.FG.M_CO2; % kg/kmol, flue gas mixture molar mass


%condensate pump params
Sub.CondPump.eta = 0.75; % [-] condensate pump efficiency
Sub.Steam.qmSteam = 0; %kg/s, steam flow rate, dummy variable

%% Initial parameters calculation

%turbine params
[Power, p_evap, T1_ref, p_cond, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(Sub.Turb.id);
theta_evap = XSteam('Tsat_p', p_evap); %°C,  evaporation temperature
Sub.Turb.Pnom = Power; % kW, turbine nominal power
Sub.Turb.pInNom = p_evap; % bar, turbine nominal inlet pressure
Sub.Turb.TinNom = T1_ref; %°C, inlet nominal turbine temperature
Sub.Turb.pOut = p_cond; % bar, turbine outlet pressure
Sub.Steam.Turb.pOut = Sub.Turb.pOut;
Sub.Turb.K = K_stodola; % kg*sqrt(K)/(bar*s), turbine Stodola coefficient
Sub.Turb.aEta = a_eta; % s?2/m?6,first turbine efficiency coefficient (not used in calculation)
Sub.Turb.bEta = b_eta; %s/m^3, second turbine efficiency coefficient (not used in calculation)
Sub.Turb.cEta = c_eta; %-, third turbine efficiency coefficient (not used in calculation)
Sub.Turb.qmNom = qmd_ref; %kg/s, turbine nominal steam flow rate
Sub.Turb.etaNom = eta_nom; %-, turbine efficiency at nominal working conditions
Sub.Turb.etaCurvature = a_turb; %s^2/m^6, efficiency curve cuvature (aEta/etaNom)
qv_inlet_nom = qmd_ref * XSteam('v_pT', p_evap, T1_ref); %m3/s, nominal steam volume flow rate
s1_nom = XSteam('s_pT', p_evap, T1_ref);
qv_outlet_nom = qmd_ref*XSteam('v_ps', p_cond, s1_nom);
Sub.Turb.qvNom = sqrt(qv_inlet_nom*qv_outlet_nom); %m^3/s, mean nominal steam volume flow rate through turbine



%heat exchanger pipe parameters
[extDiameter,thickness, conductivity] = PipeSelect(Sub.HE.Pipe.id); %%%% nova verzija kad dobijem dimenzije cijevi
Sub.HE.Pipe.dExt = extDiameter; %m, pipe external diameter
Sub.HE.Pipe.thickness = thickness; %m, pipe thickness
Sub.HE.Pipe.conductivity = conductivity; %W/mK, pipe thermal conductivity
%heat exchanger evaporative section parameters
[AinternalEvap,AwallEvap, dInternal]= exchanger_params(Sub.HE.Pipe, Sub.HE.Evap);
Sub.HE.Evap.intArea = AinternalEvap; %m2, internal pipe crossection area of all evaporator pipes (flue gas flow area)
Sub.HE.Evap.wallAreaExt = AwallEvap; %m2, external pipe wall area of all evaporator pipes (heat transfer area)
Sub.HE.Pipe.dInt = dInternal; %m, pipe internal diameter
Sub.Steam.HE.Evap.Tsteam = theta_evap; %°C, steam temperature at evaporator
Sub.Steam.HE.p = p_evap; % bar, pressure in evaporator and superheater
%heat exchanger superheating section parameters
[AinternalSuper,AwallSuper, ~]= exchanger_params(Sub.HE.Pipe, Sub.HE.Super);
Sub.HE.Super.intArea = AinternalSuper; %m2, internal pipe crossection area of all superheater pipes (flue gas flow area)
Sub.HE.Super.wallAreaExt = AwallSuper; %m2, external pipe wall area of all superheater pipes (heat transfer area)
Sub.Steam.HE.Super.TsteamIn = theta_evap; %°C, steam temperature at superheater inlet


%fuel pump parameters
[qvFuelMax,hMax, Nmin, kPipe] = FuelPumps(Sub.Fuel.Pump.id);
Sub.Fuel.Pump.qvMax = qvFuelMax; %l/h, fuel pump maximum flow rate
Sub.Fuel.Pump.hMax = hMax; %m, maximal fuel pump head
Sub.Fuel.Pump.Nmin = Nmin; %-, minimal fuel pump relative speed
Sub.Fuel.Pump.kPipe = kPipe; %m*h^2/l^2, pipe friction coefficient for selected pump
Sub.Fuel.Pump.dPcomb = 100000; %Pa, pressure difference between combustion chamber and environment

Q_min = qvFuelMax*Nmin; % l/h, minimal fuel pump volume flow rate
h_pumpMax = hMax-kPipe*Q_min*Q_min; %m, maximal pump static head
pmax = h_pumpMax*Sub.Fuel.Pump.density*Sub.Env.g + Sub.Env.pAtm ; %Pa, maximal pressure at which pump can work

Sub.Env.maxDepth = floor((pmax-Sub.Env.pAtm-Sub.Fuel.Pump.dPcomb)/(Sub.Env.g*Sub.Env.density));
Sub.Env.pMax = pmax; %maximal pressure at which fuel pump can operate



%compressor parameters:
[CompqmMin,CompqmMax] = Compressors(Sub.Compr.id);
Sub.Compr.qmMin = CompqmMin; %kg/h, minimal available returning flue gas mass flow rate
Sub.Compr.qmMax = CompqmMax; %kg/h, maximal available returning flue gas mass flow rate

%condensate pump params
Sub.Steam.CondPump.pIn = p_cond; % bar, condensate pump inlet pressure
Sub.Steam.CondPump.pOut = p_evap; % bar, condensate pump outlet pressure
[Sub.CondPump, Sub.Steam] = Condensate_pump(Sub.CondPump, Sub.Steam); % initial enthalpy after pump stage

%condenser parameters
Sub.Steam.Cond.p = p_cond; %bar, condensation pressure
Sub.Steam.Cond.hOut = XSteam('hL_p', p_cond); %kJ/kg, enthalpy at condenser outlet





