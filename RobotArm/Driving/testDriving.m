clear all; clc;

simulation_params;
Tsim = 300;
Ts = 0.1;
distanceGain = 5/6;
timeGain = 20;

pointOne = [8 -5 0];
pointTwo = [-7.5 -5 7.5];
pointThree = [0 0.5 2.5]; 

refPointsVector = [pointThree, pointOne, pointThree, pointTwo, pointThree];

actuatorRefOne = [0, 0.7, 3.4, 3.4, 14850];
actuatorRefTwo = [-135, 0.415, 3.4, 3.4, 11050];
actuatorRefThree = [-90, 0.8, 0, 0, 3700];
actuatorRefVector = [actuatorRefThree; actuatorRefOne; actuatorRefThree; actuatorRefTwo; actuatorRefThree];

%%
loadStatus = 0;
resultsFolder = "./";
%resultStatus = WriteDrivingResults(resultsFolder, loadStatus, activeTime, performanceCost, pointIndex, isFinished);