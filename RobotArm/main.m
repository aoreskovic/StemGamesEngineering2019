clear all; % Obavezno ocistiti persistent varijable!!!
Ts = 0.05;

lockName = string(java.net.InetAddress.getLocalHost.getHostName);

teams = ["Akvanauti", "Božje ovèice", "Divljaè velikog momenta tromosti"];

teamFolders = [];
for team=teams
    teamFolders = [teamFolders, string(pwd) + "\Teams\" + team];
end

while(1)

for teamFolder=teamFolders    
    %% TASK 1 KINEMATICS
    clearvars -except teamFolder Ts lockName
    solutionFolder = teamFolder + "/Kinematics/Solution/";
    readOnlyFolder = teamFolder + "/Kinematics/Ref/";

    if isSimulationActive(solutionFolder, readOnlyFolder, "result.txt")
        lockTask(readOnlyFolder, lockName);
        run('kran/simulation_params.m')
        run('Kinematics/simulate_kinematics.m')
        unlockTask(readOnlyFolder);
    end  

    %% TASK 2 IDENTIFICATION

    clearvars -except teamFolder Ts lockName
    solutionFolder = teamFolder + "/Identification/Solution/";
    readOnlyFolder = teamFolder + "/Identification/Ref/";
    identifyFolder = teamFolder + "/Identification/Identify/";
    signalsFolder = teamFolder + "/Identification/Signals/";

    numTestCases = 5;

    % needed to start simulation
    rotValve = [0, [0]]; transValve1 = [0, [0]]; transValve2 = [0, [0]]; 
    baseVoltage = [0, [0]]; pulleyVoltage = [0, [0]];

    % simulate identification
    if isSimulationActive(identifyFolder + "Input/", identifyFolder + "Output/", "result.txt")
        lockTask(identifyFolder + "Output/", lockName);
        run('kran/simulation_params.m')
        run('Identification/simulate_identification.m')
        unlockTask(identifyFolder + "Output/");
    end  

    % test identification
    if isSimulationActive(solutionFolder, readOnlyFolder, "result.txt")
        lockTask(readOnlyFolder, lockName);
        run('kran/simulation_params.m')
        run('Identification/test_identification.m')
        unlockTask(readOnlyFolder);
    end  

    %% TASK 3 DRIVING
    %clear RobotArm/EvalugateTrajectory;

    solutionFolder = teamFolder + "/Driving/Regulators/";
    readOnlyFolder = teamFolder + "/Driving/Ref/";
    Tsim = 250;

    % needed to start simulation
    rotValve = [0, [0]]; transValve1 = [0, [0]]; transValve2 = [0, [0]]; 
    baseVoltage = [0, [0]]; pulleyVoltage = [0, [0]];

    if isSimulationActive(solutionFolder, readOnlyFolder, "result.txt")
        lockTask(readOnlyFolder, lockName);
        run('kran/simulation_params.m')
        run('Driving/simulate_driving.m')
        unlockTask(readOnlyFolder);
    end
    
end


end