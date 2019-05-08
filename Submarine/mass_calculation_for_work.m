

clear all;



length_c = 15;
radius_r = 1.5;
radius_rb = 1.5;
max_depth = 100;
k_struct = 1.5;
k_weld = 1.3;
h = 1.2;

n_bulk = 4;

assert(h <= radius_r, 'h must be smaller than r')

%asert h / angle


%% Constants

% Densities
row = 1025; % kg/m^3 - Salt water
roc = 7850; % kg/m^3 - Steel
rop = 1300; % kg/m^3 - Plastics

% Physical constants
g = 9.81; % m/s^2

sigma = 125;



%% Calculations

%% Dry hull
% Surface

d = radius_r-h;
c = 2 * radius_r * sqrt(1-(d/radius_r)^2);
fi = 2 * atan(c /(2 * d));
angle = fi / pi * 180;

Scut = radius_r^2*0.5*(fi-sin(fi));

dry_base = radius_r^2 * pi - Scut;
circumference_base = 2 * radius_r * pi * ((360-angle)/360) + c;
surface_dry = (n_bulk + 2) * dry_base + circumference_base * length_c;


% Volume

volume_dry = dry_base * length_c;


% Plating


pressure_conversion = 100000;

depth_pressure_pa = row*g*max_depth;
depth_pressure_b = depth_pressure_pa/pressure_conversion;

Di = radius_r*2*1000;

thickness_hull_dry = depth_pressure_b*Di/(20*sigma+depth_pressure_b);

% Mass


steel_volume_dry = surface_dry * thickness_hull_dry / 1000;

mass_dry = steel_volume_dry * roc / 1000 * k_weld * k_struct;


%% Wet hull
% Surface

surface_wet_sphere = 4 * radius_rb ^ 2 * pi;
surface_wet_cylinder = 2 * radius_rb * pi * length_c;
surface_wet = surface_wet_sphere + surface_wet_cylinder;

surface_wet = radius_rb^2 * pi * 2 + radius_rb * 2 * pi * length_c;

% Volume

volume_wet_sphere = 4/3 * pi * radius_rb^3;
volume_wet_cylinder = radius_rb^2*pi * length_c;
volume_wet = volume_wet_sphere + volume_wet_cylinder;


% Plating

thickness_hull_wet = 6;

steel_volume_wet = surface_wet * thickness_hull_wet / 1000;

mass_wet = steel_volume_wet * roc / 1000 * k_weld * k_struct;



%% Final


volume_ballast = volume_wet - volume_dry
mass_total = mass_dry + mass_wet

mass_displacement = volume_dry * row /1000







