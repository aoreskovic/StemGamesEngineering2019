function [extDiameter,thickness, conductivity] = PipeSelect(PipeID)
% Pipes Pipe parameters based on selected PipeID
%   Detailed explanation goes here
load('PipeVars.mat', 'Pipes') %load data for all turbines
%input check
assert(floor(PipeID)==PipeID, 'Compressor ID has to be scalar!')
assert(PipeID>0, 'Compressor ID negative!')
assert(PipeID<=length(Pipes), 'Compressor ID does not exist!')

extDiameter = Pipes(PipeID, 2); % kg/h, minimal compressor mass flow rate
thickness = Pipes(PipeID, 3); %kg/h, maximal compressor mass flow rate
conductivity = Pipes(PipeID, 4);
 
end
