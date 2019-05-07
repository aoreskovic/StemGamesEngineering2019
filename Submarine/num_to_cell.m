function [excell_cell] = num_to_cell(col,row)
%excell_cell Summary of this function goes here
%   Detailed explanation goes here

Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

excell_cell = sprintf('%c%d', Alphabet(col), row);

end

