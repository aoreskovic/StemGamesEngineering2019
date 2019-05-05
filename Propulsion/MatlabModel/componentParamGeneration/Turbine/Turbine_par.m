
%required turbine parameters:
reqPower = 10; %kW
p1 = 19;
p2=0.6;
T1_ref = 265; %reference temperature, °C
eta_nom = 0.8; %efficiency at nominal working conditions, -
a_turb = -2.32; % turbine quadratic efficiency coefficient


qmd_ref = 0.3; %reference steam flow rate, kg/s
Power = reqPower*2/3;
x=1;
y=1;
while abs(reqPower-Power)>0.000001
    qmd_ref_prv = qmd_ref;
    qmd_ref = qmd_ref_prv+(reqPower-Power)*0.0001;
    K_stodola = qmd_ref*sqrt(T1_ref+273.15)/(sqrt(p1*p1-p2*p2)); %konstanta Stodola [kg*sqrt(K)/(bar^2*s)]
    [p1_thr, theta1_thr, eta_turb, qv_d,  a_eta, b_eta, c_eta] = throttling(x*qmd_ref, y*T1_ref, p1 , p2, K_stodola, T1_ref, qmd_ref, eta_nom, a_turb);
    [Power, theta2, h2, s2, x2 ] = Turbine( p1_thr, theta1_thr, p2, qmd_ref, eta_turb);
    Power
end

Results = table(Power, p1, p2, T1_ref, K_stodola,  a_eta, b_eta, c_eta, qmd_ref, eta_nom, a_turb, qv_d)

% x=0.6;
% y=1;
% [p1_thr, theta1_thr, eta_turb, qv_d,  a_eta, b_eta, c_eta] = throttling(x*qmd_ref, y*T1_ref, p1 , p2, K_stodola, T1_ref, qmd_ref, eta_nom, a_turb);
% [Power, theta2, h2, s2, x2 ] = Turbine( p1_thr, theta1_thr, p2, qmd_ref, eta_turb);