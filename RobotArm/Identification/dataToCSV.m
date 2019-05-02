clear;
Ts = 0.05;
Tsim = 40;
sim('testSignalGenerator');

M = [time, voltage1, valve1, valve2, valve3, voltage2];

csvwrite('signal1.csv', M);