function [pipesFlowAreaInternal,pipesWallAreaExternal, pipeDiameterInternal] = exchanger_params...
    (pipe, exchanger)
%superheater_params Calculation of superheater parameters based on geometry
%   Input:
%       - pipeDiameterExternal [m]
%       - pipeThickness [m]
%       - pipeLength [m]
%       - numberOfPipes [-]
%   Output:
%       - pipesFlowAreaInternal [m2]
%       - pipesWallAreaExternal [m2]

pipeDiameterInternal = pipe.dExt - 2*pipe.thickness; % [m] external pipe diameter
pipesFlowAreaInternal = pipeDiameterInternal^2*pi()/4 * exchanger.nr; % [m2] steam flow area (inside pipes)
pipesWallAreaExternal = pipe.dExt * pi() * pipe.length * exchanger.nr; %[m2] pipe outside wall area 
end

