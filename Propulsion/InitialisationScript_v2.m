clear all

%% INPUTS:
input = 'pumpSpeed'; %Uncomment for direct pump speed control
%input = 'PID'; %Uncomment for PID pump speed control based on required turbine power
switch input
    case 'pumpSpeed'
        pumpSpeed_values = [ones(1,100)*0.8, 0.8:-0.01:0.35, ones(1,100)*0.35, 0.35:0.01:0.9, ones(1,100)*0.9, 0.9:-0.01:0.5, ones(1,100)*0.5]; %Pump speed profile
        %pumpSpeed_values = repmat(pumpSpeed_values, 1, 10); %Profile repeat
        seconds = length(pumpSpeed_values); %simulation duration
        V = Simulink.Parameter(1); %for variant subsystem control
        
    case 'PID'
        Power_values = [ones(1,200)*70, ones(1,200)*45, ones(1,100)*98]; %Required power profile
        Power_values  = repmat(Power_values, 1, 10); %Profile repeat
        seconds = length(Power_values); %simulation duration
        V = Simulink.Parameter(2); %for variant subsystem control
end


%% MODEL PARAMETERS:

%submarine
sub.radius = 1.5;
sub.length = 18 + sub.radius;
sub.max_depth = 100;

%turbine
turbineNR = 16; %selected turbine

%heat exchangers
pipeNR = 1; %selected pipe
pipeLength = 3.66; %evaporator and condenser, m
numberOfPipesEvap = 136; %number of tubes in evaporator
numberOfPipesSuper = 39;
AlphaEvapSteam =3500; 
AlphaSuperSteam = 70;

%fuel pump
k_pipe          = 2e-3; %
rho_ethanole    = 789; %kg/m3, ethanole density
%fuel pump
Q_max           = 52.254728179762466;
h_max           = 1000;
N_min           = 0.35;
pressureFG      = 50*9.81*1000;
%fuel tank
fuel_mass       = 10000; %kg


%combustion chamber
thetaFuelIn     = 10; % [°C], fuel inlet tempearture 
thetaO2In       = 10; % [°C], oxygen inlet tempearture 
returnFGdelay   = 3; %s - flue gas return delay from mixing hamber to combustion chamber
theta_ret       = 227.95; % °C, initial flue gas return temperature

%compressor_params:
qnRetlow = 0.010585505714826;
qnRetMin = qnRetlow*0.6;
qnRetMax = qnRetlow*1.2;
qnRethigh = qnRetlow*1.2;
Nretlow = 0.8;
Nrethigh = 1;

%flow divider
evapFraction    = 0.938024869450723; % -, fraction of gases entering evaporator from total flue gases which leave combustion chamber

%condensate pump
CpumpEta        = 0.75; % condensate pump efficiency, -

%% SIMULATION CONTROL PARAMETERS
stopTime = seconds; %simulation duration
maxStepSize = 1; %simulation maximum step size

%% CALCULATIONS:
%submarine
sub.mass = sub_mass(sub.length, sub.radius, sub.max_depth, 1, 1.5);

%turbine and valve
[~, p1, theta1_nom, p2, K_stodola, ~, ~, ~, qmd_ref, a_turb, eta_nom] = Turbines(turbineNR);

%heat exchanger (condenser and superheater) parameters calculation
[extDiameter,thickness, conductivity, max_W] = Pipes(pipeNR);
[AinternalEvap,AwallEvap, dInternal]= exchanger_params(extDiameter,thickness, ...
    pipeLength, numberOfPipesEvap); %evaporative part of HE parameters calculation
[AinternalSuper,AwallSuper, ~]= exchanger_params(extDiameter,thickness, ...
    pipeLength, numberOfPipesSuper); %superheating part of HE parameters calculation


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
