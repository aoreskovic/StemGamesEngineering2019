%% parameters
clear all
timestep = 1; %s, calculation timestep

%fuel tank parameters
m_fuel_init = 5000; %kg, initial fuel mass


turbineNR = 11; %selected turbine
pipeNR = 1; %selected pipe
pipeLength = 2.92; %evaporator and condenser, m
numberOfPipesEvap = 84; %number of tubes in evaporator
numberOfPipesSuper = 19;
evapRatio = 0.950279004924077;

AlphaEvapSteam =3500; 
AlphaSuperSteam = 70;

%compressor_params:
qnRetlow = 0.006446299232371;
qnRetMin = qnRetlow*0.6;
qnRetMax = qnRetlow*1.2;
qnRethigh = qnRetlow*1.2;
Nretlow = 0.8;
Nrethigh = 1;

rho_ethanole = 789; %kg/m3, ethanole density
%pump_speed_vector = [ones(1,100)*0.8, 0.8:-0.01:0.5, ones(1,100)*0.5, 0.5:0.01:1, ones(1,100)*1] ;
%pump_speed_vector = [0.35:0.01:1]
pump_speed_vector= [ones(1,100)*0.8];
depth = ones(1,length(pump_speed_vector))*50;

%depth = [ones(1,50)*50, 50:1:200, ones(1,50)*200, 200:1:500, ones(1,50)*500];
%pump_speed_vector = [ones(1,length(depth))*0.8];

roWater= 1000;
g=9.81;
Q_max=31.796278818746497;
h_max = 1000;
pFG = depth(1)*g*roWater;
N_min = 0.35;
k = 2e-3;






