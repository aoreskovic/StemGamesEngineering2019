function [targetD, maxD, maxAz, lobesValid] = evaluateTask1(elements, bfMatrix, targetAz, verifyLobes)

vel = 1520;
freq = 30e3;

err = linkError.instance();

% Number of elements in total
N = length(elements);

% Parameter format
if (N == 1)
    err.invokeError('notAnArray');
end
if (size(elements) == [1 N]) ~= ones(1,2)
    err.invokeError('arrayParameter');
end

% Area limits
elements = elements + 0.225;
xmax = 0.45001;
ymax = 0.45001;
if ((~isempty(find(elements < 0)) | ...
        (~isempty(find(elements(1,:) > xmax)))))
    err.invokeError('arrayParameter');
end
elements = elements - 0.225;


% Element 1D distances
distMin = 0.0499;
if sum(diff(sort(elements)) < distMin) > 0
    err.invokeError('arrayParameter');
end


elements = transpose([zeros(N,1) elements' zeros(N,1)]);
if size(bfMatrix) ~= N
    err.invokeError('bfFormat');
end
if sum(abs(bfMatrix) > 1.0001) > 0
    err.invokeError('bfFormat');
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
numPreazel = 0.1;
azimuths = -180:numPreazel:180;
figure;
azCut = pattern(array, freq, azimuths, 0, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'directivity');
pattern(array, freq, azimuths, 0, 'PropagationSpeed', vel, 'CoordinateSystem', 'polar', 'Type', 'directivity');
title('Array radiation pattern; Azimuth cut, el = 0\circ');


%% Evaluating array pattern

numPrecuv = 0.001;
ucoord = -1:numPrecuv:1;
vcoord = -1:numPrecuv:1;

[farField, uctrl, vctrl] = pattern(array, freq, ucoord, vcoord, 'PropagationSpeed', vel, 'CoordinateSystem', 'uv', 'Type', 'directivity');

% KEEP NOTE: There may be multiple maxima

% Is the target in two tallest lobes?
[lobeD,lobeAzIdx] = findpeaks(azCut,'SortStr','descend','NPeaks',2);
lobesValid = [false false];
usedLobe = 0;
for ii=1:2
    azCutSection = azCut(lobeAzIdx(ii):(find(azimuths == targetAz)));
    if sum(azCutSection <= 0) == 0
        lobesValid(ii) = true;
        usedLobe = ii;
        break;
    end
end

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

% Are we actually inside the lobe?
if verifyLobes
    if (usedLobe == 0) || ((lobeD(usedLobe) - targetD) > 6)
        err.invokeError('lobeTooFar');
    end
end

end