clear all

%% INPUTS:
input = 'pumpSpeed'; %Uncomment for direct pump speed control
%input = 'PID'; %Uncomment for PID pump speed control based on required turbine power
switch input
    case 'pumpSpeed'
        pumpSpeed_values = [ones(1,100)*0.7, 0.7:-0.01:0.45, ones(1,100)*0.45, 0.45:0.01:1, ones(1,100)*1, 1:-0.01:0.7]; %Pump speed profile
        pumpSpeed_values = repmat(pumpSpeed_values, 1, 10); %Profile repeat
        seconds = length(pumpSpeed_values); %simulation duration
        V = Simulink.Parameter(1); %for variant subsystem control
        
    case 'PID'
        Power_values = [ones(1,200)*70, ones(1,200)*45, ones(1,100)*98]; %Required power profile
        Power_values  = repmat(Power_values, 1, 10); %Profile repeat
        seconds = length(Power_values); %simulation duration
        V = Simulink.Parameter(2); %for variant subsystem control
end


%% MODEL PARAMETERS:
% system pressuress
p1              = 18; %bar  upper (evaporation) pressure
p2              = 0.6; %bar  lower (condensation) pressure

%fuel tank
fuel_mass       = 10000; %kg

%fuel pump
Q_nom           = 5.4/60; % [m3/h] fuel pump nominal volume flow rate
h_nom           = 4.2; %[m] fuel pump nominal head
P_nom        	= 100.7/60;
n_ref           = 0.76; %[-] nominal relative speed
rho_ethanole    = 789; %kg/m3, ethanole density

%combustion chamber
thetaFuelIn     = 10; % [°C], fuel inlet tempearture 
thetaO2In       = 10; % [°C], oxygen inlet tempearture 
qmG_nom         = 0.0183; % kg/s, nominal fuel mass flow rate %%% automatizirati!!!!
const_ret_coef  = 12; %, - flue gas constant return coefficient
lin_ret_coef    = 6; %, - flue gas linear return coefficient
returnFGdelay   = 3; %s - flue gas return delay from mixing hamber to combustion chamber
theta_ret       = 227.95; % °C, initial flue gas return temperature

%flow divider
evapFraction    = 0.95; % -, fraction of gases entering evaporator from total flue gases which leave combustion chamber

% evaporator
pipeDexternal   = 20/1000; % m, heat exchanger external pipe diameter
pipeThickness   = 2/1000; % m,  heat exchanger pipe thickness
pipeLength      = 4; % m,  heat exchanger pipe length
pipeConductiv   = 58; % W/(mK),  heat exchanger pipe material thermal conductivity
nPipesEvap      = 90;  %-, number of pipes in evaporation part of HE
nPipesSuper     = 10; %-, number of pipes in superheating part of HE
AlphaEvapSteam  =3500; % W/(m2K), water side evaporator heat transfer coefficient
AlphaSuperSteam = 70; % W/(m2K), water side superheater heat transfer coefficient

%throttling valve and turbine
theta1_nom      = 246.76; %valve inlet nominal temperature, °C
qmd_nom         = 0.2150; %nominal steam flow rate, kg/s
eta_nom         = 0.8; %efficiency at nominal working conditions, -
a_turb          = -7; % turbine quadratic efficiency coefficient
%K_stodola = qmd_nom*sqrt(theta1_nom+273.15)/(sqrt(p1*p1-p2*p2)); %Stodola constant [kg*sqrt(K)/(bar^2*s)]

%condensate pump
CpumpEta        = 0.75; % condensate pump efficiency, -

%% SIMULATION CONTROL PARAMETERS
stopTime = seconds; %simulation duration
maxStepSize = 1; %simulation maximum step size

%% CALCULATIONS:
%heat exchanger (condenser and superheater) parameters calculation
[AinternalEvap,AwallEvap, dInternal]= exchanger_params(pipeDexternal,pipeThickness, ...
    pipeLength, nPipesEvap); %evaporative part of HE parameters calculation
[AinternalSuper,AwallSuper, ~]= exchanger_params(pipeDexternal,pipeThickness, ...
    pipeLength, nPipesSuper); %superheating part of HE parameters calculation

%input matrix calculation
switch input
    case 'pumpSpeed'
        pumpSpeed = zeros(seconds, 2); %matrix initialisation
        pumpSpeed(:,1) = 1:seconds; % first column - time
        pumpSpeed(:,2)  =pumpSpeed_values'; %second column - values
    
    case 'PID'
        Power = zeros(seconds, 2); %matrix initialisation
        Power(:,1) = 1:seconds; % first column - time
        Power(:,2)  =Power_values'; %second column - values
end
