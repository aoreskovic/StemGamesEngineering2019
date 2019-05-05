clear all;
close all;

N = 3;
d = 0.05;
freq = 30e6;
vel = 1520;
lambda = vel/freq;

wantedEl = deg2rad(-60);
wantedAz = deg2rad(45);

bestYalpha = -2*pi/lambda*d*cos(wantedEl);
bestZalpha = -2*pi/lambda*d*cos(wantedAz);

%% Construct bfMatrix

basicY = exp(1i*bestYalpha).^[-1 0 1];
basicZ = exp(1i*bestZalpha).^[-1 0 1];

bfMatrix = [
    basicY(1).*basicZ(1) basicY(1).*basicZ(2) basicY(1).*basicZ(3) ...
    basicY(2).*basicZ(1) basicY(2).*basicZ(2) basicY(2).*basicZ(3) ...
    basicY(3).*basicZ(1) basicY(3).*basicZ(2) basicY(3).*basicZ(3) ...
    ]./basicY(2)./basicZ(2);
