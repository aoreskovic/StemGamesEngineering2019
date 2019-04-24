%Synchronous machine design
%Rated values
Sn = 3; % kVA, rated apparent power
Un = 400; % V, rated voltage, line-line voltage effective value
fn = 50; % Hz, rated frequency
pf = 0.8; % rated power facor
n = 3000; % rpm, rated speed
m = 3; % number of phases

p = 60*fn/n; % number of pole pairs

% Field current linkage theta = 2284 A required to produce maximum magnetic flux density
% B_1delta,max = 0,8 T
B_1delta_max = 0.8;
theta = 2284;
% Assume that magnetic permeability of iron is infinite
mi0 = 4*pi*10^(-7);
delta = theta*mi0/B_1delta_max;

% The machine must be capable of sustaining a 70 % overspeed and the
% maximum allowable rotor peripheral speed
% Proraèun elektriènih strojeva, Sirotiæ, Krajzl
% maximum peripheral speed in m/s
vmax = 80;
Ds = (60*vmax)/(pi*1.7*n); % rotor diameter
Dr = Ds - 2*delta; % delta is air-gap

% Ds = 0.3;

% Rated power
% S = 3*Un,ph*In,ph = sqrt(3)*Un*In
% Flux density variation in the air gap with the maximum value of the fundamental flux density B_1delta,max = 0,8 T and period 2*Tau_p 
% Stator length l = 0,5 m
l = 0.5;
% Effective value of induced voltage in one conductor
% E_1C,rms = B*l*v
% v = (Ds*pi*n)/60 = 2*tau_p*f
% E_1C_rms = B_1delta_max/sqrt(2)*l*(Ds*pi*n/60);
tau_p = Ds*pi/(2*p);
E_1C_rms = B_1delta_max/sqrt(2)*l*2*tau_p*fn;

% There are 18 slots, find number of conductors in each slot (Q = 18, zQ = ?)
Q = 18;
% Number of slots per phase Q/m
% Effective value of induced voltage in one phase
% E_ph_rms = zQ*E_1C_rms*(Q/m)*kw
% kw is winding factor kw = 0,96
kw = 0.96;
E_ph_rms = Un/sqrt(3);
zQ = E_ph_rms/(E_1C_rms*(Q/m)*kw);

% Define equivalent circuit => vector diagram => Xd, calculation of base values 

% Base values
U_B = sqrt(2)*Un/sqrt(3);
S_B = Sn;
I_B = 2*S_B/(3*U_B);
% U<(0) = E<delta - j*Xd*I<phi
% ...
