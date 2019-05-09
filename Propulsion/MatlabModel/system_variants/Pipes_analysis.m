clear all
turbines = [1:24];
pipes = [2:20];
Pumps = [1:24]
Comprs = [1:30];
velocity_evap = 6;
velocity_cond = 1.2;

number1 = length(turbines);
number2 = length(pipes);
number3 = length(Pumps);
number4 = length(Comprs);

turbineNR = [];
PowerkW = [];
pipeNR = [];
Lpipe= [];
evapTubeNR= [];
superTubeNR= [];
evapFraction= [];
PumpNR= [];
PumpSpeedNom = [];
PumpQ = [];
CompressorNr = [];
ComprLoad = [];
CompressorMassFlow = [];
for i = 1:number1
    turbine = turbines(i);
    for j = 2:number2
        pipe = pipes(j);
        [pumpsFeasible,comprFeasible] = findPumpComp(turbine, pipe, velocity_evap, velocity_cond);
        for k = 1:number3
            for l = 1:number4
                pump = Pumps(k);
                comp = Comprs(l);
                try
                    if ismember(k,pumpsFeasible) && ismember(l, comprFeasible)
                        [turbineID, Power, pipeID, Lchosen, nEvapTubes, nSuperTubes, evapRatio, PumpID, NpumpNom, Qpump, CompressorID, L_compr, qmFGret] = Dimensioning_system(turbine, pipe, velocity_evap, velocity_cond, pump, comp);
                        pumpEval =false;
                        compEval = false;
                        disp ([i,j,k,l])
                        disp('pass')
                    else
                        continue
                    end
                catch
                    disp ([i,j,k,l])
                    disp('fail')
                    continue
                end
                turbineNR = [turbineNR, turbineID];
                PowerkW = [PowerkW, Power];
                pipeNR = [pipeNR, pipeID];
                Lpipe= [Lpipe, Lchosen];
                evapTubeNR= [evapTubeNR nEvapTubes];
                superTubeNR= [superTubeNR nSuperTubes];
                evapFraction= [evapFraction, evapRatio];
                PumpNR= [PumpNR, PumpID];
                PumpSpeedNom= [PumpSpeedNom, NpumpNom];
                PumpQ= [PumpQ, Qpump];
                CompressorNr= [CompressorNr, CompressorID];
                ComprLoad= [ComprLoad, L_compr];
                CompressorMassFlow = [CompressorMassFlow, qmFGret];
            end
        end
    end
end
turbineNR = turbineNR';
PowerkW = PowerkW';
pipeNR = pipeNR';
Lpipe= Lpipe';
evapTubeNR= evapTubeNR';
superTubeNR= superTubeNR';
evapFraction= evapFraction';
PumpNR= PumpNR';
PumpSpeedNom= PumpSpeedNom';
PumpQ= PumpQ';
CompressorNr= CompressorNr';
ComprLoad= ComprLoad';
%CompressorMassFlow = CompressorMassFlow';
Results = table(turbineNR, PowerkW, pipeNR, Lpipe, evapTubeNR, superTubeNR, evapFraction, PumpNR, PumpSpeedNom, PumpSpeedNom, PumpQ, CompressorNr, ComprLoad);
%Results = table(turbineNR, pipeNR, Lpipe, evapTubeNR, superTubeNR, evapFraction, PumpNR, PumpSpeedNom, PumpQ, CompressorNr, ComprLoad)
%%
matrica = table2array(Results);
duljina2 = length(matrica);
qmFuel = zeros(duljina2,1);
turbSnaga = zeros(duljina2,1);
tempLoziste = zeros(duljina2,1);
tempIspar =zeros(duljina2,1);
tempPreg =zeros(duljina2,1);
tempPovrat =zeros(duljina2,1);
tempParaTurb = zeros(duljina2,1);
udioPare = zeros(duljina2,1);
etaTurbine =zeros(duljina2,1);
etaSustav =zeros(duljina2,1);

for i =1:duljina2
    if matrica(i,8)==24
        continue
    end
    [qmG_kg_s, Turbine_power_kW, theta_fg1_degC, theta_fg2Evap_degC, theta_fg2Super_degC, theta_ret_degC, theta_1_degc, x__, eta_turb__, system_efficiency] = ...
        evalMaxEta(matrica(i,1),matrica(i,3), matrica(i,4), matrica(i,5), matrica(i,6), matrica(i,12), matrica(i,8), matrica(i,7), matrica(i,9), matrica(i,13));
    qmFuel(i) = qmG_kg_s;
    turbSnaga(i) = Turbine_power_kW;
    tempLoziste(i) = theta_fg1_degC;
    tempIspar(i) =theta_fg2Evap_degC;
    tempPreg(i) = theta_fg2Super_degC;
    tempPovrat(i) =theta_ret_degC;
    tempParaTurb(i) = theta_1_degc;
    udioPare(i) = x__;
    etaTurbine(i) =eta_turb__;
    etaSustav(i) =system_efficiency;
    disp(i)
end
ResultsMaxEta = table(qmFuel, turbSnaga, tempLoziste, tempIspar, tempPreg, tempPovrat, tempParaTurb, udioPare, etaTurbine, etaSustav)