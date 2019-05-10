function [x, y, vx, vy, t] = RandomPosition()

global globalTime %Use global time

x = globalTime*5;
y = -100*exp(-globalTime/20)-25;
vx = 5;
vy = 5*exp(-globalTime/20);
t = globalTime;

globalTime = globalTime + 1;
end

