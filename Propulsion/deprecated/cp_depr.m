function [Cmp] = cp(element,temperatures)
%cp Calculation of mean molar specific heat capacity of gases between 0 and
%temperature
%   Inputs:
%       - element - gas for which calculation is made ('O2', 'H2O', 'CO2')
%       - temperatures - °C, gas temperature 
%   Output:
%       - Cmp, [kJ/kmolK], mean molar specific heat capacity betwen 0 and
%       temperature


temps = [-1000:100:0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000:100:5000]'; %°C, temperatures vector
Cmp_O2_temps = [ones(1,11)*29.274, 29.538, 29.931, 30.4, 30.878, 31.334, 31.761, 32.15, 32.502, 32.825, 33.118, 33.386, 33.633, 33.863, 34.076, 34.282, 34.474, 34.658, 34.834, 35.006, ones(1,31)*35.169]'; %[kJ/kmolK],vector of mean molar specific heat capacity betwen 0 and temperature
Cmp_H2O_temps = [ones(1,11)*33.499, 33.741, 34.118, 34.575, 35.09, 35.63, 36.195, 36.789, 37.392, 38.008, 38.619, 39.226, 39.825, 40.407, 40.976, 41.525, 42.056, 42.576, 43.07, 43.639, ones(1,31)*43.995]';  %[kJ/kmolK],vector of mean molar specific heat capacity betwen 0 and temperature
Cmp_CO2_temps = [ones(1,11)*35.86, 38.112, 40.059, 41.755, 43.25, 44.573, 45.753, 46.813, 47.763, 48.617, 49.392, 50.099, 50.74, 51.322, 51.858, 52.348, 52.8, 53.218, 53.604, 53.959, ones(1,31)*54.290]';  %[kJ/kmolK],vector of mean molar specific heat capacity betwen 0 and temperature
%-1000 and + 5000 °C temperatures added to prevent out of bonds errors
%while iterating
%temperatures monotonically increasing so that fast interpolation can be
%used

assert(all(temperatures>min(temps)), 'temperatures too small')
assert(all(temperatures<max(temps)), 'temperatures too big')

switch element
    case 'O2'
        Cmp = interp1q(temps, Cmp_O2_temps, temperatures);
    case 'H2O'
        Cmp = interp1q(temps, Cmp_H2O_temps, temperatures);
    case 'CO2'
        Cmp = interp1q(temps, Cmp_CO2_temps, temperatures);
    otherwise
        disp('Input element invalid!')
end

