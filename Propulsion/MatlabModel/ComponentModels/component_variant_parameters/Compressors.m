function [CompqmMin,CompqmMax] = Compressors(CompID)
% Compressors Compressor parameters based on selected compressor
%   Detailed explanation goes here
load('CompVars.mat', 'Comps') %load data for all turbines

%input check
assert(isscalar(CompID), 'Compressor ID has to be scalar!')
assert(CompID>0, 'Compressor ID negative!')
assert(CompID<=length(Comps), 'Compressor ID does not exist!')


CompqmMin = Comps(CompID, 2); % kg/h, minimal compressor mass flow rate
CompqmMax = Comps(CompID, 3); %kg/h, maximal compressor mass flow rate
end

