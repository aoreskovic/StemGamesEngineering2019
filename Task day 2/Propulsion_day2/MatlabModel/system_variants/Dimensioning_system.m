function [turbineID, Power, pipeID, Lchosen, nEvapTubes, nSuperTubes, evapRatio, PumpID, NpumpNom, Qpump, CompressorID, L_compr, qmFGret, pumpsFeasible, comprFeasible] = Dimensioning_system(turbineNR, pipeNR, velocity_evap, velocity_cond, PumpNR, ComprNR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
turbineID = turbineNR; %redni broj odabrane turbine
thetaFG_evap_in = 750; %temperatura dimnih plinova na ulazu u isparivac
thetaFG_evap_out = 215; %temperatura dimnih plinova na izlazu iz isparivaca
pipeID = pipeNR;
wFGevapReq = velocity_evap; %m/s željena brzina strujanja dimnih plinova u isparivacu
NpumpNom = 0.8; %željena nominalna brzina pumpe
wFGsuperReq = velocity_cond; %m/s željena brzina plinova u pregrijacu
theta_super_out = 250; %željena temperatura dimnih plinova na izlazu iz pregrija?a
PumpID = PumpNR;
CompressorID = ComprNR;

%zadani parametri
H20ratio = 3/5; %steh. omjer
CO2ratio = 2/5; %steh. omjer
pFG=5 * 100000; %Pa
R = 8314; % kJ/kmolK
M_H20 = 18;
M_CO2 = 44;
AlfaEvap = 3500;
ro_etanol = 789;



[Power, p_evap, T1_ref, p_cond, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(turbineID);
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

%mean flue gas volume flow
M = H20ratio*M_H20 + CO2ratio*M_CO2;
thetaEvapMean = (thetaFG_evap_in + thetaFG_evap_out)/2;
qv_evap =qnFGevap * R * (thetaEvapMean+273.15) /pFG;

%seected evaporator parameters:
[extDiameter,thickness, conductivity] = PipeSelect(pipeID); %odabir cijevi


AEvapFG = qv_evap/wFGevapReq; %m^2 - površina poprecnog presjeka svih cijevi
intDiameter = extDiameter-2*thickness;
ATube = intDiameter^2*pi()/4;
nEvapTubes = round(AEvapFG/ATube); %number of evaporator tubes
[AlfaTevap, ~] = alfaTube(qnFGevap*H20ratio, CO2ratio*qnFGevap, thetaEvapMean, nEvapTubes*ATube, intDiameter, pFG,2 ,M);

kEvap = overallHTC(AlfaTevap, AlfaEvap, intDiameter, extDiameter, conductivity);
AWallEvap = k_A_evaporator/kEvap;
AWallEvapTube = AWallEvap/nEvapTubes;
LEvap = AWallEvapTube/(extDiameter*pi()); %duljina isparivaca
LSuper = LEvap*1.2;
iterl=1;
while abs(LEvap-LSuper)>0.1
    iterl = iterl+1;
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
    nSuperTubes = round(ASuperFG/ATube); %number of evaporator tubes

    [AlfaTsuper, wFGsuper] = alfaTube(qnFGsuper*H20ratio, CO2ratio*qnFGsuper, thetaSuperMean, nSuperTubes*ATube, intDiameter, pFG, LSuper ,M);
    AlfaSuper = 70;
    kSuper = overallHTC(AlfaTsuper, AlfaSuper, intDiameter, extDiameter, conductivity);
    AWallSuper = k_A_super/kSuper;
    AWallSuperTube = AWallSuper/nSuperTubes;
    LSuper = AWallSuperTube/(extDiameter*pi()); %duljina isparivaca
    theta_super_out=theta_super_out+(LSuper-LEvap)/LEvap;
    if iterl>50
        break
    end
end


Lchosen = round((LSuper+LEvap)/2, 2);
evapRatio = qnFGevap/(qnFGevap+qnFGsuper);
pipe.dExt =extDiameter;
pipe.thickness = thickness;
pipe.length =Lchosen;
Evap.nr = nEvapTubes;
Super.nr = nSuperTubes;

[AinternalEvap,AWallEvap, dInternal]= exchanger_params(pipe,Evap);

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
Qpump = qmFuel/ro_etanol*3600*1000;
%%
pumpsFeasible = [];
comprFeasible = [];





[qvFuelMax,hMax, Nmin, kPipe] = FuelPumps(PumpID);
assert(Qpump<qvFuelMax, 'odabrana preslaba pumpa')
assert(Qpump>qvFuelMax*Nmin, 'odabrana prejaka pumpa')
NpumpNom = Qpump/qvFuelMax;


qmFGret_kg_h = qnFGret*M*3600;


[CompqmMin,CompqmMax] = Compressors(CompressorID);
assert(qmFGret_kg_h<CompqmMax, 'odabrana preslab kompresor')
assert(qmFGret_kg_h>CompqmMin, 'odabrana prejak kompresor')


L_compr = (qmFGret_kg_h-CompqmMin)/(CompqmMax-CompqmMin);


qmFGret=qnFGret*M*3600;
%Results = table(turbineID, Power, pipeID, nEvapTubes, LEvap, AlfaTevap, wFGevap, nSuperTubes, LSuper, AlfaTsuper, wFGsuper, Lchosen, evapRatio, qmFGret, qmFuel, Qpump)
%Res_params = table(turbineID, pipeID, Lchosen, nEvapTubes, nSuperTubes, evapRatio, PumpID, NpumpNom, Qpump, CompressorID, L_compr)


end

