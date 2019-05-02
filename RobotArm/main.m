teamFolder = pwd + "/InputFiles";
Ts = 0.05;

%% TASK 1 KINEMATICS
clearvars -except teamFolder
solutionFolder = teamFolder + "/Kinematics/Solution/";
readOnlyFolder = teamFolder + "/Kinematics/Ref/";

if isSimulationActive(solutionFolder, "result.txt")
    run('kran/simulation_params.m')
    run('Kinematics/simulate_kinematics.m')
end  

%% TASK 2 IDENTIFICATION

clearvars -except teamFolder
solutionFolder = teamFolder + "/Identification/Solution/";
readOnlyFolder = teamFolder + "/Identification/Ref/";
identifyFolder = teamFolder + "/Identification/Identify/";

% needed to start simulation
rotValve = [0, [0]]; transValve1 = [0, [0]]; transValve2 = [0, [0]]; 
baseVoltage = [0, [0]]; pulleyVoltage = [0, [0]];

% simulate identification
if isSimulationActive(identifyFolder + "Input/", "result.txt")
    run('kran/simulation_params.m')
    %run('Identification/simulate_identification.m')
end  

% test identification
if isSimulationActive(solutionFolder, "result.txt")
    run('kran/simulation_params.m')
    run('Identification/test_identification.m')
end  

%% TASK 3 DRIVING
clearvars -except teamFolder Ts 
solutionFolder = teamFolder + "/Driving/Regulators/";
readOnlyFolder = teamFolder + "/Driving/C/";

if isSimulationActive(solutionFolder, "result.txt")
    % needed to start simulation
    rotValve = [0, [0]]; transValve1 = [0, [0]]; transValve2 = [0, [0]]; 
    baseVoltage = [0, [0]]; pulleyVoltage = [0, [0]];
    run('kran/simulation_params.m')
    run('Driving/simulate_driving.m')
end