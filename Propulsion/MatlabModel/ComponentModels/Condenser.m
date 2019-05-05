function [ Steam] = Condenser( Steam )
%Condenser Condensation of steam on turbine outlet
%   Inputs:
%       - p2 [bar] condensation pressure (condenser inlet)
%       - theta2 [°C] steam temperature on condenser inlet
%       - qm [kg/s] mass flow of evaporated water
%   Outputs:
%       - Fi_kond [kW] condenser rejected heat flow
%       - theta3 [°C] temperature on condenser outlet
%       - h3 [kJ/kg] liquid water specific enthalpy on condenser outlet
h2 = Steam.Cond.hIn; % kJ/kg, steam specific enthalpy at condenser inlet
p2 = Steam.Cond.p; %bar, pressure in condenser
h3 = Steam.Cond.hOut; % kJ/kg, liquid water specific enthalpy on condenser outlet
qm = Steam.qmSteam; % kg/s, mass flow of evaporated water
Fi_kond = qm * (h2-h3); % kW, condenser rejected heat flow
Steam.Cond.Fi = Fi_kond; %kW, heat flow which is transfered to sea water
end

