clear all;
close all;

N = 10;
d = 0.05;
freq = 30e6;
vel = 1520;
lambda = vel/freq;

el = -90:0.01:90;
wantedAngle = 70;
elIndex = find(el == wantedAngle);

cosFact = 2;
pat = cos(deg2rad(el)).^cosFact;

alpha = deg2rad(-180:0.01:180);
deltaBase = 2*pi/lambda*d*cos(deg2rad(el));
delta = ones(length(alpha),length(deltaBase)) .* deltaBase;
for ii=1:length(alpha)
    delta(ii,:) = delta(ii,:) + alpha(ii);
end

arrayFactorAbs = abs(sin(N*delta/2))./abs(sin(delta/2));

arrayPattern = arrayFactorAbs .* pat;

bestalphaIndex = find(arrayPattern(:,elIndex) == max(arrayPattern(:,elIndex)));

bestalpha = alpha(bestalphaIndex);