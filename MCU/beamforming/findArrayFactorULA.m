clear all;
close all;

N = 3;
d = 0.05;
freq = 30e3;
vel = 1520;
lambda = vel/freq;

el = -90:0.1:90;
wantedAngle = 60;
wantedAngle = 90 - wantedAngle;

alpha = -2*pi/lambda*d*cos(deg2rad(wantedAngle));