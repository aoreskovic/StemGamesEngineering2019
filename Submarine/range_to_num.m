function [colS, rowS, colE, rowE] = range_to_num(range)
%range_to_num Summary of this function goes here
%   Detailed explanation goes here
sol = sscanf(range,'%c%d:%c%d');

colS = sol(1) - 'A' + 1;
rowS = sol(2);
colE = sol(3) - 'A' + 1;
rowE = sol(4);

end

