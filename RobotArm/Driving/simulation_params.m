%% SIMULATION DATA
Tsim = 100;
Ts = 50e-3;

%% HYDRAULIC DATA
% Hydraulic rot
rotRadiusOut = 110;
rotRadiusIn = 100;
rotRadiusShaft = 25;
rotStroke = 800;
rotRadiusDeadVol = 90;
rotHeightDeadVol = 30;

rotPistonAreaA = rotRadiusIn^2*pi;
rotPistonAreaB = rotPistonAreaA - rotRadiusShaft^2*pi;
rotDeadVolA = rotRadiusDeadVol^2*pi*rotHeightDeadVol;
rotDeadVolB = rotDeadVolA - rotRadiusShaft^2*pi*rotHeightDeadVol;

rotDamping = 5e5;

% Hydraulic trans
transRadiusOut = 60;
%transRadiusIn = 75;
transRadiusIn = 50;
transStroke = 3500;
transRadiusShaft = 37.5/2;
transRadiusDeadVol = 40;
transHeightDeadVol = 30;

transPistonAreaA = transRadiusIn^2*pi;
transPistonAreaB = transPistonAreaA - transRadiusShaft^2*pi;
transDeadVolA = transRadiusDeadVol^2*pi*transHeightDeadVol;
transDeadVolB = transDeadVolA - transRadiusShaft^2*pi*transHeightDeadVol;

transOneDamping = 5e5;
transTwoDamping = 5e5;