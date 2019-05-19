
clear all
%Proracun koji se ocekuje od teamova
% odabir turbine
%Odabrani parametri:
turbine_nr = 11; %redni broj odabrane turbine
thetaFG_evap_in = 750; %temperatura dimnih plinova na ulazu u isparivac
thetaFG_evap_out = 215; %temperatura dimnih plinova na izlazu iz isparivaca
pipe_nr = 1;
wFGevapReq = 5; %m/s željena brzina strujanja dimnih plinova u isparivacu
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


%odabir turbine
[Power_ref, p1_nom, T1_ref, p2_nom, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom]=Turbines(turbine_nr);
%odabir parametara rada turbine kod transporta - najve?a efikasnost pri
%nominalnim parametrima turbine.
p1 = p1_nom;
p2 = p2_nom;
qmd = qmd_ref;
T1 = T1_ref;
%kontrola rada turbine
[p1_thr, theta1_thr, eta_turb, qv_d, ~, ~, ~] = throttling(qmd, T1, p1 , p2, K_stodola, T1_ref, qmd_ref, eta_nom, a_turb);
[Power, theta2, h2, s2, x2 ] = Turbine( p1_thr, theta1_thr, p2, qmd, eta_turb);

%prora?un entalpije na ulazu u ispariva?
[ theta4, h4, FiPumpa ] = Condensate_pump(p2, p1, qmd, etaP);

%ISPARIVA?
%toplinski tok koji je potrebno izmjeniti na ispariva?u
h_saturated = XSteam('hV_p', p1);
Fi_evap = qmd*(h_saturated-h4); %kW, toplinski tok izmjenjen na isparivacu
%potrebni množinski protok dimnih plinova:
Cnp_H20_evap_in = cp('H2O', thetaFG_evap_in);
Cnp_C02_evap_in = cp('CO2', thetaFG_evap_in);
CnpFG_evap_in = H20ratio*Cnp_H20_evap_in+CO2ratio*Cnp_C02_evap_in;

Cnp_H20_evap_out = cp('H2O', thetaFG_evap_out);
Cnp_C02_evap_out = cp('CO2', thetaFG_evap_out);
CnpFG_evap_out = H20ratio*Cnp_H20_evap_out+CO2ratio*Cnp_C02_evap_out;

qnFGevap = Fi_evap/(CnpFG_evap_in*thetaFG_evap_in-CnpFG_evap_out*thetaFG_evap_out); %množinski tok dimnih plinova

thetaSat = XSteam('Tsat_p', p1);
LMTD_evap = (thetaFG_evap_in-thetaFG_evap_out)/log((thetaFG_evap_in-thetaSat)/(thetaFG_evap_out-thetaSat));
k_A_evaporator = Fi_evap*1000/LMTD_evap;

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
[AlfaTevap, wFGevap] = alfaTube(qnFGevap*H20ratio, CO2ratio*qnFGevap, thetaEvapMean, nEvapTubes*ATube, intDiameter, pFG);
assert(wFGevap <= max_W, 'brzina prevelika u isparivacu')
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
