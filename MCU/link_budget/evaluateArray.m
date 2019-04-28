clear all;
close all; 

vel = 3e8;
freq = 100e6;
bfMatrix = exp([ -2.6930]*1i).^[0:9];
elements = [0 0; 0 1; 0 2; 0 3; 0 4; 0 5; 0 6; 0 7; 0 8; 0 9];

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
        'CosinePower',[1 1] ...
    );
% pattern(antenna,freq,-180:180,-90:90,'Type','powerdb','CoordinateSystem','polar');

array = ...
    phased.ConformalArray( ...
        'ElementPosition', elements, ...
        'Element', phased.IsotropicAntennaElement, ...
        'ElementNormal', [0;90], ...
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
figure;
pattern(array, freq, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'directivity');
title('Array radiation pattern');

%% Evaluating array pattern

numPrecuv = 0.001;
ucoord = -1:numPrecuv:1;
vcoord = -1:numPrecuv:1;

[farField, ~, ~] = pattern(array, freq, ucoord, vcoord, 'PropagationSpeed', vel, 'CoordinateSystem', 'uv', 'Type', 'directivity');

% KEEP NOTE: There may be multiple maxima

% Array directivity
D = max(max(farField));
fprintf('Array directivity: %2.04f dBi\n', D(1));

% Direction of maximum beam
[maxU, maxV] = find(farField == D(1));
maxAzEl = uv2azel([ucoord(maxU);vcoord(maxV)]);

% Convert to polar
% Used for DEBUG
PAT_AZEL = uv2azelpat(farField,ucoord,vcoord);
figure;
imagesc(PAT_AZEL);
