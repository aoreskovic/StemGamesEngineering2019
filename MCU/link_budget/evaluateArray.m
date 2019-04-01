function [array] = evaluateArray(bfMatrix, elements, vel, freq)
%EVALUATEARRAY
% bfMatrix
% elements Element coordinates in two-dimensional Cartesian space N x 2
% vel Wave propagation velocity
% freq Operating frequency

err = linkError.instance();

% Number of elements in total
N = length(elements);

% Parameter format
if (size(elements) == [N 2]) ~= ones(1,2)
    err.invokeError('arrayParameter');
end
elements = transpose([elements zeros(N,1)]);
if size(bfMatrix) ~= N
    err.invokeError('arrayParameter');
end

array = phased.ConformalArray('ElementPosition', elements);
figure;
viewArray(array, 'ShowIndex', 'All', 'ShowTaper', true);
figure;
pattern(array, freq, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'powerdb');

end