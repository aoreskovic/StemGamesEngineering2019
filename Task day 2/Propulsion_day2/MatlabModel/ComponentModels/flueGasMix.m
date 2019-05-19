function [theta] = flueGasMix(stream1, stream2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
qn_H2O1 = stream1.qnH20; %kmol/s, molar flow rate of H2O in stream 1
qn_H2O2 = stream2.qnH20; %kmol/s, molar flow rate of H2O in stream 2
qn_CO21 = stream1.qnCO2; %kmol/s, molar flow rate of CO2 in stream 1
qn_CO22 = stream2.qnCO2; %kmol/s, molar flow rate of CO2 in stream 2
theta1 = stream1.Tout; %°C, temperature of stream 1
theta2 = stream2.Tout; %°C, temperature of stream 2
enthalpy = Heat_capacity_FG(qn_H2O1, qn_CO21, theta1)*theta1 + ...
    Heat_capacity_FG(qn_H2O2, qn_CO22, theta2)*theta2; % [kJ], total flue gas enthalpy
qn_H20 = qn_H2O1 + qn_H2O2; % [kmol/s] total H20 mass flow rate
qn_C02 = qn_CO21 + qn_CO22; % [kmol/s] total C02 mass flow rate

theta = (theta1 + theta2)/2;
theta_prv = theta-1;
iter = 1;
while abs(theta - theta_prv) > 0.1
    iter = iter+1;
    assert(iter<1000, 'Flue gas mix - convergence not achieved!')
    theta_prv = theta;
    Cmp_H2O = cmp('H2O', theta); %[kJ/kmolK] water vapor molar heat capacity
    Cmp_CO2 =  cmp('CO2', theta); %[kJ/kmolK] carbon dioxide molar heat capacity
    heat_capacity = qn_H20*Cmp_H2O + qn_C02*Cmp_CO2; %[kW/K] flue gas heat capacity
    theta = enthalpy/heat_capacity;
end
end

