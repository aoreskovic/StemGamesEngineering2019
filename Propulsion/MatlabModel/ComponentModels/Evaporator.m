function [HE, FG, Steam] = Evaporator(HE, FG, Steam, pFG)
%Evaporator Calculation of water evaporation
%   Inputs:
%       - qn_H2O [kmol/s] molar flow rate of water vapor flue gas which
%       enters evaporator
%       -qn_CO2 [kmol/s] molar flow rate of carbon dioxide flue gas which
%       enters evaporator
%       -theta_fg1 [°C] flue gas temperature on combustion chamber exit
%       (evaporator inlet)
%       - theta_evap [°C] water evaporation temperature
%       - h4 [kJ/kg] water specific enthalpy on pump exit / evaporator
%       inlet
%       - p1 [bar] evaporation pressure
%       - A_evap [m2] evaporator heat transfer area
%       - k [W/m2K] evaporator overall heat transfer coefficient
%   Outputs:
%       - Fi_evap [kW] evaporator heat flow rate
%       - qm_d [kg/s] mass flow of evaporated water
%       - theta_fg2 [°C] flue gas temperature at evaporator outlet
%       - h5 [kJ/kg] enthalpy evaporated water

qn_H2O = FG.HE.qnH20*FG.HE.Evap.FGfraction; %kmol/s, molar flow rate of water flue gas which goes to evaporator section
qn_CO2 = FG.HE.qnCO2*FG.HE.Evap.FGfraction; %kmol/s, molar flow rate of CO2 flue gas which goes to evaporator section
FG.HE.Evap.qnH20 = qn_H2O; %kmol/s, H2O molar flow rate
FG.HE.Evap.qnCO2 = qn_CO2; %kmol/s, CO2 molar flow rate
theta_fg1 = FG.HE.Evap.Tin; %°C, flue gas inlet evaporator temperature
theta_evap = Steam.HE.Evap.Tsteam; %°C, steam saturation temperature (evaporator temperature)
h4 = Steam.HE.Evap.hIn; %kJ/kg, water enthalpy at evaporator inlet
A_evap = HE.Evap.wallAreaExt; %m^2, evaporator heat transfer area
p1 = Steam.HE.p; %bar, pressure in evaporator
h5 = XSteam('hV_p',p1); %kJ/kg, enthalpy of evaporated water
Steam.HE.Evap.hOut = h5;
Steam.HE.Super.hIn = Steam.HE.Evap.hOut;
Cfg_in = Heat_capacity_FG(qn_H2O, qn_CO2, theta_fg1); %kJ/K, flue gas heat capacity at evaporator inlet
%initial guess
theta_fg2 = theta_fg1 - 300; %°C, flue gas temperature at evaporator outlet
theta_fg2_prv = theta_fg1; %°C, flue gas temperature at evaporator outlet calculated in previous ineration
Cfg_out = Heat_capacity_FG(qn_H2O, qn_CO2, theta_fg2); %kJ/K, flue gas heat capacity at evaporator outlet
Cfg = (Cfg_in * theta_fg1 - Cfg_out * theta_fg2) / (theta_fg1 - theta_fg2); %kJ/K, mean flue gas heat capacity in evaporator

iter = 0; %first iteration
while abs(theta_fg2_prv- theta_fg2) > 0.1 %calculate until convergence
    iter = iter + 1; %new iteration
    assert(iter<1000, 'Evaporator - convergence not achieved')
    theta_fg2_prv = theta_fg2; %°C, flue gas evaporator exit temperature calculated in previous iteration
    
    Cfg_out = Heat_capacity_FG(qn_H2O, qn_CO2, theta_fg2); %kJ/K, flue gas heat capacity at evaporator outlet
    Cfg = (Cfg_in * theta_fg1 - Cfg_out * theta_fg2) / (theta_fg1 - theta_fg2); %kJ/K, mean flue gas heat capacity in evaporator
    
    [AlfaT, w_pipe] = alfaTube(qn_H2O, qn_CO2, (theta_fg2+theta_fg1)/2, HE.Evap.intArea, HE.Pipe.dInt, pFG, HE.Pipe.length, FG.Mfg);
    k = overallHTC(AlfaT, Steam.HE.Evap.steamHTC, HE.Pipe.dInt, HE.Pipe.dExt, HE.Pipe.conductivity);

    pi2=k*A_evap/(1000*Cfg); %-, pi2 dimensionless parameter (NTU)
    pi1=1-exp(-pi2); %-, pi1 dimensionless parameter (effectiveness)
    theta_fg2 = theta_fg1 - pi1 * (theta_fg1 - theta_evap); %°C, flue gas temperature at evaporator outlet calculated in this iteration
end
Fi_evap = Cfg * (theta_fg1 - theta_fg2); %kW, evaporator heat flow rate
qm_d = Fi_evap/(h5-h4); %kg/s, mass flow of evaporated water

FG.HE.Evap.tubeHTC = AlfaT;
FG.HE.Evap.C = Cfg;
HE.Evap.pi1 = pi1;
HE.Evap.pi2 = pi2;
HE.Evap.k = k;
HE.Evap.Fi = Fi_evap;
FG.HE.Evap.Tout = theta_fg2;
FG.HE.Evap.wPipe = w_pipe;
Steam.qmSteam = qm_d; %kg/s, mass flow of evaporated water

