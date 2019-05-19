function [qvMax,hMax, Nmin, kPipe] = FuelPumps(pumpID)
%FuelPumps Fuel pump parameters based on selected fuel pump
%   Detailed explanation goes here

load('FpumpsVars.mat', 'Fpumps') %load data for all turbines

%input check
assert(isscalar(pumpID), 'Fuel pump ID has to be scalar!')
assert(pumpID>0, 'Fuel pump ID negative!')
assert(pumpID<=length(Fpumps), 'Fuel pump ID does not exist!')

qvMax = Fpumps(pumpID, 2); % l/h, maximal fuel pump volume flow rate
hMax = Fpumps(pumpID, 3); %m, maximal fuel pump head
Nmin = Fpumps(pumpID, 4); %-, minimal fuel pump relative speed
kPipe = Fpumps(pumpID, 5); %m*h^2/l^2, pipe friction coefficient for selected pump

end

