function Pb  = sub_power(speed_kn,cilynder_l, sub_radius)
%sub_power Summary of this function goes here
%   Detailed explanation goes here



% Densities
row = 1025; % kg/m^3 - Salt water
roc = 7850; % kg/m^3 - Steel
rop = 1300; % kg/m^3 - Plastics

% Physical constants
g = 9.81; % m/s^2

negative = 1;

if speed_kn < 0
    negative = -1;
    speed_kn = speed_kn * -1;
end

% Surface

sub_length = cilynder_l + 2 * sub_radius;

sur_cylinder = 2 * sub_radius * pi * cilynder_l;
sur_sphere =  4 * sub_radius^2 * pi;

sub_surface = sur_cylinder + sur_sphere;

% Volume

vol_cylinder = sub_radius^2 * cilynder_l * pi; % m^3
vol_sphere = 4/3 * sub_radius^3 * pi; % m^3
sub_volume = vol_cylinder + vol_sphere; % m^3

istisnina = row * sub_volume; % t

CB =  sub_volume / (sub_length * 2 * sub_radius * 2 * sub_radius); % Block coefficient





speed_ms = speed_kn * 0.514444;

ni = 0.000001187; % m^2/s - Kinematic vicscosity 
Rn = speed_ms * sub_length / ni; % Reynolds_number

CF = 0.075/(log10(Rn)-2)^2; % Friction coefficient

Fn = speed_ms /sqrt(9.08665 * sub_length);


k=-0.095+25.6 *CB/((sub_length/(2*sub_radius))^2);

CT = CF * (1 + k);

Re = CT * 0.5 * row * speed_ms^2 * sub_surface / 1000; % kW
Pe = Re * speed_ms; % kW
Pb1 = Pe/(0.5*0.98);
Pb = Pb1/0.85; % kW


Pb = Pb * negative;

end

