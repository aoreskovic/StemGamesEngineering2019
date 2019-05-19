clear all
%% Parameters that need to be selected

%fuel tank parameters
Sub.Fuel.Tank.initMass = 5000; %kg, initial fuel mass

%turbine parameters
Sub.Turb.id = 16; %selected turbine

%heat exchanger parameters
Sub.HE.Pipe.id = 1; %selected heat exchanger pipe
Sub.HE.Pipe.length = 4.77; %m, heat exchanger pipe length
Sub.HE.Evap.nr = 89;  % number of tubes in evaporator
Sub.HE.Super.nr = 30; % number of tubes in superheater section

%compressor parameters
Sub.Compr.id = 16; % selected compressor

%fuel pump parameters
Sub.Fuel.Pump.id = 9; %selected fuel pump

%initial guess
Sub.Compr.Tret = 240; %°C, initial flue gas return temperature


%% parameters which can be changed in gui during model execution
Sub.FG.HE.Evap.FGfraction = 0.938569792280806; % fraction of total flue gas to evaporator

Sub.Compr.N1 = 0.5578; %-, fuel pump relative speed at which compressor load is L1
Sub.Compr.L1 =0.84; %-, compressor load at fuel pump speed N1
Sub.Compr.N2 = 0.95; %-, fuel pump relative speed at which compressor load is L2
Sub.Compr.L2 = 1; %-, compressor load at fuel pump speed N2


%% INPUTS
pump_speed_vector = [ones(1,100)*0.84];
depth = ones(1,length(pump_speed_vector))*50;

%% calculation of additional submarine parameters
Sub = SubmarineParameters(Sub);
assert(Sub.Env.maxDepth > max(depth), 'submarine depth over pump limit!');

%% initialisation of vectors used for storing results
times = length(pump_speed_vector); %s, number of timesteps in calculation
Time_s = (1:times)';
N_pump_allowed_ = zeros(times, 1);
qmG_kg_s = zeros(times, 1);
Q_l_h = zeros(times, 1);
h_m = zeros(times, 1);
P_fuelPump_W = zeros(times, 1);
Turbine_power_kW = zeros(times, 1);
theta_fg1_degC = zeros(times, 1);
theta_fg2Evap_degC = zeros(times, 1);
theta_ret_degC = zeros(times, 1);
qm_d_kg_s = zeros(times, 1);
qv_mean_m3_s = zeros(times, 1);
qv_rel_ = zeros(times, 1);
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

sub=Sub;
sub.Fuel.Tank.fuelMass = sub.Fuel.Tank.initMass; %at first step remaining fuel mass is exual to initial
%% Calculation of propusion system
for i=1:times
    [sub] = SubmarineStepCalc(sub, pump_speed_vector(i), depth(i));
    %% store results
    N_pump_allowed_(i) = sub.Fuel.Pump.Nallowed;
    qmG_kg_s(i) = sub.Steam.qmSteam; % [kg/s] Fuel mass flow rate
    fuel_kg(i) = sub.Fuel.Tank.fuelMass; %[kg] remaining fuel mass
    Q_l_h(i) = sub.Fuel.Pump.Q; % [m3/h] Fuel volume flow
    h_m(i) = sub.Fuel.Pump.h; % [mm] Fuel pump head
    Turbine_power_kW(i) =  sub.Turb.Power; % [kW] Turbine power vector
    theta_fg1_degC(i)= sub.FG.Comb.Tout; % [°C] flue gas temperature on combustion chamber exit vector
    theta_fg2Evap_degC(i) = sub.FG.HE.Evap.Tout; % [°C] flue gas temperature on evaporator  exit vector
    theta_fg2Super_degC(i) = sub.FG.HE.Super.Tout; % [°C] flue gas temperature on superheater  exit vector
    theta_ret_degC(i) = sub.Compr.Tret; % [°C] returning flue gas temperature vector
    qm_d_kg_s(i) = sub.Steam.qmSteam; % [kg/s] evaporated vapour mass flow rate vector
    qv_mean_m3_s(i) = sub.Steam.Turb.qvMean; % [m3/s] evaporated vapour mean volume flow rate through turbine vector
    qv_rel_(i) = sub.Steam.Turb.qvRel; %[-] vapor volume flow rate relative to nominal
    p1_thr_bar(i) = sub.Steam.Turb.pIn; % [bar] pressure after throttling
    theta_1_degc(i) = sub.Steam.HE.Super.Tout; % [°C] superheated vapour temperature
    theta_1thr_degc(i) = sub.Steam.Turb.Tin; % [°C] temperature after throttling
    x__(i) = sub.Steam.Turb.xOut; % [-] turbine outlet vapour fraction vector
    eta_turb__(i) = sub.Turb.eta; % [-] turbine efficiency vector
    v_fg_evap_m_s(i) = sub.FG.HE.Evap.wPipe; % [m/s] mean steam velocity at evaporator
    v_fg_super_m_s(i) = sub.FG.HE.Super.wPipe; % [m/s] mean flue gas velocity at evaporator
    alfaTEvap_Wm2K(i) = sub.FG.HE.Evap.tubeHTC; % [W/m2K] evaporator heat transfer coefficient on tube side (fg)
    alfaTSuper_Wm2K(i) = sub.FG.HE.Super.tubeHTC; % [W/m2K] superheater heat transfer coefficient on tube side (fg)
    k_evap_Wm2K(i) = sub.HE.Evap.k; % [W/m2K] evaporator overall heat transfer coefficient
    k_super_Wm2K(i) = sub.HE.Super.k; % [W/m2K] superheater overall heat transfer coefficient
    system_efficiency(i) = sub.Turb.Power/(sub.FG.fuelHeatVal * sub.Fuel.Pump.qm / sub.FG.M_ethanol); % system overall efficiency
end

Npump_set = pump_speed_vector'; %set values of pump speed
%% results table creation
Results = table(Time_s, Npump_set, N_pump_allowed_, qmG_kg_s, fuel_kg, Q_l_h, h_m, Turbine_power_kW, theta_fg1_degC,...
    theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, qm_d_kg_s, qv_mean_m3_s, qv_rel_, p1_thr_bar, theta_1_degc,...
    theta_1thr_degc, x__, eta_turb__, v_fg_evap_m_s, v_fg_super_m_s, alfaTEvap_Wm2K, alfaTSuper_Wm2K, k_evap_Wm2K,...
    k_super_Wm2K, system_efficiency);
