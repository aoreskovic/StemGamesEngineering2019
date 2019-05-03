function [alfaT, w] = alfaTube(qn_H20, qn_CO2, T_fg, A, d)
%alfaTube Heat transfer coefficient calculation inside tubes.
%Flue gases in tubes!
%   

p=60 * 100000; %bar
R = 8314; % kJ/kmolK
qn_DP = qn_H20 + qn_CO2;
M_H20 = 18;
M_CO2 = 44;
M = qn_H20/qn_DP*M_H20 + qn_CO2/qn_DP*M_CO2;
qv_FG = qn_DP * R * (T_fg + 273.15) / p;
w = qv_FG/A; 
mi = miFG(T_fg);
ro = qn_DP*M/qv_FG;
Re = w * ro * d / mi;
CmpFG = qn_H20/qn_DP * cp('H2O', T_fg) + qn_CO2/qn_DP * cp('CO2', T_fg);
cpFG = CmpFG/M*1000;
lmbda = lambdaFG(T_fg);
Pr = mi * cpFG / lmbda;
%if Re < 2300
%    Pe = Re*Pr;
    %Nu = 1.86*(Pe*d/L)^(1/3);
%    Nu = 1.86*Pe^(1/3);
%else
assert(Re>2300, 'laminar!')
Nu = 0.0398*Pr*Re^0.75/(1+1.74*Re^-0.125*(Pr-1));
%end
alfaT = Nu * lmbda / d;
end

