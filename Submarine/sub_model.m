function [speed_x, speed_y, distance] = sub_model(power_in, angle_in, motor_stop, direction, balast_p)
%sub_model Summary of this function goes here
%   Detailed explanation goes here


%% Constant

angle_limit = 5;
extra_mass = 21;

%% Persistent

persistent energy_x energy_y;

if isempty(energy_x)
    energy_x = 0;
end

if isempty(energy_y)
    energy_y = 0;
end

%% Sub model

sub.radius_dry = 1.5;
sub.radius_wet = 1.7;
sub.length = 15;
sub.max_depth = 200;
sub.h = 1.2;

[sub.mass,  sub.lift, sub.balast_lift]= sub_mass(sub.length, sub.radius_dry, sub.radius_wet, sub.max_depth, sub.h, 4);
sub.mass = sub.mass +extra_mass;


% Power split

angle_deg = max(min(angle_in, angle_limit),- angle_limit);
angle = angle_deg/180*pi;


power_in_x = power_in * cos(angle);
power_in_y = power_in * sin(angle);

% Balast

%lift = 



%% Speed

speed_x = sqrt(energy_x * 2 / sub.mass);
speed_y = sqrt(energy_y * 2 / sub.mass);



%% Drag

drag_x = sub_power_x(speed_x*1.94384, sub.length, sub.radius_wet);
drag_y = sub_power_y(speed_y*1.94384, sub.length, sub.radius_wet);


%% Energy


energy_x = energy_x + power_in_x - drag_x
energy_y = energy_y + power_in_y - drag_y



end

