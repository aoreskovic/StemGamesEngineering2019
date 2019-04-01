function [F] = arrayPointing(bfMatrix, dx, dy)
%ARRAYPOINTING Analyses the given antenna array
% bfMatrix
% dx in units of lambda
% dy in units of lambda
%   Will calculate array factor of a given array
%   Will find the main lobe direction
%   Will find the pointing loss at the target direction

[M N] = size(bfMatrix);

xcoord = cumsum(dx);
ycoord = cumsum(dy);

numAnglePrec = 5;

phi = [0:numAnglePrec:360] ./ 180 .* pi;
theta = [0:numAnglePrec:180] ./ 180 .* pi;

idx = 1;
for phiIdx = 1:length(phi)
    for thetaIdx = 1:length(theta)
        u(idx) = sin(theta(thetaIdx)) * cos(phi(phiIdx));
        v(idx) = sin(theta(thetaIdx)) * sin(phi(phiIdx));
        idx = idx + 1;
    end
end
delta = 1./(idx-2);

for uIdx = 1:length(u)
for vIdx = 1:length(v)

F(uIdx, vIdx) = 0;

for m = 1:M
    for n = 1:N
        if m == 0 && n == 0
            eps = 1;
        elseif m == 0 && n > 0
            eps = 2;
        elseif m > 0 && n == 0
            eps = 2;
        else
            eps = 4;
        end

        F(uIdx, vIdx) = F(uIdx, vIdx) + ...
            eps * bfMatrix(m,n) * cos((vIdx-1) * 2*pi * ycoord(m) * delta) * cos((uIdx-1) * 2*pi * xcoord(n) * delta);
    end
end

end
end

end

