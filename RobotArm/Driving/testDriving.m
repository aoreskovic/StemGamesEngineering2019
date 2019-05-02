clear all; clc;

simulation_params;
Tsim = 200;
Ts = 0.1;
distanceGain = 5/2;
timeGain = 500/3;

pointOne = [8 5.15 0];
pointTwo = [-7.5 2.9 7.5]; %Rijeseno
pointThree = [0 2.4 2.5]; %Rijeseno

refPointsVector = [pointThree, pointOne, pointThree, pointTwo, pointThree];

actuatorRefOne = [0, 0.7, 3.4, 3.4, 6150];
actuatorRefTwo = [-135, 0.415, 3.4, 3.4, 4300];
actuatorRefThree = [-90, 0.8, 0, 0, 2000];
actuatorRefVector = [actuatorRefThree; actuatorRefOne,; actuatorRefThree; actuatorRefTwo; actuatorRefThree];

%%
loadStatus = 0;
resultsFolder = "./";
resultStatus = WriteDrivingResults(resultsFolder, loadStatus, activeTime, performanceCost, pointIndex, isFinished);