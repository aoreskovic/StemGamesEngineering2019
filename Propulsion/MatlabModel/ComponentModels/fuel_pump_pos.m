function [fPump] = fuel_pump_pos(N, p, fPump, Env)
%fuel_pump_pos Positive displacement pump
%Inputs:
%       - N [-] relative speed (0-1)
%       - h_max[m] max pump head
%       - Q_max [l/h] max volume flow rate
%       - N_min [-] minimal pump speed
%       - p[bar] pressure in combustion chamber
%       - k [] pipe coefficient
%Outputs:
%       - Q[l/h] pump volume flow rate
g=Env.g;
roW = Env.density;
roFuel = fPump.density;

pGaugeMax = Env.pGaugeMax;%Pa, maximal possible pressure of submarine combustion chamber
assert(pGaugeMax>p-Env.pAtm-fPump.dPcomb, 'pump pressure too big!')
h_max = fPump.hMax;
Q_max = fPump.qvMax;
N_min = fPump.Nmin;
k = fPump.kPipe;
assert(N >= N_min, 'pump speed too low')

h0 = (p-Env.pAtm)/g/roFuel; %m, static pump head
Q=Q_max*N;

assert(h_max>h0, 'depth too big')
h=h0+Q*Q*k;
if h > h_max
    h = h_max;
    Q = sqrt((h_max-h0)/k);
    N_allowed = round(Q/Q_max*100)/100;
else
    N_allowed = N;
end
qm_eth = roFuel * Q/3600/1000;

fPump.qm = qm_eth; %kg/s, ethanom mass flow rate
fPump.Q = Q; %l/h, fuel volume flow rate at current time step
fPump.h = h; %m, fuel pump head at current timestep
fPump.Nallowed = N_allowed; % -, allowed relative speed at this depth
end

