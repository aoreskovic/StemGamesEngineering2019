function [k] = overallHTC(alfaT, alfaS, dInt, dExt, lambda)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
R_int = dInt/2;
R_ext = dExt/2;
ConvInt = R_ext/(R_int*alfaT);
Cond=R_ext/lambda * log(R_ext/R_int);
ConvExt = 1/alfaS;
R_total=(ConvInt+Cond+ConvExt);
k=1/R_total;
end

