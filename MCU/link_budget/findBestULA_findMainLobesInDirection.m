clear all;
close all;

N = 10;
d = 1;
freq = 100e6;
vel = 3e8;
lambda = vel/freq;

el = 0:0.1:180;
wantedAngle = 60; % In domain from evaluateArray function
wantedAngle = 90 - wantedAngle; % In domain used herein
elIndex = find(el == wantedAngle);

cosFact = 1;
pat = cos(deg2rad(el)).^cosFact;

alpha = deg2rad(-180:0.1:180);
deltaBase = 2*pi/lambda*d*cos(deg2rad(el));
delta = ones(length(alpha),length(deltaBase)) .* deltaBase;
for ii=1:length(alpha)
    delta(ii,:) = delta(ii,:) + alpha(ii);
end

arrayFactorAbs = abs(sin(N*delta/2))./abs(sin(delta/2));

arrayPattern = arrayFactorAbs .* pat;

goodAlphaIndices = [];
for ii=1:length(alpha)
    if sum( find(max(arrayPattern(ii,:)) == arrayPattern(ii,:)) == elIndex ) > 0
        goodAlphaIndices = [goodAlphaIndices ii];
    end
end

bestAlpha = alpha(goodAlphaIndices)