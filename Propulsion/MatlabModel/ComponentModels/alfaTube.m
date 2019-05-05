function [alfaT, w] = alfaTube(qn_H20, qn_CO2, T_fg, A, d, p, L, Mfg)
%alfaTube Heat transfer coefficient calculation inside tubes.
%Flue gases in tubes!
%   
% RecritL = 3000;
% RecritT = 10000;
Recrit = 2300;
R = 8314; % kJ/kmolK
qn_DP = qn_H20 + qn_CO2; %kmol/s
M = Mfg; %kg/kmol, flue gas mixture molar mas
qv_FG = qn_DP * R * (T_fg + 273.15) / p; %m3/s, flue gas volume flow
w = qv_FG/A; %m/s, flue gas speed
mi = miFG(T_fg); %Pas, flue gas dynamic viscosity
ro = qn_DP*M/qv_FG; %kg/m^3, flue gas density
Re = w * ro * d / mi; % Reynolds number
cp_FG = cpFG(T_fg)*1000; %J/kgK, flue gas constant pressure specific heat capacity
lmbda = lambdaFG(T_fg); %W/mK, flue gas thermal conductivity
Pr = mi * cp_FG / lmbda; %-, Prantl number
% if Re < RecritL 
%     Pe = Re*Pr;
%     Nu = 1.86*(Pe*d/L)^(1/3);
% elseif Re > RecritT
%     Nu = 0.0398*Pr*Re^0.75/(1+1.74*Re^-0.125*(Pr-1));
% else
%     Pe = RecritL*Pr;
%     NuL = 1.86*(Pe*d/L)^(1/3);
%     NuT = 0.0398*Pr*RecritT^0.75/(1+1.74*RecritT^-0.125*(Pr-1));
%     Nu = NuL + (NuT-NuL)/(RecritT-RecritL) * (Re-RecritL);
% 
% end
if Re < Recrit
    Pe = Re*Pr;
    Nu = 1.86*(Pe*d/L)^(1/3);
else
    f=1/((1.82*log10(Re)-1.64)^2);
    Nu = (f/8)*(Re-1000)*Pr/(1+12.7*sqrt(f/8)*(Pr^(2/3)-1));
end
erosion = ro*w*w;
assert(erosion <= 6800, 'flue gas speed too high! erosion!')
alfaT = Nu * lmbda / d;
end

