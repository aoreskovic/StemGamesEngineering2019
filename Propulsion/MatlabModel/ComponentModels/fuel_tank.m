function [fuel] = fuel_tank(fuel)
%fuel_tank Calculation of remaining fuel mass
%   Inputs: 
%       - m_prev fuel mass at end of previous timestep [kg]
%       - qm_G fuel flow rate [kg/s]
%       - timestep - calculation time step [s]
%   Outputs:
%       - m_new fuel mass at end of this timestep [kg]
m_prev = fuel.Tank.fuelMass; % kg, fuel mass at time step start
qm_G = fuel.Pump.qm; %kg/s, fuel mass flow rate
timestep = fuel.Tank.timestep; %s, calculation timestep
m_new = m_prev - qm_G*timestep;
fuel.Tank.fuelMass = m_new; %kg, fuel mass in tank at the end of current timestep

end

