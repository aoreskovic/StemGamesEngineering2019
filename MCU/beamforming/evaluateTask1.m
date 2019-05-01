function [targetD, maxD, maxAz] = evaluateTask1(elements, bfMatrix, targetAz)

vel = 1520;
freq = 30e3;

err = linkError.instance();

% Number of elements in total
N = length(elements);

% Parameter format
if (size(elements) == [1 N]) ~= ones(1,2)
    err.invokeError('arrayParameter');
end
elements = transpose([zeros(N,1) elements' zeros(N,1)]);
if size(bfMatrix) ~= N
    err.invokeError('arrayParameter');
end

% Element 1D distances
distMin = 0.05;
if sum(diff(sort(elements)) > distMin) > 0
    err.invokeError('arrayParameter');
end

% Area limits
xmax = 1;
ymax = 1;
if ((~isempty(find(elements < 0)) | ...
        (~isempty(find(elements(1,:) > xmax))) | ...
        (~isempty(find(elements(2,:) > ymax)))))
    err.invokeError('arrayParameter');
end

%% Defining antennas and array

% Antenna element
antenna = ...
    phased.CosineAntennaElement( ...
        'FrequencyRange',[0 1.2e9], ...
        'CosinePower',[2 2] ...
    );
figure;
pattern(antenna,freq,-180:180,-90:90,'Type','directivity','CoordinateSystem','polar');
title('Hydrophone directivity');

array = ...
    phased.ConformalArray( ...
        'ElementPosition', elements, ...
        'Element', phased.IsotropicAntennaElement, ...
        'Taper', bfMatrix ...
    );

% Visualize array
figure;
viewArray(array, 'ShowIndex', 'All', 'ShowTaper', true);
title('Array arrangement');

% Visualize array factor
figure;
pattern(array, freq, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'directivity');
title('Array factor');

% Introduce correct element
array.Element = antenna;

% Visualise array pattern
% 3D
figure;
pattern(array, freq, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'directivity');
title('Array 3D radiation pattern');
% El = 0
figure;
pattern(array, freq, -180:180, 0, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'directivity');
title('Array radiation pattern; Azimuth cut, el = 0\circ');

%% Evaluating array pattern

numPrecuv = 0.001;
ucoord = -1:numPrecuv:1;
vcoord = -1:numPrecuv:1;

[farField, uctrl, vctrl] = pattern(array, freq, ucoord, vcoord, 'PropagationSpeed', vel, 'CoordinateSystem', 'uv', 'Type', 'directivity');

% KEEP NOTE: There may be multiple maxima

% Array directivity
D = max(max(farField));
fprintf('Array directivity: %2.04f dBi\n', D(1));
maxD = D(1);

% Direction of maximum beam
[maxU, maxV] = find(farField == D(1));
maxAzEl = uv2azel([uctrl(maxU);vctrl(maxV)]);
maxAz = maxAzEl(2);
fprintf('Main lobe direction: Azimuth %2.04f Elevation %2.04f\n', maxAzEl(2), maxAzEl(1));

% Directivity at target
targetEl = 0;
% [pat_azel,elctrl,azctrl] = uv2azelpat(farField,ucoord,vcoord);
% [~,azIndex] = min(abs(targetAz-azctrl));
% [~,elIndex] = min(abs(targetEl-elctrl));
targetD = directivity(array,freq,[targetAz;targetEl],'PropagationSpeed',vel);
fprintf('Directivity at target: %2.04f dBi\n', targetD);

end