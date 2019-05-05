function [extDiameter,thickness, conductivity, max_W] = Pipes(pipeNR)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
switch pipeNR
    case 1
        conductivity = 50;
        extDiameter = 20/1000;
        thickness = 2/1000;
        max_W = 10;
    case 2
        conductivity = 300;
        extDiameter = 20/1000;
        thickness = 2/1000;
        max_W=12;
    otherwise
        error('wrong pipe!')
end
end

