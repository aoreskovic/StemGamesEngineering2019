
clear all

sub.radius_dry = 1.50;
sub.radius_wet = 1.7
sub.length = 15
sub.max_depth = 200

sub.mass = sub_mass(sub.length, sub.radius_dry, sub.radius_wet, ...
                    sub.max_depth, 1.2, 4);
                
                
%sub.mass = sub_mass(sub.length, sub.radius_dry, sub.radius_wet, ...
%                    sub.max_depth, 1.4, 0)