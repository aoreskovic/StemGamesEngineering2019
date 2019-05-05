function [ CondPump, Steam ] = Condensate_pump(CondPump, Steam)
%Condensate_pump Calculation of condensate pumping from condensation to
%evaporation pressure 
%   Inputs:
%       - p2 [bar] condensation pressure (pump inlet)
%       - p1 [bar] evaporation pressure (pump outlet)
%       - qm [kg/s] mass flow of condensed water
%       - eta [-] pump efficiency
%   Outputs:
%       - theta4 [°C] pump outlet temperature
%       - h4 [J/kg] pump outlet specific enthalpy
%       - FiPump [kW] pump power

etaP = CondPump.eta; % -, pump efficiency
qm = Steam.qmSteam; % kg/s, steam mass flow rate
pIn = Steam.CondPump.pIn; % bar, pump inlet pressure (condensation)
pOut = Steam.CondPump.pOut; % bar, pump outlet pressure (evaporation)
assert (pOut > pIn, 'Condensate pump inlet pressure lower than outlet!')
s3 = XSteam('sL_p', pIn); % kJ/kgK, pump inlet specific entropy
h3 = XSteam('hL_p', pIn);% kJ/kgK, pump inlet specific enthalpy
h4s=XSteam('h_ps', pOut, s3); %kJ/kg, pump outlet specific enthalpy if proces was isentropic
h4 = h3 + (h4s-h3)/etaP;  %kJ/kg, condensate pump outlet specific enthalpy
Steam.CondPump.hIn = h3;
Steam.CondPump.hOut = h4;
Steam.CondPump.Tout = XSteam('T_ph', pOut, h4); %°C, condensate pump outlet temperature
Steam.HE.Evap.hIn = Steam.CondPump.hOut; %kJ/kg, evaporator inlet steam specific enthalpy
Steam.HE.Evap.Tin = Steam.CondPump.Tout;%°C, evaporator inlet steam temperature
CondPump.Fi = qm * (h4-h3); % kW, condensate pump power

end

