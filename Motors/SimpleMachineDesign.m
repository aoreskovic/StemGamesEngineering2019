function [Ds, Dr, delta, zQ, Nf, Xd_pu] = SimpleMachineDesign (Sn, Un, pf, nn, fn, m)

%Sn = 70 kVA, Un = 400 V, pf = 0.8, nn = 3000, fn = 50, m = 3

p = 60*fn/nn; % number of pole pairs

% The machine must be capable of sustaining a 70 % overspeed
% that gives maximum peripheral speed in m/s
vmax = 80 ;
Dr = (60*vmax)/(pi*1.7*nn); % rotor diameter in mm

% Field current linkage theta = 1904 A required to produce maximum magnetic flux density
% B_1delta,max = 0,8 T
B_1delta_max = 0.8;
theta = 1904;
% Assume that magnetic permeability of iron is infinite
mi0 = 4*pi*10^(-7);
% delta = theta*mi0/B_1delta_max;
delta = (theta*mi0/B_1delta_max); %air gap length in mm

% Number of winding turns per pole Nf_p, field winding current 28 A,
% Number of conductors Nf*2 = zf
If = 28;
Nf_p = theta/If;
Nf = Nf_p*2*p;

% Rotor diameter
Ds = (Dr + 2*delta); % stator diameter in mm

% Rated power
% S = 3*Un,ph*In,ph = sqrt(3)*Un*In; Un = Un,ph; In = In,ph
% Stator length l = 0,5 m
l = 0.5;
% Effective value of induced voltage in one conductor
% E_1C,rms = B*l*v
% v = (Ds*pi*n)/60 = 2*tau_p*f
% E_1C_rms = B_1delta_max/sqrt(2)*l*(Ds*pi*n/60);
tau_p = Ds*pi/(2*p);
E_1C_rms = B_1delta_max/sqrt(2)*l*2*tau_p*fn;

% There are 18 slots, find number of conductors in each slot (Q = 36, zQ = ?)
Q = 36;
% Number of slots per phase Q/m
% Effective value of induced voltage in one phase
% E_ph_rms = zQ*E_1C_rms*(Q/m)*kw
% kw is winding factor kw
% number of slots per pole and phase q
q = Q/(2*p*m);
kw = 1/(2*q*sin((pi/6)/q));
E_ph_rms = Un/sqrt(3);
zQ = E_ph_rms/(E_1C_rms*(Q/m)*kw);
zQ = ceil(zQ);

% Base values
[U_B, I_B, Z_B] = baseValues(Un, Sn);
I_n = I_B/sqrt(2);
Upu_n = Un/U_B;
Ipu_n = I_n/I_B;
% Define equivalent circuit => vector diagram => Xd
% Calculate synchronous inductance, neglect stator resistance
load_angle = 0.438; % rad, 25,07�
E0_pu_abs = 2.083; %pu
% Upu_n = E0_pu- j*Xd*Ipu_ns
Xd_pu = (E0_pu_abs*sin(load_angle))/(pf*Ipu_n);
% Xd = Xd_pu*Z_B;
% Ld = Xd/(2*pi*50);

% from short-circuit and open circuit tests
% Ifk = 43.7304 A
% Xd = Ifk/Ifo

end

function [U_B, I_B, Z_B] = baseValues(Un, Sn)
U_B = sqrt(2)*Un/sqrt(3);
S_B = Sn;
I_B = 2*S_B/(3*U_B);
Z_B = U_B/I_B;
end

