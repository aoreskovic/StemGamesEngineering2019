function [FG] = Combustion_chamber( qmG, FG, compr)
%Combustion_chamber Calculation of ethanol in oxygen combustion with flue
%gas return
%   Inputs: 
%       -qmG [kg/s] fuel mass flow rate
%       -theta_ret [°C] return flue gas temperature
%       - ret [kmol/kmolG] molar flow rate of return flue gas in time step 
%       reduced to fuel molar flow rate
%   Outputs:
%       -theta_fg1 [°C] flue gas temperature on combustion chamber exit
%       (evaporator inlet)
%       -qn_H2O [kmol/s] molar flow rate of water vapor flue gas which
%       exits combustion chamber
%       -qn_CO2 [kmol/s] molar flow rate of carbon dioxide flue gas which
%       exits combustion chamber

thetaFuel_in = FG.Comb.TfuelIn; %°C, temperature of fuel which enters combustion chamber
thetaO2_in = FG.Comb.ToxyIn; %°C, temperature of oxygen which enters combustion chamber

M_ethanol = FG.M_ethanol; %kg/kmol, ethanol molar mass 
theta_ret = compr.Tret; %°C, temperature of returning flue gas

Cmp_O2_ul = cmp('O2', thetaO2_in); %kJ/kmolK molar specific heat capacity of oxygen at inlet 
Cmp_CO2_ret = cmp('CO2', theta_ret); %kJ/kmolK molar specific heat capacity of recirculated carbon dioxide at inlet 
Cmp_H2O_ret = cmp('H2O', theta_ret); %kJ/kmolK molar specific heat capacity of recirculated water vapour dioxide at inlet 
Cmp_ethanol = FG.fuelMeancp*M_ethanol; %kJ/kmolK, ethanol specific molar heat capacity at 20°C
heating_value = FG.fuelHeatVal; %kJ/kmol, ethanol lower heating value at 0°C

qnG = qmG/M_ethanol; %kmol/s, fuel molar flow rate
O2_ratio = FG.O2ratio; % kmol 02/ kmol G, stoichiometric ratio of axygen and ethanol
CO2_ratio = FG.CO2ratio; % kmol CO2 / kmol G, stoichiometric ratio of CO2 and ethanol
H2O_ratio = FG.H2Oratio; %kmol H20 / kmol G, stoichiometric ratio of H2O and ethanol

qn_O2=O2_ratio*qnG; %kmol/s, oxygen molar flow rate
qn_CO2 = CO2_ratio*qnG; %kmol/s, generated carbon dioxide molar flow rate
qn_H2O = H2O_ratio * qnG; %kmol/s, generated water vapour molar flow rate
qnRet = compr.qmkgh/3600/FG.Mfg; %kmol/s, return flue gas molar flow rate
qn_CO2_ret = CO2_ratio/(CO2_ratio+H2O_ratio) * qnRet; %kmol/s,molar flow rate of returned CO2
qn_H20_ret = H2O_ratio/(CO2_ratio+H2O_ratio) * qnRet; %kmol/s,molar flow rate of returned H2O

%initial guess
theta_fg_prev = theta_ret; %°C, flue gas exit temperature calculated in previous iteration
theta_fg1 = theta_ret + 500; %°C, flue gas temperature at combustion chamber exit
iter = 0; % first iteration
while abs(theta_fg_prev- theta_fg1) > 0.05 %calculate until convergence
    iter = iter +1; %new iteration
    assert(iter<1000, 'Combustion chamber - convergence not achieved')
    theta_fg_prev = theta_fg1; %°C, flue gas exit temperature calculated in previous iteration
    Cmp_CO2_out = cmp('CO2', theta_fg1); %kJ/kmolK molar specific heat capacity of  carbon dioxide at outlet 
    Cmp_H2O_out = cmp('H2O', theta_fg1); %kJ/kmolK molar specific heat capacity of water vapour dioxide at outlet 
    theta_fg1 = (qnG * (heating_value + Cmp_ethanol * thetaFuel_in) + qn_O2 * (Cmp_O2_ul * thetaO2_in ) + qn_CO2_ret * Cmp_CO2_ret * theta_ret + qn_H20_ret * Cmp_H2O_ret * theta_ret) / ((qn_CO2+qn_CO2_ret) * Cmp_CO2_out + (qn_H2O + qn_H20_ret) * Cmp_H2O_out); %flue gas exit temperature calculated in this iteration
end
qn_H2O = qn_H2O+qn_H20_ret; %kmol/s, molar flow rate of vater vapour which exits combustion chamber
qn_CO2 = qn_CO2 + qn_CO2_ret; %kmol/s, molar flow rate of carbon dioxide flue gas which exits combustion chamber

FG.Comb.Tout = theta_fg1; %°C, temperature at which flue fas exits combustion chamber
FG.HE.Evap.Tin = FG.Comb.Tout; %°C, temperature at which flue fas enters  evaporator
FG.HE.Super.Tin = FG.Comb.Tout;  %°C, temperature at which flue fas enters superheater
FG.HE.qnH20 = qn_H2O; %kmol/s, molar flow of water vapor in flue gas which enters heat exchanger
FG.HE.qnCO2 = qn_CO2; %kmol/s, molar flow of CO2 in flue gas which enters heat exchanger
