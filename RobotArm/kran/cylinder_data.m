% Hydraulic rot
rotRadiusOut = 110;
rotRadiusIn = 100;
rotRadiusShaft = 25;
rotStroke = 1160;
rotRadiusDeadVol = 90;
rotHeightDeadVol = 30;

rotPistonAreaA = rotRadiusIn^2*pi;
rotPistonAreaB = rotPistonAreaA - rotRadiusShaft^2*pi;
rotDeadVolA = rotRadiusDeadVol^2*pi*rotHeightDeadVol;
rotDeadVolB = rotDeadVolA - rotRadiusShaft^2*pi*rotHeightDeadVol;

% Hydraulic trans
transRadiusOut = 85;
transRadiusIn = 75;
transStroke = 3760;
transRadiusShaft = 37.5/2;
transRadiusDeadVol = 65;
transHeightDeadVol = 30;

transPistonAreaA = transRadiusIn^2*pi;
transPistonAreaB = transPistonAreaA - transRadiusShaft^2*pi;
transDeadVolA = transRadiusDeadVol^2*pi*transHeightDeadVol;
transDeadVolB = transDeadVolA - transRadiusShaft^2*pi*transHeightDeadVol;