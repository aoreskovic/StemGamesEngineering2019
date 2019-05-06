
clear all
%Proracun koji se ocekuje od teamova
% odabir turbine
%Odabrani parametri:
sub.Turb.id = 18; %selected turbine
thetaFG_evap_in = 750;
sub.FG.HE.Evap.Tin = thetaFG_evap_in; %temperatura dimnih plinova na ulazu u isparivac
sub.FG.HE.Super.Tin = sub.FG.HE.Evap.Tin;
sub.HE.Pipe.id = 1; %selected heat exchanger pipe


thetaFG_evap_out = 215; %temperatura dimnih plinova na izlazu iz isparivaca

wFGevapReq = 5; %m/s željena brzina strujanja dimnih plinova u isparivacu
NpumpNom = 0.8; %željena nominalna brzina pumpe
wFGsuperReq = 1.2; %m/s željena brzina plinova u pregrijacu
theta_super_out = 250; %željena temperatura dimnih plinova na izlazu iz pregrija?a


%zadani parametri
sub.CondPump.eta = 0.75; % [-] condensate pump efficiency
sub.Steam.qmSteam = 0; %kg/s, steam flow rate, dummy variable
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
heta_evap = XSteam('Tsat_p', p_evap); %°C,  evaporation temperature
sub.Turb.Pnom = Power; % kW, turbine nominal power
sub.Turb.pInNom = p_evap; % bar, turbine nominal inlet pressure
sub.Turb.TinNom = T1_ref; %°C, inlet nominal turbine temperature
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
Fi_evap = sub.Steam.qmSteam*(h_saturated-sub.Steam.CondPump.hOut); %kW, toplinski tok izmjenjen na isparivacu
%potrebni množinski protok dimnih plinova:
Cnp_H20_evap_in = cmp('H2O', thetaFG_evap_in);
Cnp_C02_evap_in = cmp('CO2', thetaFG_evap_in);
CnpFG_evap_in = sub.FG.H20ratio*Cnp_H20_evap_in+sub.FG.CO2ratio*Cnp_C02_evap_in;

Cnp_H20_evap_out = cmp('H2O', thetaFG_evap_out);
Cnp_C02_evap_out = cmp('CO2', thetaFG_evap_out);
CnpFG_evap_out = sub.FG.H20ratio*Cnp_H20_evap_out+sub.FG.CO2ratio*Cnp_C02_evap_out;

qnFGevap = Fi_evap/(CnpFG_evap_in*thetaFG_evap_in-CnpFG_evap_out*thetaFG_evap_out); %množinski tok dimnih plinova
sub.FG.HE.Evap.qnH2O = qnFGevap*3/5;
sub.FG.HE.Evap.qnCO2 = qnFGevap*2/5;

thetaSat = XSteam('Tsat_p', p_evap);
LMTD_evap = (thetaFG_evap_in-thetaFG_evap_out)/log((thetaFG_evap_in-thetaSat)/(thetaFG_evap_out-thetaSat));
k_A_evaporator = Fi_evap*1000/LMTD_evap;

%mean flue gas volume flow
M = sub.FG.Mfg
thetaEvapMean = (thetaFG_evap_in + thetaFG_evap_out)/2;
qv_evap =qnFGevap * R * (thetaEvapMean+273.15) /pFG;

%heat exchanger pipe parameters
[extDiameter,thickness, conductivity, max_W] = Pipes(Sub.HE.Pipe.id); %%%% nova verzija kad dobijem dimenzije cijevi
Sub.HE.Pipe.dExt = extDiameter; %m, pipe external diameter
Sub.HE.Pipe.thickness = thickness; %m, pipe thickness
Sub.HE.Pipe.conductivity = conductivity; %W/mK, pipe thermal conductivity






E.Evap.intArea, HE.Pipe.dInt, pFG, HE.Pipe.length, 

