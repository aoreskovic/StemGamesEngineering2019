
clear all
%Proracun koji se ocekuje od teamova
%Odabrani parametri:

turbine_nr = 16; %redni broj odabrane turbine
thetaFG_evap_in = 750; %temperatura dimnih plinova na ulazu u isparivac
thetaFG_evap_out = 215; %temperatura dimnih plinova na izlazu iz isparivaca
pipe_nr = 1;
wFGevapReq = 6; %m/s željena brzina strujanja dimnih plinova u isparivacu
NpumpNom = 0.8; %željena nominalna brzina pumpe
wFGsuperReq = 1.2; %m/s željena brzina plinova u pregrijacu
theta_super_out = 250; %željena temperatura dimnih plinova na izlazu iz pregrija?a


%zadani parametri
etaP = 0.75; %efikasnost pumpe
H20ratio = 3/5; %steh. omjer
CO2ratio = 2/5; %steh. omjer
pFG=5 * 100000; %Pa
R = 8314; % kJ/kmolK
M_H20 = 18;
M_CO2 = 44;
AlfaEvap = 3500;
ro_etanol = 789;



[Power, p_evap, T1_ref, p_cond, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(turbine_nr);
p1 = p_evap;
p2 = p_cond;
qmd = qmd_ref;
T1 = T1_ref;
%kontrola rada turbine

%prora?un entalpije na ulazu u ispariva?
Steam.qmSteam=0; % kg/s, steam mass flow rate
Steam.CondPump.pIn =p2; % bar, pump inlet pressure (condensation)
Steam.CondPump.pOut = p1; % bar, pump outlet pressure (evaporation)
[CondPump, Steam] = Condensate_pump(Steam, Steam); % initial enthalpy after pump stage
h4=Steam.CondPump.hOut;

%ISPARIVA?
%toplinski tok koji je potrebno izmjeniti na ispariva?u
h_saturated = XSteam('hV_p', p1);
Fi_evap = qmd*(h_saturated-h4); %kW, toplinski tok izmjenjen na isparivacu
%potrebni množinski protok dimnih plinova:
Cnp_H20_evap_in = cmp('H2O', thetaFG_evap_in);
Cnp_C02_evap_in = cmp('CO2', thetaFG_evap_in);
CnpFG_evap_in = H20ratio*Cnp_H20_evap_in+CO2ratio*Cnp_C02_evap_in;

Cnp_H20_evap_out = cmp('H2O', thetaFG_evap_out);
Cnp_C02_evap_out = cmp('CO2', thetaFG_evap_out);
CnpFG_evap_out = H20ratio*Cnp_H20_evap_out+CO2ratio*Cnp_C02_evap_out;

qnFGevap = Fi_evap/(CnpFG_evap_in*thetaFG_evap_in-CnpFG_evap_out*thetaFG_evap_out); %množinski tok dimnih plinova

thetaSat = XSteam('Tsat_p', p1);
LMTD_evap = (thetaFG_evap_in-thetaFG_evap_out)/log((thetaFG_evap_in-thetaSat)/(thetaFG_evap_out-thetaSat));
k_A_evaporator = Fi_evap*1000/LMTD_evap;
%%
%mean flue gas volume flow
M = H20ratio*M_H20 + CO2ratio*M_CO2;
thetaEvapMean = (thetaFG_evap_in + thetaFG_evap_out)/2;
qv_evap =qnFGevap * R * (thetaEvapMean+273.15) /pFG;

%seected evaporator parameters:
[extDiameter,thickness, conductivity, max_W] = Pipes(pipe_nr); %odabir cijevi


AEvapFG = qv_evap/wFGevapReq; %m^2 - površina poprecnog presjeka svih cijevi
intDiameter = extDiameter-2*thickness;
ATube = intDiameter^2*pi()/4;
nEvapTubes = round(AEvapFG/ATube) %number of evaporator tubes
[AlfaTevap, wFGevap] = alfaTube(qnFGevap*H20ratio, CO2ratio*qnFGevap, thetaEvapMean, nEvapTubes*ATube, intDiameter, pFG,2 ,M);
assert(wFGevap <= max_W, 'brzina prevelika u isparivacu')
%%
kEvap = overallHTC(AlfaTevap, AlfaEvap, intDiameter, extDiameter, conductivity);
AWallEvap = k_A_evaporator/kEvap;
AWallEvapTube = AWallEvap/nEvapTubes;
LEvap = AWallEvapTube/(extDiameter*pi()); %duljina isparivaca
LSuper = LEvap*1.2;
while abs(LEvap-LSuper)>0.1
    %pregrija?
    hSuper = XSteam('h_pT', p1, T1);
    Fi_super = qmd*(hSuper-h_saturated); %kW
    theta_super_in = thetaFG_evap_in;

    %potrebni množinski protok dimnih plinova:

    Cmp_H20_super_in = cmp('H2O', theta_super_in);
    Cmp_C02_super_in = cmp('CO2', theta_super_in);
    CmpFG_super_in = H20ratio*Cmp_H20_super_in+CO2ratio*Cmp_C02_super_in;

    Cmp_H20_super_out = cmp('H2O', theta_super_out);
    Cmp_C02_super_out = cmp('CO2', theta_super_out);
    CmpFG_super_out = H20ratio*Cmp_H20_super_out+CO2ratio*Cmp_C02_super_out;

    qnFGsuper = Fi_super/(CmpFG_super_in*theta_super_in-CmpFG_super_out*theta_super_out);

    thetaWSuperIn = thetaSat;
    thetaWSuperOut = T1;
    dTsuper = [theta_super_in-thetaWSuperOut, theta_super_out-thetaWSuperIn];
    LMTD_super = (max(dTsuper)-min(dTsuper))/log((max(dTsuper)/min(dTsuper)));
    k_A_super = Fi_super*1000/LMTD_super;


    thetaSuperMean = (theta_super_in+ theta_super_out)/2;
    qv_super =qnFGsuper * R * (thetaSuperMean+273.15) /pFG;



    ASuperFG = qv_super/wFGsuperReq; %m^2 - površina poprecnog presjeka svih cijevi
    nSuperTubes = round(ASuperFG/ATube) %number of evaporator tubes

    [AlfaTsuper, wFGsuper] = alfaTube(qnFGsuper*H20ratio, CO2ratio*qnFGsuper, thetaSuperMean, nSuperTubes*ATube, intDiameter, pFG, LSuper ,M);
    AlfaSuper = 70;
    kSuper = overallHTC(AlfaTsuper, AlfaSuper, intDiameter, extDiameter, conductivity);
    AWallSuper = k_A_super/kSuper;
    AWallSuperTube = AWallSuper/nSuperTubes;
    LSuper = AWallSuperTube/(extDiameter*pi()) %duljina isparivaca
    theta_super_out=theta_super_out+(LSuper-LEvap)/LEvap;
end
%%

Lchosen = round((LSuper+LEvap)/2, 2);
evapRatio = qnFGevap/(qnFGevap+qnFGsuper);
pipe.dExt =extDiameter;
pipe.thickness = thickness;
pipe.length =Lchosen;
Evap.nr = nEvapTubes;
Super.nr = nSuperTubes;
% conductivity
[AinternalEvap,AwallEvap, dInternal]= exchanger_params(pipe,Evap);

Steam.HE.Evap.Tsteam = thetaSat; %°C, steam saturation temperature (evaporator temperature)
Steam.HE.Evap.hIn = h4; %kJ/kg, water enthalpy at evaporator inlet
HE.Evap.wallAreaExt =AWallEvap; %m^2, evaporator heat transfer area
Steam.HE.p =p1; %bar, pressure in evaporator

HE.Evap.intArea =AinternalEvap;
HE.Pipe.dInt =dInternal;
HE.Pipe.length =Lchosen;
HE.Pipe.conductivity = conductivity;
FG.Mfg=M;
FG.HE.qnH20 =qnFGevap*H20ratio;
FG.HE.qnCO2 =CO2ratio*qnFGevap;
FG.HE.Evap.FGfraction =evapRatio;
FG.HE.Evap.Tin = thetaFG_evap_in;
Steam.HE.Evap.steamHTC = AlfaEvap;
HE.Pipe.dExt = extDiameter;
% [Fi_isp, qm_d, theta_fg2_evap, h5, AlfaTEvap, k_evap, w_fg_evap] = ...
%         Evaporator(H20ratio*qnFGevap, CO2ratio*qnFGevap, thetaFG_evap_in, thetaSat, h4, p1, ...
%         AwallEvap, AinternalEvap, dInternal, extDiameter, conductivity, ...
%         AlfaEvap, pFG, Lchosen);
[HE, FG, Steam] = Evaporator(HE, FG, Steam, pFG);
 %%
 
%[AinternalSuper,AwallSuper, ~]= exchanger_params(extDiameter,thickness, ...
 %   Lchosen, nSuperTubes);
 [AinternalSuper,AwallSuper, ~]= exchanger_params(pipe, Super);
 
% [Fi_preg, theta_fg2_super, theta1, h1, AlfaTSuper, k_super, Cfg, Csteam,...
%     w_fg_super] = Superheater( qm_d, thetaFG_evap_in, H20ratio*qnFGsuper, CO2ratio*qnFGsuper,...
%     thetaSat, p1, AwallSuper, AinternalSuper, dInternal, extDiameter,...
%     conductivity, AlfaSuper, pFG, Lchosen);
HE.Super.wallAreaExt = AwallSuper;
FG.HE.Super.Tin =thetaFG_evap_in;
Steam.HE.Super.TsteamIn = thetaSat;
HE.Super.intArea = AinternalSuper;
Steam.HE.Super.steamHTC = AlfaSuper;
[HE, FG, Steam] = Superheater(HE, FG, Steam, pFG);

str1.qnH20 = H20ratio*qnFGevap;
str1.qnCO2 = CO2ratio*qnFGevap;
str1.Tout = thetaFG_evap_out;
str2.Tout = theta_super_out;
str2.qnH20 = H20ratio*qnFGsuper;
str2.qnCO2 = CO2ratio*qnFGsuper;
%[theta_ret] = flueGasMix(H20ratio*qnFGevap, CO2ratio*qnFGevap, theta_fg2_evap, H20ratio*qnFGsuper, CO2ratio*qnFGsuper,theta_fg2_super);
[theta_ret] = flueGasMix(str1, str2);


%%
%Combustion
%proracun odnosa izme?u povratnih DP i svježih DP
heating_value = 1366940; %kJ/kmol, ethanol lower heating value at 0°C
CnpRet =  H20ratio*cmp('H2O', theta_ret)+CO2ratio*cmp('CO2', theta_ret);
CnpOut = H20ratio*cmp('H2O', thetaFG_evap_in)+CO2ratio*cmp('CO2', thetaFG_evap_in);
%retFraction = (CnpOut*thetaFG_evap_in-heating_value/5)/(CnpRet*theta_ret-heating_value/5);
retFraction = (CnpOut*thetaFG_evap_in-273794.41)/(CnpRet*theta_ret-273794.41);
qnFGnew = (1-retFraction)*(qnFGsuper+qnFGevap);
qnFGret = (qnFGevap+qnFGsuper)-qnFGnew;
qnFuel = qnFGnew/5; 
Mfuel = 2*12+6+16;
qmFuel = qnFuel*Mfuel;
QpumpMax = qmFuel/ro_etanol*3600*1000/0.8;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sub.FG.HE.Evap.Tin = thetaFG_evap_in; %temperatura dimnih plinova na ulazu u isparivac
sub.FG.HE.Super.Tin = sub.FG.HE.Evap.Tin;
sub.HE.Pipe.id = 1; %selected heat exchanger pipe
pipe_nr=sub.HE.Pipe.id;

sub.Turb.id = turbine_nr; %selected turbine


NpumpNom = 0.8; %željena nominalna brzina pumpe

%zadani parametri
H20ratio = 3/5; %steh. omjer
CO2ratio = 2/5; %steh. omjer
pFG=5 * 100000; %Pa
%heat exchanger parameters
sub.Steam.HE.Evap.steamHTC = 3500; %W/m2K, steam side (shell side) evaporator heat transfer coefficient
sub.Steam.HE.Super.steamHTC = 70; %W/m2K, steam side (shell side) superheater heat transfer coefficient

%fuel parameters
sub.Fuel.Tank.density = 789; %kg/m3, fuel density
sub.Fuel.Tank.timestep = 1; %s, calculation timestep
sub.Fuel.Pump.density = sub.Fuel.Tank.density;

%environmental parameters
sub.Env.density = 1000; %kg/m3, density of water which surrounds submarine
sub.Env.g = 9.81; % m/s2, standard acceleration due to gravity

%combustion chamber parameters
sub.FG.Comb.ToxyIn = 10; %°C, temperature at which oxygen enters combustion chamber
sub.FG.Comb.TfuelIn = 10; %°C, temperature at which fuel enters combustion chamber
sub.FG.M_ethanol = 46; %kg/kmol, ethanol molar mass 
sub.FG.M_CO2 = 44;  %kg/kmol, carbon dioxide molar mass 
sub.FG.M_H2O = 18; %kg/kmol, water molar mass
sub.FG.fuelHeatVal = 1366940; % kJ/kmol, ethano lower heating value
sub.FG.O2ratio = 3; % oxygen to ethanol combustion ratio
sub.FG.CO2ratio = 2; % carbon dioxide to ethanol combustion ratio
sub.FG.H2Oratio = 3; % carbon dioxide to ethanol combustion ratio
sub.FG.fuelMeancp = 2.503;
sub.FG.Mfg = sub.FG.H2Oratio/(sub.FG.H2Oratio+sub.FG.CO2ratio)*sub.FG.M_H2O...
    + sub.FG.CO2ratio/(sub.FG.H2Oratio+sub.FG.CO2ratio)*sub.FG.M_CO2; % kg/kmol, flue gas mixture molar mass

R = 8314; % kJ/kmolK

%odabir turbine
[Power, p_evap, T1_ref, p_cond, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(sub.Turb.id);
%odabir parametara rada turbine kod transporta - najve?a efikasnost pri
%nominalnim parametrima turbine.
theta_evap = XSteam('Tsat_p', p_evap); %°C,  evaporation temperature
sub.Turb.Pnom = Power; % kW, turbine nominal power
sub.Turb.pInNom = p_evap; % bar, turbine nominal inlet pressure
p1 = p_evap;
sub.Turb.TinNom = T1_ref; %°C, inlet nominal turbine temperature
T1 = T1_ref;
sub.Turb.pOut = p_cond; % bar, turbine outlet pressure
sub.Steam.Turb.pOut = sub.Turb.pOut;
sub.Turb.K = K_stodola; % kg*sqrt(K)/(bar*s), turbine Stodola coefficient
sub.Turb.aEta = a_eta; % s?2/m?6,first turbine efficiency coefficient (not used in calculation)
sub.Turb.bEta = b_eta; %s/m^3, second turbine efficiency coefficient (not used in calculation)
sub.Turb.cEta = c_eta; %-, third turbine efficiency coefficient (not used in calculation)
sub.Turb.qmNom = qmd_ref; %kg/s, turbine nominal steam flow rate
sub.Turb.etaNom = eta_nom; %-, turbine efficiency at nominal working conditions
sub.Turb.etaCurvature = a_turb; %s^2/m^6, efficiency curve cuvature (aEta/etaNom)
qv_inlet_nom = qmd_ref * XSteam('v_pT', p_evap, T1_ref); %m3/s, nominal steam volume flow rate
s1_nom = XSteam('s_pT', p_evap, T1_ref);
qv_outlet_nom = qmd_ref*XSteam('v_ps', p_cond, s1_nom);
sub.Turb.qvNom = sqrt(qv_inlet_nom*qv_outlet_nom); %m^3/s, mean nominal steam volume flow rate through turbine
sub.Steam.qmSteam = qmd_ref;
sub.Steam.HE.Super.Tout = T1_ref;
sub.Steam.HE.p = p_evap;
[sub.Steam, sub.Turb, ~, ~, ~] = throttling(sub.Steam, sub.Turb);
[sub.Steam, sub.Turb] = Turbine(sub.Steam, sub.Turb);

%condensate pump params
sub.Steam.CondPump.pIn = p_cond; % bar, condensate pump inlet pressure
sub.Steam.CondPump.pOut = p_evap; % bar, condensate pump outlet pressure
[sub.CondPump, sub.Steam] = Condensate_pump(sub.CondPump, sub.Steam); % initial enthalpy after pump stage
%% asdfsdfgsgf 

%ISPARIVA?
%toplinski tok koji je potrebno izmjeniti na ispariva?u
h_saturated = XSteam('hV_p', p_evap);
qmd=sub.Steam.qmSteam;
Fi_evap = qmd*(h_saturated-sub.Steam.CondPump.hOut); %kW, toplinski tok izmjenjen na isparivacu
%potrebni množinski protok dimnih plinova:
Cnp_H20_evap_in = cmp('H2O', thetaFG_evap_in);
Cnp_C02_evap_in = cmp('CO2', thetaFG_evap_in);
CnpFG_evap_in = sub.FG.H2Oratio*Cnp_H20_evap_in+sub.FG.CO2ratio*Cnp_C02_evap_in;

Cnp_H20_evap_out = cmp('H2O', thetaFG_evap_out);
Cnp_C02_evap_out = cmp('CO2', thetaFG_evap_out);
CnpFG_evap_out = sub.FG.H2Oratio*Cnp_H20_evap_out+sub.FG.CO2ratio*Cnp_C02_evap_out;

qnFGevap = Fi_evap/(CnpFG_evap_in*thetaFG_evap_in-CnpFG_evap_out*thetaFG_evap_out); %množinski tok dimnih plinova
sub.FG.HE.Evap.qnH2O = qnFGevap*3/5;
sub.FG.HE.Evap.qnCO2 = qnFGevap*2/5;

thetaSat = XSteam('Tsat_p', p_evap);
LMTD_evap = (thetaFG_evap_in-thetaFG_evap_out)/log((thetaFG_evap_in-thetaSat)/(thetaFG_evap_out-thetaSat));
k_A_evaporator = Fi_evap*1000/LMTD_evap;

%mean flue gas volume flow
M = sub.FG.Mfg;
thetaEvapMean = (thetaFG_evap_in + thetaFG_evap_out)/2;
qv_evap =qnFGevap * R * (thetaEvapMean+273.15) /pFG;

%heat exchanger pipe parameters
[extDiameter,thickness, conductivity, max_W] = Pipes(sub.HE.Pipe.id); %%%% nova verzija kad dobijem dimenzije cijevi
Sub.HE.Pipe.dExt = extDiameter; %m, pipe external diameter
Sub.HE.Pipe.thickness = thickness; %m, pipe thickness
Sub.HE.Pipe.conductivity = conductivity; %W/mK, pipe thermal conductivity


%%
LEvapPrv = 2.5;
LEvap = 3;
while abs(LEvapPrv-LEvap)>0.05
    LEvapPrv = LEvap;
    AEvapFG = qv_evap/wFGevapReq; %m^2 - površina poprecnog presjeka svih cijevi
    intDiameter = extDiameter-2*thickness;
    ATube = intDiameter^2*pi()/4;
    nEvapTubes = round(AEvapFG/ATube) %number of evaporator tubes
    [AlfaTevap, wFGevap] = alfaTube(qnFGevap*H20ratio, CO2ratio*qnFGevap, thetaEvapMean, nEvapTubes*ATube, intDiameter, pFG, LEvap, M);
    kEvap = overallHTC(AlfaTevap, sub.Steam.HE.Evap.steamHTC, intDiameter, extDiameter, conductivity);
    AWallEvap = k_A_evaporator/kEvap;
    AWallEvapTube = AWallEvap/nEvapTubes;
    LEvap = AWallEvapTube/(extDiameter*pi()); %duljina isparivaca
end
H2Oratio=H20ratio;
%%
LSuper = LEvap*1.2;
while abs(LEvap-LSuper)>0.1
    %pregrija?
    hSuper = XSteam('h_pT', p1, T1);
    Fi_super = qmd*(hSuper-h_saturated); %kW
    theta_super_in = thetaFG_evap_in;

    %potrebni množinski protok dimnih plinova:

    Cmp_H20_super_in = cmp('H2O', theta_super_in);
    Cmp_C02_super_in = cmp('CO2', theta_super_in);
    CmpFG_super_in = H2Oratio*Cmp_H20_super_in+CO2ratio*Cmp_C02_super_in;

    Cmp_H20_super_out = cmp('H2O', theta_super_out);
    Cmp_C02_super_out = cmp('CO2', theta_super_out);
    CmpFG_super_out = H2Oratio*Cmp_H20_super_out+CO2ratio*Cmp_C02_super_out;

    qnFGsuper = Fi_super/(CmpFG_super_in*theta_super_in-CmpFG_super_out*theta_super_out);

    thetaWSuperIn = thetaSat;
    thetaWSuperOut = T1;
    dTsuper = [theta_super_in-thetaWSuperOut, theta_super_out-thetaWSuperIn];
    LMTD_super = (max(dTsuper)-min(dTsuper))/log((max(dTsuper)/min(dTsuper)));
    k_A_super = Fi_super*1000/LMTD_super;


    thetaSuperMean = (theta_super_in+ theta_super_out)/2;
    qv_super =qnFGsuper * R * (thetaSuperMean+273.15) /pFG;



    ASuperFG = qv_super/wFGsuperReq; %m^2 - površina poprecnog presjeka svih cijevi
    nSuperTubes = round(ASuperFG/ATube) %number of evaporator tubes

    [AlfaTsuper, wFGsuper] = alfaTube(qnFGsuper*H2Oratio, CO2ratio*qnFGsuper, thetaSuperMean, nSuperTubes*ATube, intDiameter, pFG, LEvap, M);
    AlfaSuper = 70;
    kSuper = overallHTC(AlfaTsuper, AlfaSuper, intDiameter, extDiameter, conductivity);
    AWallSuper = k_A_super/kSuper;
    AWallSuperTube = AWallSuper/nSuperTubes;
    LSuper = AWallSuperTube/(extDiameter*pi()) %duljina isparivaca
    theta_super_out=theta_super_out+(LSuper-LEvap)/LEvap;
end
%%
Lchosen = round((LSuper+LEvap)/2, 2);
evapRatio = qnFGevap/(qnFGevap+qnFGsuper);
%heat exchanger evaporative section parameters

%heat exchanger superheating section parameters
Sub.HE.Evap.nr = nEvapTubes;
Sub.HE.Super.nr= nSuperTubes;
Sub.HE.Pipe.length = Lchosen;
[AinternalSuper,AwallSuper, ~]= exchanger_params(Sub.HE.Pipe, Sub.HE.Evap);
Sub.HE.Super.intArea = AinternalSuper; %m2, internal pipe crossection area of all superheater pipes (flue gas flow area)
Sub.HE.Super.wallAreaExt = AwallSuper; %m2, external pipe wall area of all superheater pipes (heat transfer area)
Sub.Steam.HE.Super.TsteamIn = theta_evap; %°C, steam temperature at superheater inlet



[AinternalEvap,AwallEvap, dInternal]= exchanger_params(Sub.HE.Pipe, Sub.HE.Evap);
Sub.HE.Evap.intArea = AinternalEvap; %m2, internal pipe crossection area of all evaporator pipes (flue gas flow area)
Sub.HE.Evap.wallAreaExt = AwallEvap; %m2, external pipe wall area of all evaporator pipes (heat transfer area)
Sub.HE.Pipe.dInt = dInternal; %m, pipe internal diameter
Sub.Steam.HE.Evap.Tsteam = theta_evap; %°C, steam temperature at evaporator
Sub.Steam.HE.p = p_evap; % bar, pressure in evaporator and superheater


% [Sub.HE, Sub.FG, Sub.Steam] =Evaporator(Sub.HE, Sub.FG, Sub.Steam, pFG);
% %% 
% [AinternalSuper,AwallSuper, ~]= exchanger_params(extDiameter,thickness, ...
%     Lchosen, nSuperTubes);
% [Fi_preg, theta_fg2_super, theta1, h1, AlfaTSuper, k_super, Cfg, Csteam,...
%     w_fg_super] = Superheater( qm_d, thetaFG_evap_in, H20ratio*qnFGsuper, CO2ratio*qnFGsuper,...
%     thetaSat, p1, AwallSuper, AinternalSuper, dInternal, extDiameter,...
%     conductivity, AlfaSuper, pFG, Lchosen);
str1.qnH20 = H20ratio*qnFGevap;
str1.qnCO2 = CO2ratio*qnFGevap;
str1.Tout = thetaFG_evap_out;
str2.Tout = theta_super_out;
str2.qnH20 = H20ratio*qnFGsuper;
str2.qnCO2 = CO2ratio*qnFGsuper;
[theta_ret] = flueGasMix(str1, str2);
% 



%Combustion
%proracun odnosa izme?u povratnih DP i svježih DP
heating_value = 1366940; %kJ/kmol, ethanol lower heating value at 0°C
CnpRet =  H20ratio*cmp('H2O', theta_ret)+CO2ratio*cmp('CO2', theta_ret);
CnpOut = H20ratio*cmp('H2O', thetaFG_evap_in)+CO2ratio*cmp('CO2', thetaFG_evap_in);
%retFraction = (CnpOut*thetaFG_evap_in-heating_value/5)/(CnpRet*theta_ret-heating_value/5);
retFraction = (CnpOut*thetaFG_evap_in-273794.41)/(CnpRet*theta_ret-273794.41);
qnFGnew = (1-retFraction)*(qnFGsuper+qnFGevap);
qnFGret = (qnFGevap+qnFGsuper)-qnFGnew;
qnFuel = qnFGnew/5; 
Mfuel = 2*12+6+16;
qmFuel = qnFuel*Mfuel;
Qpump = qmFuel/789*3600*1000;
qmFGret=qnFGret*M*3600;
Results = table(turbine_nr, Power, pipe_nr, nEvapTubes, LEvap, AlfaTevap, wFGevap, nSuperTubes, LSuper, AlfaTsuper, wFGsuper, Lchosen, evapRatio, qmFGret, qmFuel, Qpump)
Res_params = table(turbine_nr, pipe_nr, Lchosen, nEvapTubes, nSuperTubes, evapRatio,qmFGret, Qpump);
