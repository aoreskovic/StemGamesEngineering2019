classdef PhysicalProperties < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        tempsCmp = [-1000:100:0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000:100:5000]'; %°C, temperatures vector
        Cmp_O2_temps = [ones(1,11)*29.274, 29.538, 29.931, 30.4, 30.878, 31.334, 31.761, 32.15, 32.502, 32.825, 33.118, 33.386, 33.633, 33.863, 34.076, 34.282, 34.474, 34.658, 34.834, 35.006, ones(1,31)*35.169]'; %[kJ/kmolK],vector of mean molar specific heat capacity betwen 0 and temperature
        Cmp_H2O_temps = [ones(1,11)*33.499, 33.741, 34.118, 34.575, 35.09, 35.63, 36.195, 36.789, 37.392, 38.008, 38.619, 39.226, 39.825, 40.407, 40.976, 41.525, 42.056, 42.576, 43.07, 43.639, ones(1,31)*43.995]';  %[kJ/kmolK],vector of mean molar specific heat capacity betwen 0 and temperature
        Cmp_CO2_temps = [ones(1,11)*35.86, 38.112, 40.059, 41.755, 43.25, 44.573, 45.753, 46.813, 47.763, 48.617, 49.392, 50.099, 50.74, 51.322, 51.858, 52.348, 52.8, 53.218, 53.604, 53.959, ones(1,31)*54.290]';  %[kJ/kmolK],vector of mean molar specific heat capacity betwen 0 and temperature
    
        tempsLambda = [ -1000, 250, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 5000]'; %°C, temperatures vector
        Lambda_H2O_temps = [0.0483801998296992,0.0483801998296992,0.0489129180411628,0.0578156642729992,0.0693536992090763,0.0820081930353806,0.0954311398629790,0.109401215518660,0.123711165761339,0.138148637452592,0.152491465377443,0.166506589675972,0.179949750293283,0.192565537676695,0.204087573040510,0.214238742545840,0.222731451392735,0.229267881348712,0.233540243472322,0.233540243472322];
        Lambda_CO2_temps = [0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651,0.0506266396351651];

        tempsMi = [ -1000, 250, 300, 400, 500, 600, 700, 800, 900, 5000]'; %°C, temperatures vector
        mi_H2O_temps = [1.75805879853620e-05,1.75805879853620e-05,1.99259597975953e-05,2.43765075989139e-05,2.86364749687158e-05,3.27425453774632e-05,3.67046954115534e-05,4.05288523967007e-05,4.42210301851378e-05,4.42210301851378e-05]';
        mi_CO2_temps = [3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05,3.18619861291999e-05]';

    end
    
    methods
        function Cmp = molarCapacity(obj, element, temperature)
            switch element
                case 'O2'
                    Cmp = interp1q(obj.tempsCmp, obj.Cmp_O2_temps, temperature);
                case 'H2O'
                    Cmp = interp1q(obj.tempsCmp, obj.Cmp_H2O_temps, temperature);
                case 'CO2'
                    Cmp = interp1q(obj.tempsCmp, obj.Cmp_CO2_temps, temperature);
                otherwise
                    Cmp = -1;
                    disp('Input element invalid!')
            end
        end
        
        function Lambd = thermalConductivity(obj, temperature)
            Lambda_H2O = interp1(obj.tempsLambda, obj.Lambda_H2O_temps, temperature);
            Lambda_CO2 = interp1(obj.tempsLambda, obj.Lambda_CO2_temps, temperature);
            Lambd = 3/5 .* Lambda_H2O + 2/5 .* Lambda_CO2;
        end
        
        function mi = dynamicViscosity(obj, temperature)
            mi_H2O = interp1(obj.tempsMi, obj.mi_H2O_temps, temperature);
            mi_CO2 = interp1(obj.tempsMi, obj.mi_CO2_temps, temperature);
            mi = 3/5 .* mi_H2O + 2/5 .* mi_CO2;
        end
        
        function HC = heatCapacity(obj, qn_H2O, qn_CO2, temperature)
            Cmp_H2O = molarCapacity(obj, 'H2O', temperature); %[kJ/kmolK] water vapor molar specific heat capacity
            Cmp_CO2 =  molarCapacity(obj, 'CO2', temperature); %[kJ/kmolK] carbon dioxide molar specific heat capacity
            HC = qn_H2O * Cmp_H2O + qn_CO2 * Cmp_CO2;  %kJ/K flue gas heat capacity 
        end
    end
end

