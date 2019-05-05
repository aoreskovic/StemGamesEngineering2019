function [compr] = compressor( N, compr)
%compressor Calculation of compressor return flue gas flow
%   Detailed explanation goes here

qmRetMin = compr.qmMin; % kg/h, minimum return flue gas flow rate
qmRetMax = compr.qmMax; %kg/h, maximum return flue gas flow rate
N1 = compr.N1; %-, speed at which compressor load is L1
N2 = compr.N2; %-, speed at which compressor load is L2
L1 = compr.L1; %-, compressor load at fuel pump speed N1
L2 = compr.L2;%-, compressor load at fuel pump speed N2

L = L1 + (L2-L1) / (N2-N1) * (N-N1); %-, compressor load at speed N
%L between 0 and 1
L = min(1,L);
L=max(0,L);

qmRet = qmRetMin + L*(qmRetMax-qmRetMin); %kg/h, return flue gas mass flow at speed N
compr.qmkgh = qmRet;
compr.L = L; %-, compressor load
end

