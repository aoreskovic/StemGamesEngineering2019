

%% Constants

% Densities
row = 1025; % kg/m^3 - Salt water
roc = 7850; % kg/m^3 - Steel
rop = 1300; % kg/m^3 - Plastics

% Physical constants
g = 9.81; % m/s^2

max_depth = 50;
passenger_count2 = 2;
travel_time = 24;
travel_range = 500;
battery_capacity = 2;
speed_kn = 7;

MCR = 1;

sigma = 125;
k_weld = 1;
k_structure = 1.5;

length_c = 11.05;   % m
radius_r = 1.5;     % m
radius_rb = 1.7;    % m

power_density_turbine = 0.1; % t/kW


%% Calculations


radius_difference = radius_rb-radius_r;
sub_length = length_c+2*radius_r;

% Surface

surface_cylinder = 2*radius_rb*pi*length_c;
surface_sphere = 4*radius_rb^2*pi;
surface_total = surface_cylinder+surface_sphere;

% Volume

volume_cylinder = radius_r^2*pi*length_c;
volume_sphere = 4/3*radius_r^3*pi;
volume_total = volume_cylinder+volume_sphere;
istisnina = volume_total*row/1000;


CB = volume_total/(sub_length*2*radius_r*2*radius_r);




% Debljina stjenke

pressure_conversion = 100000;

depth_pressure_pa = row*g*max_depth;
depth_pressure_b = depth_pressure_pa/pressure_conversion;

Di = radius_r*2*1000;

thickness_hull = depth_pressure_b*Di/(20*sigma+depth_pressure_b);


mass_steel = surface_total*thickness_hull/1000*roc/1000*k_structure;

% Power

kn2ms = 1852/3600;

speed_ms = speed_kn*kn2ms;
Fn = speed_ms/sqrt(9.08665*sub_length);
ni = 0.000001187;
Rn = speed_ms*(sub_length)/ni;
CF = 0.075/(log10(Rn)-2)^2;

k_hull = -0.095+25.6*CB/(sub_length/(2*radius_r))^2;
CT = CF*(1+k_hull);

Re = CT*0.5*row*speed_ms^2*surface_total/1000;
Pe = Re*speed_ms;
Pb1 = Pe/(0.5*0.98);
Pb = Pb1/MCR;

E64 = Pb*power_density_turbine;
