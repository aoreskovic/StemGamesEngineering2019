clear all;
close all; 

vel = 1520;
freq = 30e3;
bfMatrix = exp(1i*[1.12224670903235]).^[0:9];
elements = [0 0; 0 1; 0 2; 0 3; 0 4; 0 5; 0 6; 0 7; 0 8; 0 9]./20;

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

% Area limits
xmax = 10;
ymax = 10;
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
% pattern(antenna,freq,-180:180,-90:90,'Type','powerdb','CoordinateSystem','polar');

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

% Direction of maximum beam
[maxU, maxV] = find(farField == D(1));
maxAzEl = uv2azel([uctrl(maxU);vctrl(maxV)]);
fprintf('Main lobe direction: Azimuth %2.04f Elevation %2.04f\n', maxAzEl(2), maxAzEl(1));

% Directivity at target
targetAz = 30;
targetEl = 0;
[pat_azel,elctrl,azctrl] = uv2azelpat(farField,ucoord,vcoord);
[~,azIndex] = min(abs(targetAz-azctrl));
[~,elIndex] = min(abs(targetEl-elctrl));
targetD = pat_azel(azIndex,elIndex);
fprintf('Directivity at target: %2.04f dBi\n', targetD);