function [Steam, Turb, a_eta, b_eta, c_eta] = throttling(Steam, Turb)
%throttling - Pressure reduction on throttling valve and turbine efficiency
%calculation
%   Inputs:
%       - qm_d [kg/s] steam mass flow rate
%       - theta1 [°C] steam temperature after superheating
%       - p1 [bar] evaporation temperature
%       - p2 [bar] condensation temperature
%       - K [kg*sqrt(K)/(bar*s)] Stodola coefficient
%       - T1_nom [°C] nominal superheating temperature
%       - qmd_nom [kg/s] nominal steam mass flow rate
%   Outputs:
%       - p1_thr [bar] pressure after throttling valve (turbine inlet)
%       - theta1_thr [°C] turbine inlet temperature
%       - eta [-] turbine efficiency
%       - qv_d [m3/s] steam volume flow rate 


qm_d = Steam.qmSteam; %kg/h, steam mass flow rate
theta1 = Steam.HE.Super.Tout; %°C, steam temperature at superheater exit
qmd_nom = Turb.qmNom; %kg/s, nominal turbine steam mass flow rate
theta1_nom = Turb.TinNom; %°C, nominal turbine inlet temperature
p1 = Steam.HE.p; %bar, pressure at valve inlet
p2 = Turb.pOut; %bar, condensation pressure
K = Turb.K; %Stodola coef.
h1 = XSteam('h_pT', p1, theta1); % enthalpy on valve inlet, kJ/kg
if qm_d*sqrt(theta1+273.15) <= qmd_nom*sqrt(theta1_nom+273.15) %pressure after valve can't increase!
    theta1_thr = theta1-2; % initial guess of temperature after throttling
    theta1_thr_prv = theta1; %initial guess
    iter = 1;
    while abs(theta1_thr-theta1_thr_prv) > 0.01 %iterate until convergence
        iter = iter +1;
        p1_thr = sqrt(p2*p2+qm_d*qm_d/(K*K)*(theta1_thr+273.15)); %bar, pressure after throttling
        theta1_thr_prv = theta1_thr; %  °C, temperature after throttling in previous iteration
        theta1_thr = XSteam('T_ph', p1_thr, h1); %°C, new temperature after throttling
        if iter > 100
            theta1_thr = (theta1_thr+theta1_thr_prv);
            theta1_thr_prv = theta1_thr;
            p1_thr = sqrt(p2*p2+qm_d*qm_d/(K*K)*(theta1_thr+273.15)); %bar, pressure after throttling
        end
    end
else
    p1_thr = p1; %bar, no pressure drop in valve
    theta1_thr = theta1; %°C, no temperature change in valve
end
if p1_thr>p1 %making sure pressure was not increased in valve
    p1_thr=p1; %bar, no pressure drop in valve
    theta1_thr = theta1; %°C, no temperature change in valve
end
if p1_thr < p2 + 0.2
    p1_thr = p2 + 0.2;
end
Steam.Turb.pIn = p1_thr; %bar, pressure at turbine inlet(after throttling valve)
Steam.Turb.Tin = theta1_thr; %°C, temperature at turbine inlet (after throttling valve)
Steam.Turb.hIn = h1; %kJ/kg, specific enthalpy at turbine inlet

v_inlet=XSteam('v_pT', p1_thr, theta1_thr); % specific volume, m^3/kg
qv_inlet = qm_d*v_inlet; %steam volume flow at turbine inlet, m^3/s

s_inlet = XSteam('s_pT',  p1_thr, theta1_thr);
v_outletS = XSteam('v_ps', p2, s_inlet);
qv_outletS = qm_d*v_outletS;
qv_mean = sqrt(qv_inlet*qv_outletS);

a = Turb.etaCurvature; %s^2/m^6, efficiency curve cuvature (aEta/etaNom)
eta_nom = Turb.etaNom; %-, turbine efficiency at nominal working conditions
qv_nom = Turb.qvNom; %m^3/s, mean nominal steam volume flow rate through turbine
%efficiency calculation
b = -2*a; % linear efficiency coefficient
c = 1-a-b; % constant efficiency coefficient

qv_rel = qv_mean/qv_nom; %-, relative steam volume flow rate
eta_stage = qv_rel*qv_rel*a+qv_rel*b+c; %stage efficiency, -
eta_stage = max(0, eta_stage); %stage efficiency, can't be negative
assert(eta_stage >= 0, 'eta_stage <0!')
assert(eta_stage <= 1, 'eta_stage >1!')

%eta_mech = 0.9;
eta = eta_nom*eta_stage; %turbine overall efficiency, -
assert(p1_thr <= p1, 'pressure above maximum')

a_eta = a*eta_nom/(qv_nom*qv_nom);
b_eta = b*eta_nom/qv_nom;
c_eta = c*eta_nom;

Steam.Turb.qvMean = qv_mean; %, m^3/s real mean volume flow through turbine
Steam.Turb.qvRel = qv_rel; %-, ratio of real mean volume flow and nominal mean volume flow
Turb.eta = eta; %-, turbine efficiency

end

