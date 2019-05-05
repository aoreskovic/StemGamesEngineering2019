clear all;
close all;

N = 3;
d = 0.05;
freq = 30e6;
vel = 1520;
lambda = vel/freq;

el = -90:0.1:90;
wantedEl = 60;
elIndex = find(el == wantedEl);

az = -180:0.1:180;
wantedAz = 135;
azIndex = find(az == wantedAz);


%% Solve elevation

cosFact = 2;
pat = cos(deg2rad(el)).^cosFact;

alpha = deg2rad(-180:0.01:180);
deltaBase = 2*pi/lambda*d*cos(deg2rad(el));
delta = ones(length(alpha),length(deltaBase)) .* deltaBase;
for ii=1:length(alpha)
    delta(ii,:) = delta(ii,:) + alpha(ii);
end

arrayFactorAbs = abs(sin(N*delta/2))./abs(sin(delta/2));

arrayPattern = arrayFactorAbs;% .* pat;

bestalphaIndex = find(arrayPattern(:,elIndex) == max(arrayPattern(:,elIndex)));

bestYalpha = alpha(bestalphaIndex);

%% Solve azimuth

alpha = deg2rad(-180:0.01:180);
deltaBase = 2*pi/lambda*d*cos(deg2rad(az));
delta = ones(length(alpha),length(deltaBase)) .* deltaBase;
for ii=1:length(alpha)
    delta(ii,:) = delta(ii,:) + alpha(ii);
end

arrayFactorAbs = abs(sin(N*delta/2))./abs(sin(delta/2));

arrayPattern = arrayFactorAbs;

bestalphaIndex = find(arrayPattern(:,azIndex) == max(arrayPattern(:,azIndex)));

bestZalpha = alpha(bestalphaIndex);

%% Construct bfMatrix

basicY = exp(1i*bestYalpha).^[-1 0 1];
basicZ = exp(1i*bestZalpha).^[-1 0 1];

bfMatrix = [
    basicY(1).*basicZ(1) basicY(1).*basicZ(2) basicY(1).*basicZ(3) ...
    basicY(2).*basicZ(1) basicY(2).*basicZ(2) basicY(2).*basicZ(3) ...
    basicY(3).*basicZ(1) basicY(3).*basicZ(2) basicY(3).*basicZ(3) ...
    ]./basicY(2)./basicZ(2);
