function [HE, FG, Steam] = Superheater(HE, FG, Steam, pFG)
%Superheater    Calculation of superheater temperature and flue gas outlet
%temperatures
%   Inputs:
%       - qm_d [kg/s] mass flow of evaporated water
%       - theta_fg2 [°C] flue gas temperature at evaporator outlet /
%       superheater inlet
%       - qn_H2O [kmol/s] molar flow rate of water vapor flue gas which
%       enters evaporator
%       -qn_CO2 [kmol/s] molar flow rate of carbon dioxide flue gas which
%       enters evaporator
%       - theta_evap [°C] water evaporation temperature (superheater inlet)
%       - p1 [bar] evaporation pressure
%       - A_super [m2] superheater heat transfer area
%       - k [W/m2K] superheater overall heat transfer coefficient
%   Outputs;
%       - Fi_super [kW] superheater heat flow rate
%       - theta_fg3 [°C] flue gas outlet temperature
%       - theta_1 [°C] steam superheating temperature
%       - h1 [kJ/kg] superheated steam specific enthalpy

A_super = HE.Super.wallAreaExt;  %m^2, superheater heat transfer area
qm_d = Steam.qmSteam; %kg/s, steam mass flow
hd_in = Steam.HE.Super.hIn; % kJ/kg inlet steam specific enthalpy
qn_H2O = FG.HE.qnH20*(1-FG.HE.Evap.FGfraction); %kmol/s, molar flow rate of water flue gas which goes to evaporator section
qn_CO2 = FG.HE.qnCO2*(1-FG.HE.Evap.FGfraction); %kmol/s, molar flow rate of CO2 flue gas which goes to evaporator section
FG.HE.Super.qnH20 = qn_H2O; %kmol/s, H2O molar flow rate
FG.HE.Super.qnCO2 = qn_CO2; %kmol/s, CO2 molar flow rate
theta_fgIn = FG.HE.Super.Tin; %°C, flue gas temperature at superheater inlet 
Cfg_in = Heat_capacity_FG(qn_H2O, qn_CO2, theta_fgIn); %kJ/K inlet flue gas heat capacity
theta_evap = Steam.HE.Super.TsteamIn; %°C, temperature of steam at superheater inlet (evaporation temperature)
%steam initial guesses
theta_1 = theta_evap + 100; %°C steam superheating temperature
theta_1_prv = theta_evap; %°C steam superheating temperatures at previous iteration
%flue gas initial guesses
theta_fgOut = theta_fgIn - 200; %°C flue gas outlet temperature guess
theta_fgOut_prv = theta_fgIn; %°C flue gas outlet temperature at previous iteration
pEvap = Steam.HE.p; %bar, steam pressure in superheater
iter = 0; %first iteration
while (abs(theta_fgOut_prv- theta_fgOut) > 0.1) || (abs(theta_1_prv- theta_1) > 0.1)  %calculate until convergence of flue gas and steam outlet temperature
    iter = iter + 1; %new iteration
    assert(iter<1000, 'Superheater - convergence not achieved');
    theta_fgOut_prv = theta_fgOut; % °C flue gas outlet temperature at previous iteration
    theta_1_prv = theta_1; %°C steam superheating temperatures at previous iteration
    hd_out = XSteam('h_pT', pEvap, theta_1); % kJ/kg, outlet steam specific enthalpy
    cpd_mean = (hd_out - hd_in) / (theta_1 - theta_evap); % kJ/kgK, mean specific heat capacity of water steam in superheater
    C_steam = cpd_mean * qm_d; %kJ/K steam mean heat capacity in superheater

    Cfg_out = Heat_capacity_FG(qn_H2O, qn_CO2, theta_fgOut);  %kJ/K outlet flue gas heat capacity
    Cfg = (Cfg_in * theta_fgIn - Cfg_out * theta_fgOut) / (theta_fgIn - theta_fgOut);  %kJ/K mean flue gas heat capacity
    if Cfg > C_steam
        C1 = C_steam; %slabija struja
        C2 = Cfg; %jaca struja
        slabija = 'para';
    else
        C1 = Cfg; %slabija struja
        C2 = C_steam; %jaca struja
        slabija = 'plinovi';
    end
    
    
    [AlfaT, w_pipe] = alfaTube(qn_H2O, qn_CO2, (theta_fgOut+theta_fgIn)/2, HE.Super.intArea, HE.Pipe.dInt, pFG, HE.Pipe.length, FG.Mfg);
    [k] = overallHTC(AlfaT, Steam.HE.Super.steamHTC, HE.Pipe.dInt, HE.Pipe.dExt, HE.Pipe.conductivity);


    pi2 = k*A_super/(1000*C1); %-, pi2 dimensionless parameter (NTU)
    pi3=C1/C2; %-, pi3 dimensionless parameter (heat capacity ratio)
    assert(pi3 > 0, 'pi3 manji od 0!');
    assert(pi3 <= 1, 'pi3 veci od 1!');
    exponent = exp(-(1-pi3)*pi2);
    pi1 = (1-exponent)/(1-pi3*exponent); %-, pi1 dimensionless parameter (effectiveness)
    switch slabija
        case 'plinovi'
            theta_fgOut = theta_fgIn - pi1 * (theta_fgIn - theta_evap); %°C flue gas outlet temperature
            Fi_super = Cfg * (theta_fgIn - theta_fgOut); %kW, superheater heat flow rate
            theta_1 = Fi_super/C_steam + theta_evap; %°C steam superheating temperature
        case 'para'
            theta_1 = theta_evap - pi1 * (theta_evap - theta_fgIn); %°C steam superheating temperature
            Fi_super = C_steam * (theta_1 - theta_evap); %kW, superheater heat flow rate
            theta_fgOut = theta_fgIn - Fi_super/C_steam; %°C flue gas outlet temperature
    end
    h1 = XSteam('h_pT', pEvap, theta_1); %[kJ/kg] superheated steam specific enthalpy
    
    FG.HE.Super.tubeHTC = AlfaT;
    FG.HE.Super.C = Cfg;
    HE.Super.pi1 = pi1;
    HE.Super.pi2 = pi2;
    HE.Super.pi3 = pi3;
    HE.Super.k = k;
    HE.Super.Fi = Fi_super;
    FG.HE.Super.Tout = theta_fgOut;
    FG.HE.Super.wPipe = w_pipe;
    Steam.HE.Super.hOut = h1;
    Steam.HE.Super.Tout = theta_1;
    Steam.HE.Super.C = C_steam;
end

