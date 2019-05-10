function [range] = num_to_range(colS, rowS, colE, rowE)
%excell_range Summary of this function goes here
%   Detailed explanation goes here

if(colS > colE)
    error('Invalid range')
end

if(rowS > rowE)
    error('Invalid range')
end

range = sprintf('%s:%s', excell_cell(colS,rowS), excell_cell(colE,rowE))

end

