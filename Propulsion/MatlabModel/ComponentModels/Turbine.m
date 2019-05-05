function [ Steam, Turb ] = Turbine(Steam, Turb)
%Turbine Steam turbine model.
%   Inputs:
%       - p1 [bar] evaporation pressure (turbine inlet)
%       - theta1 [°C] steam superheating temperature (turbine inlet)
%       - p2 [bar] condensation pressure (turbine outlet)
%       - qm [kg/s] mass flow of evaporated water
%       - eta [-] turbine efficiency
%   Outlets:
%       - P [kW] turbine power
%       - theta2 [°C] steam temperature on turbine outlet
%       - h2 [kJ/kg] steam specific enthalpy on turbine outlet 
%       - s2 [kJ/kgK] team specific entropy on turbine outlet
%       - x2 [-] vapour fraction on turbine outlet

qm = Steam.qmSteam; %kg/s, steam mass flow rate
h1 = Steam.Turb.hIn; %kJ/kg, steam specific enthalpy at turbine inlet
p1 = Steam.Turb.pIn; %bar, pressure at turbine inlet
p2 = Steam.Turb.pOut; %bar, pressure at turbine outlet
eta = Turb.eta; %-, turbine efficiency
theta1 = Steam.Turb.Tin; %°C, temperature at turbine inlet
s1=XSteam('s_pT', p1, theta1); %kJ/kgK  steam specific entropy on turbine inlet
h2s=XSteam('h_ps', p2, s1); %kJ/kg steam specific enthalpy on turbine outlet if the proces was isentropic
h2=h1-eta*(h1-h2s); %kJ/kg steam specific enthalpy on turbine outlet 
theta2=XSteam('T_ph', p2, h2); %°C steam temperature on turbine outlet
s2=XSteam('s_ph', p2, h2); %kJ/kgK team specific entropy on turbine outlet
P=qm * (h1-h2); % kW turbine power

tsat = XSteam('Tsat_p', p2); % °C saturation temperature for outlet pressure
if theta2 == tsat % test if steam is not superheated on turbine outlet
    x2 = XSteam('x_ph', p2, h2); % -, vapour fraction
%     if x2 < 0.9
%         warning('Vapour fraction below 90%')
%     end
elseif theta2 > tsat
    x2 = 1; % if outlet temperature > saturation temperature, vapour fraction is 1
else
    error('Unsaturated water after condensation!')
end

Turb.Power = P; %kW, turbine power
Steam.Turb.hOut = h2; %kJ/kg, specific enzhalpy at turbine outlet
Steam.Turb.Tout = theta2; %°C, steam temperature at turbine outlet
Steam.Cond.hIn = Steam.Turb.hOut;  %kJ/kg, specific enzhalpy at condenser inlet
Steam.Cond.Tin = Steam.Turb.Tout; %°C, steam temperature at condenser inlet
Steam.Turb.xOut = x2; %-, steam vapour fraction at turbine exit

end