AEvapFG = qv_evap/wFGevapReq; %m^2 - površina poprecnog presjeka svih cijevi
intDiameter = extDiameter-2*thickness;
ATube = intDiameter^2*pi()/4;
nEvapTubes = round(AEvapFG/ATube) %number of evaporator tubes
[AlfaTevap, wFGevap] = alfaTube(qnFGevap*H20ratio, CO2ratio*qnFGevap, thetaEvapMean, nEvapTubes*ATube, intDiameter, pFG, HE.Pipe.length,  FG.Mfg);
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

    Cmp_H20_super_in = cp('H2O', theta_super_in);
    Cmp_C02_super_in = cp('CO2', theta_super_in);
    CmpFG_super_in = H20ratio*Cmp_H20_super_in+CO2ratio*Cmp_C02_super_in;

    Cmp_H20_super_out = cp('H2O', theta_super_out);
    Cmp_C02_super_out = cp('CO2', theta_super_out);
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

    [AlfaTsuper, wFGsuper] = alfaTube(qnFGsuper*H20ratio, CO2ratio*qnFGsuper, thetaSuperMean, nSuperTubes*ATube, intDiameter, pFG, LEvap);
    AlfaSuper = 70;
    kSuper = overallHTC(AlfaTsuper, AlfaSuper, intDiameter, extDiameter, conductivity);
    AWallSuper = k_A_super/kSuper;
    AWallSuperTube = AWallSuper/nSuperTubes;
    LSuper = AWallSuperTube/(extDiameter*pi()) %duljina isparivaca
    theta_super_out=theta_super_out+(LSuper-LEvap)/LEvap;
end

Lchosen = round((LSuper+LEvap)/2, 2);
evapRatio = qnFGevap/(qnFGevap+qnFGsuper);
[AinternalEvap,AwallEvap, dInternal]= exchanger_params(extDiameter,thickness, ...
    Lchosen, nEvapTubes);
[Fi_isp, qm_d, theta_fg2_evap, h5, AlfaTEvap, k_evap, w_fg_evap] = ...
        Evaporator(H20ratio*qnFGevap, CO2ratio*qnFGevap, thetaFG_evap_in, thetaSat, h4, p1, ...
        AwallEvap, AinternalEvap, dInternal, extDiameter, conductivity, ...
        AlfaEvap, pFG, Lchosen);
    
[AinternalSuper,AwallSuper, ~]= exchanger_params(extDiameter,thickness, ...
    Lchosen, nSuperTubes);
[Fi_preg, theta_fg2_super, theta1, h1, AlfaTSuper, k_super, Cfg, Csteam,...
    w_fg_super] = Superheater( qm_d, thetaFG_evap_in, H20ratio*qnFGsuper, CO2ratio*qnFGsuper,...
    thetaSat, p1, AwallSuper, AinternalSuper, dInternal, extDiameter,...
    conductivity, AlfaSuper, pFG, Lchosen);
[theta_ret] = flueGasMix(H20ratio*qnFGevap, CO2ratio*qnFGevap, theta_fg2_evap, H20ratio*qnFGsuper, CO2ratio*qnFGsuper,theta_fg2_super);




%Combustion
%proracun odnosa izme?u povratnih DP i svježih DP
heating_value = 1366940; %kJ/kmol, ethanol lower heating value at 0°C
CnpRet =  H20ratio*cp('H2O', theta_ret)+CO2ratio*cp('CO2', theta_ret);
CnpOut = H20ratio*cp('H2O', thetaFG_evap_in)+CO2ratio*cp('CO2', thetaFG_evap_in);
%retFraction = (CnpOut*thetaFG_evap_in-heating_value/5)/(CnpRet*theta_ret-heating_value/5);
retFraction = (CnpOut*thetaFG_evap_in-273794.41)/(CnpRet*theta_ret-273794.41);
qnFGnew = (1-retFraction)*(qnFGsuper+qnFGevap);
qnFGret = (qnFGevap+qnFGsuper)-qnFGnew;
qnFuel = qnFGnew/5; 
Mfuel = 2*12+6+16;
qmFuel = qnFuel*Mfuel;
QpumpMax = qmFuel/ro_etanol*3600*1000/0.8;

Results = table(turbine_nr, Power, pipe_nr, nEvapTubes, LEvap, AlfaTevap, wFGevap, nSuperTubes, LSuper, AlfaTsuper, wFGsuper, Lchosen, evapRatio, qnFGret, qmFuel, QpumpMax)
Res_params = table(turbine_nr, pipe_nr, Lchosen, nEvapTubes, nSuperTubes, evapRatio,qnFGret, QpumpMax);
