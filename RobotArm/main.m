

teamFolder = pwd + "/InputFiles";



%% TASK 1 KINEMATICS
clearvars -except teamFolder
solutionFolder = teamFolder + "/Kinematics/Solution/";
refFolder = teamFolder + "/Kinematics/Ref/";
run('kran/simulation_params.m')

if length(dir(solutionFolder)) > 0
    run('Kinematics/simulate_kinematics.m')
end


%% TASK 2 IDENTIFICATION

clearvars -except teamFolder
solutionFolder = teamFolder + "/Identification/Solution/";
refFolder = teamFolder + "/Identification/Ref/";
run('kran/simulation_params.m')

if length(dir(solutionFolder)) > 0
    run('kran/simulate_driving.m')
end


%% TASK 3 DRIVING


