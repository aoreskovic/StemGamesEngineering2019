function [sub_masa_celika] = sub_mass(cilynder_l, sub_radious, max_depth, faktor_zavarivanja, faktor_strukture)
%sub_mass calculates the mass of a given submarine
%   Detailed explanation goes here


% Densities
row = 1025; % kg/m^3 - Salt water
roc = 7850; % kg/m^3 - Steel
rop = 1300; % kg/m^3 - Plastics

% Physical constants
g = 9.81; % m/s^2

sigma = 125;


p_h = row * g * max_depth; % Pa - Hydrostatic pressure
p_h_bar = p_h / 100000; % Bar - Hydrostatic pressure


sub_length = cilynder_l + 2 * sub_radious;


% Volume

vol_cylinder = sub_radious^2 * cilynder_l * pi; % m^3
vol_sphere = 4/3 * sub_radious^3 * pi; % m^3
sub_volume = vol_cylinder + vol_sphere; % m^3

istisnina = row * sub_volume; % t

CB =  sub_volume / (sub_length * 2 * sub_radious * 2 * sub_radious); % Block coefficient


% Surface

sur_cylinder = 2 * sub_radious * pi * cilynder_l;
sur_sphere =  4 * sub_radious^2 * pi;

sub_surface = sur_cylinder + sur_sphere;

% Debljina stjenke

Di = 2 * sub_radious * 1000;

sub_stijenka = p_h_bar * Di / (20 * sigma * faktor_zavarivanja + p_h_bar);

sub_masa_celika = sub_surface * sub_stijenka/1000 * roc/1000 * faktor_strukture;


end

