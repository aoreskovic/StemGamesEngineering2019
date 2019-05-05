function [lambd] = lambdaFG(temperatures)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

temps =[-1000,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1100,1200,2000]'; %�C, temperatures vector
Lambda_H2O_temps = [0.0337412050808142,0.0337412050808142,0.0385262313626182,0.0436864622678581,0.0491439566431099,0.0548671205010140,0.0608348282543966,0.0670281751566019,0.0734283725160067,0.0800159528068877,0.0867705820740128,0.0936710050579128,0.100695038549809,0.107819582149386,0.115020634588941,0.122273315375812,0.129551880170231,0.136829742228252,0.151272904408953,0.165373919540929,0.165373919540929]';
Lambda_CO2_temps = [0.0309529648971137,0.0309529648971137,0.0351047786471971,0.0391840978929069,0.0431489476743898,0.0469645461452749,0.0506042651544006,0.0540506996355098,0.0572968232697519,0.0603472157061455,0.0632193513257871,0.0659449424849645,0.0685713320895676,0.0711629316382922,0.0738027017571954,0.0765936728727722,0.0796605041214251,0.0831510789251612,0.0921209340545199,0.105213613972443,0.105213613972443]';

Lambda_H2O = interp1(temps, Lambda_H2O_temps, temperatures);
Lambda_CO2 = interp1(temps, Lambda_CO2_temps, temperatures);
lambd = 3/5 .* Lambda_H2O + 2/5 .* Lambda_CO2;

end
