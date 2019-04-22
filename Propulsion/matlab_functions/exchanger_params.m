function [pipesFlowAreaInternal,pipesWallAreaExternal, pipeDiameterInternal] = exchanger_params...
    (pipeDiameterExternal,pipeThickness, pipeLength, numberOfPipes)
%superheater_params Calculation of superheater parameters based on geometry
%   Input:
%       - pipeDiameterExternal [m]
%       - pipeThickness [m]
%       - pipeLength [m]
%       - numberOfPipes [-]
%   Output:
%       - pipesFlowAreaInternal [m2]
%       - pipesWallAreaExternal [m2]

pipeDiameterInternal = pipeDiameterExternal - 2*pipeThickness; % [m] external pipe diameter
pipesFlowAreaInternal = pipeDiameterInternal^2*pi()/4 * numberOfPipes; % [m2] steam flow area (inside pipes)
pipesWallAreaExternal = pipeDiameterExternal * pi() * pipeLength * numberOfPipes; %[m2] pipe outside wall area 
end