[Power, p1, T1_ref, p2, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(turbineNR);
[extDiameter,thickness, conductivity, max_W] = Pipes(pipeNR);
[AinternalEvap,AwallEvap, dInternal]= exchanger_params(extDiameter,thickness, ...
    pipeLength, numberOfPipesEvap);
[AinternalSuper,AwallSuper, ~]= exchanger_params(extDiameter,thickness, ...
    pipeLength, numberOfPipesSuper);
theta_evap = XSteam('Tsat_p', p1); %°C,  evaporation temperature
theta_ret = 242.58;

%pump parameters
etaP =0.75; % [-] pump efficiency
[~, h4, ~ ] = Condensate_pump( p2, p1, 1, etaP); % initial enthalpy after pump stage


%initialisation of vectors used for storing results
times = length(pump_speed_vector); %s, number of timesteps in calculation
Time_s = (1:times)';
qmG_kg_s = zeros(times, 1);
Q_l_h = zeros(times, 1);
h_m = zeros(times, 1);
P_fuelPump_W = zeros(times, 1);
Turbine_power_kW = zeros(times, 1);
theta_fg1_degC = zeros(times, 1);
theta_fg2Evap_degC = zeros(times, 1);
theta_ret_degC = zeros(times, 1);
qm_d_kg_s = zeros(times, 1);
qv_d_m3_s = zeros(times, 1);
p1_thr_bar = zeros(times, 1);
theta_1_degc = zeros(times, 1);
theta_1thr_degc = zeros(times, 1);
x__ = zeros(times, 1);
eta_turb__ = zeros(times, 1);
v_fg_super_m_s = zeros(times, 1);
v_fg_evap_m_s = zeros(times, 1);
alfaTEvap_Wm2K = zeros(times, 1);
alfaTSuper_Wm2K = zeros(times, 1);
k_evap_Wm2K = zeros(times, 1);
k_super_Wm2K = zeros(times, 1);
system_efficiency = zeros(times, 1);
flag1_vect =  zeros(times, 1);
flag2_vect = zeros(times, 1);
fuel_kg = zeros(times, 1);
theta_fg2Super_degC = zeros(times, 1);
m_fuel = m_fuel_init;
%%  calculation
for i=1:times
    %% fuel pump
    pump_speed = pump_speed_vector(i);
    pFG=depth(i)*g*roWater;
    [qmG,Q, h] = fuel_pump_pos(pump_speed,h_max, Q_max, N_min, pFG, k);

    %% fuel tank
    m_fuel = fuel_tank(m_fuel, qmG, timestep);
    assert(m_fuel >= 0, 'Fuel tank empty')
    
    %% combustion
    %qmG = qmG_vect(i); %kg/s, fuel mass flow rate in this time step 
    %ret = qmG_nom/M_ethanol * const_ret_coef + (qmG-qmG_nom)/M_ethanol * lin_ret_coef; %kmol/kmolG, molar flow rate of return flue gas reduced to fuel molar flow rate in time step
    qnRet = compressor(pump_speed, qnRetMin,qnRetMax, qnRetlow, qnRethigh, Nretlow, Nrethigh);
    [theta_fg1, qn_H2O, qn_CO2] = Combustion_chamber( qmG, theta_ret, qnRet);

    %% evaporation
    qn_H20evap = evapRatio*qn_H2O; % [kmol/s] water steam flue gas flow rate through evaporation part of exchanger
    qn_CO2evap = evapRatio*qn_CO2; % [kmol/s] CO2 flue gas flow rate through evaporation part of exchanger
    [Fi_isp, qm_d, theta_fg2_evap, h5, AlfaTEvap, k_evap, w_fg_evap] = ...
        Evaporator(qn_H20evap, qn_CO2evap, theta_fg1, theta_evap, h4, p1, ...
        AwallEvap, AinternalEvap, dInternal, extDiameter, conductivity, ...
        AlphaEvapSteam, pFG, pipeLength);

    %% superheating
    qn_H20super = (1-evapRatio)*qn_H2O; % [kmol/s] water steam flue gas flow rate through superheating part of exchanger
    qn_CO2super = (1-evapRatio)*qn_CO2; % [kmol/s] CO2 flue gas flow rate through superheating part of exchanger
    %[v_fg_superIn,v_d_superIn] = superheater_inlet_velocity(pipesFlowAreaInternal,flueGasFlowArea, qm_d, p1, qn_H2O, qn_CO2, theta_dp2);
    [Fi_preg, theta_fg2_super, theta1, h1, AlfaTSuper, k_super, Cfg, Csteam,...
        w_fg_super] = Superheater( qm_d, theta_fg1, qn_H20super, qn_CO2super,...
        theta_evap, p1, AwallSuper, AinternalSuper, dInternal, extDiameter,...
        conductivity, AlphaSuperSteam, pFG,pipeLength);

   %% mixing
    [theta_ret] = flueGasMix(qn_H20evap, qn_CO2evap, theta_fg2_evap, qn_H20super, qn_CO2super,theta_fg2_super);
    %% turbine
    %eta_turb = turbine_efficiency(qm_d, qmd_max, turbine_type);
    [p1_thr, theta1_thr, eta_turb, qv_d, ~, ~, ~] = throttling(qm_d, theta1, p1 , p2, K_stodola, T1_ref, qmd_ref, eta_nom, a_turb);

    [Power, theta2, h2, s2, x2 ] = Turbine( p1_thr, theta1_thr, p2, qm_d, eta_turb);

    %% condensation
    [ Fi_kond, theta3, h3 ] = Condenser(p2, h2, qm_d);
    
    %% pump
    [ theta4, h4, FiPumpa ] = Condensate_pump(p2, p1, qm_d, etaP);
    
    %% store results
    qmG_kg_s(i) = qmG; % [kg/s] Fuel mass flow rate
    fuel_kg(i) = m_fuel; %[kg] remaining fuel mass
    Q_l_h(i) = Q; % [m3/h] Fuel volume flow
    h_m(i) = h; % [mm] Fuel pump head
    Turbine_power_kW(i) =  Power; % [kW] Turbine power vector
    theta_fg1_degC(i)= theta_fg1; % [°C] flue gas temperature on combustion chamber exit vector
    theta_fg2Evap_degC(i) = theta_fg2_evap; % [°C] flue gas temperature on evaporator  exit vector
    theta_fg2Super_degC(i) = theta_fg2_super; % [°C] flue gas temperature on superheater  exit vector
    theta_ret_degC(i) = theta_ret; % [°C] returning flue gas temperature vector
    qm_d_kg_s(i) = qm_d; % [kg/s] evaporated vapour mass flow rate vector
    qv_d_m3_s(i) = qv_d; % [m3/s] evaporated vapour volume flow rate vector
    p1_thr_bar(i) = p1_thr; % [bar] pressure after throttling
    theta_1_degc(i) = theta1; % [°C] superheated vapour temperature
    theta_1thr_degc(i) = theta1_thr; % [°C] temperature after throttling
    x__(i) = x2; % [-] turbine outlet vapour fraction vector
    eta_turb__(i) = eta_turb; % [-] turbine efficiency vector
    v_fg_evap_m_s(i) = w_fg_evap; % [m/s] steam velocity at superheater inlet
    v_fg_super_m_s(i) = w_fg_super; % [m/s] flue gas velocity at superheater inlet
    alfaTEvap_Wm2K(i) = AlfaTEvap; % [W/m2K] evaporator heat transfer coefficient on tube side (fg)
    alfaTSuper_Wm2K(i) = AlfaTSuper; % [W/m2K] superheater heat transfer coefficient on tube side (fg)
    k_evap_Wm2K(i) = k_evap; % [W/m2K] evaporator overall heat transfer coefficient
    k_super_Wm2K(i) = k_super; % [W/m2K] superheater overall heat transfer coefficient
    system_efficiency(i) = Power/(1366940 * qmG / 46); % system overall efficiency


end

%% results table creation
Results = table(Time_s, pump_speed_vector', qmG_kg_s, fuel_kg, Q_l_h, h_m, Turbine_power_kW, theta_fg1_degC,...
    theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, qm_d_kg_s, qv_d_m3_s, p1_thr_bar, theta_1_degc,...
    theta_1thr_degc, x__, eta_turb__, v_fg_evap_m_s, v_fg_super_m_s, alfaTEvap_Wm2K, alfaTSuper_Wm2K, k_evap_Wm2K,...
    k_super_Wm2K, system_efficiency);