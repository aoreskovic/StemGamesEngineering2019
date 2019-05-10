function [speed_x, speed_y, distance_xr, distance_yr] = sub_model(power_in, angle_in, motor_stop, direction, balast_p)
%sub_model Summary of this function goes here
%   Detailed explanation goes here



if motor_stop == 0
    power_in = 0;
end


if direction < 0
    power_in = - power_in;
end



%% Constant

angle_limit = 5;
extra_mass = 0;
g = 9.81;
max_balast = 30;

fill_speed = 25/1000;

%% Persistent

persistent energy_x energy_y balast_fill;
persistent distance_x distance_y;

if isempty(energy_x)
    energy_x = 0;
end

if isempty(energy_y)
    energy_y = 0;
end

if isempty(distance_x)
    distance_x = 0;
end

if isempty(distance_y)
    distance_y = 0;
end

%% Sub model

sub.radius_dry = 1.5;
sub.radius_wet = 1.7;
sub.length = 15;
sub.max_depth = 200;
sub.h = 1.2;

[sub.mass,  sub.lift, sub.balast_lift]= sub_mass(sub.length, sub.radius_dry, sub.radius_wet, sub.max_depth, sub.h, 4);
sub.mass = sub.mass +extra_mass;


if isempty(balast_fill)
    balast_fill = max_balast/2;
end

if (balast_fill/max_balast) > balast_p
    balast_fill = balast_fill - fill_speed;
else
    balast_fill = balast_fill + fill_speed;
end

% Power split

angle_deg = max(min(angle_in, angle_limit),- angle_limit);
angle = angle_deg/180*pi;


power_in_x = power_in * cos(angle);
power_in_y = power_in * sin(angle);

% Balast

lift = (max_balast/2-balast_fill) /1000 * g;



%% Speed

speed_x = sqrt(energy_x * 2 / sub.mass);
speed_y = sqrt(energy_y * 2 / sub.mass);

%% Distance

distance_x = distance_x + speed_x;
distance_y = distance_y + speed_y;
distance_xr = distance_x;
distance_yr = distance_y;

%% Drag

drag_x = sub_power_x(speed_x*1.94384, sub.length, sub.radius_wet);
drag_y = sub_power_y(speed_y*1.94384, sub.length, sub.radius_wet);


%% Energy


energy_x = energy_x + power_in_x - drag_x;
energy_y = energy_y + power_in_y - drag_y + lift * g * speed_y;



end

