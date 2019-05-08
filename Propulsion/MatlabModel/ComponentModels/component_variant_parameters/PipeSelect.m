function [extDiameter,thickness, conductivity] = PipeSelect(PipeID)
% Pipes Pipe parameters based on selected PipeID
%   Detailed explanation goes here
load('PipeVars.mat', 'Pipes') %load data for all turbines
%input check
assert(floor(PipeID)==PipeID, 'Compressor ID has to be scalar!')
assert(PipeID>0, 'Compressor ID negative!')
assert(PipeID<=length(Pipes), 'Compressor ID does not exist!')

extDiameter = Pipes(PipeID, 2)/1000; %m, external pipe diameter
thickness = Pipes(PipeID, 3)/1000; %m, pipe thickness
conductivity = Pipes(PipeID, 4);
 
end

