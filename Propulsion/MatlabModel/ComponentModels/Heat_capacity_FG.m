function [C_fg] = Heat_capacity_FG(qn_H2O, qn_CO2, temperature)
%Heat_capacity_FG Calculation of flue gas mean heat capacity at temperature
%   Inputs:
%       - qn_H2O [kmol/s] molar flow rate of water vapor flue gas which
%       enters evaporator
%       -qn_CO2 [kmol/s] molar flow rate of carbon dioxide flue gas which
%       enters evaporator
%       - temperature [°C] gas temperature 
%   Outputs:
%       - C_fg [kJ/K] flue gas heat capacity 

Cmp_H2O = cmp('H2O', temperature); %[kJ/kmolK] water vapor molar specific heat capacity
Cmp_CO2 =  cmp('CO2', temperature); %[kJ/kmolK] carbon dioxide molar specific heat capacity
C_fg = (qn_H2O * Cmp_H2O + qn_CO2 * Cmp_CO2);  %kJ/K flue gas heat capacity 
end

