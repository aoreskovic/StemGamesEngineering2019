clear all;
close all;

N = 10;
d = 0.5;
freq = 100e6;
vel = 3e8;
lambda = vel/freq;

el = -90:0.1:90;
wantedAngle = 60;
elIndex = find(el == wantedAngle);

cosFact = 10;
pat = cos(deg2rad(el)).^cosFact;

alpha = deg2rad(-180:0.1:180);
deltaBase = 2*pi/lambda*d*cos(deg2rad(el));
delta = ones(length(alpha),length(deltaBase)) .* deltaBase;
for ii=1:length(alpha)
    delta(ii,:) = delta(ii,:) + alpha(ii);
end

arrayFactorAbs = abs(sin(N*delta/2))./abs(sin(delta/2));

arrayPattern = arrayFactorAbs .* pat;

[sortedDirectivites, alphaIndices] = sort(arrayPattern(:,elIndex),'descend');
for ii=1:length(alphaIndices)
    maxElIndex = find(arrayPattern(alphaIndices(ii),:) == sortedDirectivites(ii));
    if (sum(elIndex == maxElIndex) > 0)
        bestalphaIndex = alphaIndices(ii);
        break;
    end
end

bestalpha = alpha(bestalphaIndex);