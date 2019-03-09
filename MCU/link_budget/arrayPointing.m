function [pointingLoss] = arrayPointing(bfMatrix, dx, dy)
%ARRAYPOINTING Analyses the given antenna array
%   Will calculate array factor of a given array
%   Will find the main lobe direction
%   Will find the pointing loss at the target direction

[M N] = size(bfMatrix);

numAnglePrec = 0.1;
phi = [0:numAnglePrec:360] ./ 180 .* pi;
theta = [0:numAnglePrec:180] ./ 180 .* pi;

u = sin(theta) .* cos(phi);
v = sin(theta) .* sin(phi);
deltau = 1/(length(u)-1);
deltav = 1/(length(v)-1);

% Get antenna element coordinates from distances
xcoord = cumsum(dx);
ycoord = cumsum(dy);

% Numerically sweep array factor
for uidx = 1:length(u)
for vidx = 1:length(v)

F(uidx, vidx) = 0;

% Calculate array factor according to doi:10.1109/TAP.2004.841324, eq 27
for n = 1:N
    for m = 1:M
        if n == 0 && m == 0
            eps = 1;
        elseif n == 0 && m > 0
            eps = 2;
        elseif n > 0 && m == 0
            eps = 2;
        else
            eps = 4;
        end

        F(uidx,vidx) = F(uidx,vidx) + eps*bfMatrix(n,m)*cos(uidx*k*xcoord(n)*deltau)*cos(vidx*k*ycoord(m)*deltav);
    end
end

end
end

%TODO
pointingLoss = 0;

end

