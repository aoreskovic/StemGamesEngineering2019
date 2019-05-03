function [Power, p1, T1_ref, p2, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(turbineNR)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

switch turbineNR
    case 30
        Power = 100;
        p1 = 18;
        T1_ref = 250;
        p2 = 0.6;
        K_stodola = 0.27625;
        a_eta = -113.09;
        b_eta = 26.565;
        c_eta = -0.78;
        qmd_ref = 0.21728;
        a_turb = -2; 
        eta_nom = 0.78; 
    case 31
        Power = 50;
        p1 = 18;
        T1_ref = 260;
        p2 = 0.6;
        K_stodola = 0.13761;
        a_eta = -449.22;
        b_eta = 52.945;
        c_eta = -0.78;
        qmd_ref = 0.10721;
        a_turb = -2; 
        eta_nom = 0.78;         
    otherwise
        load('TurbineVars.mat', 'turbines')
        assert(turbineNR>0, 'Chose positive turbine number!')
        assert(turbineNR<=length(turbines), 'Turbine not available!')
        Power = turbines(turbineNR, 2);
        p1 = turbines(turbineNR, 3);
        T1_ref = turbines(turbineNR, 5);
        p2 = turbines(turbineNR, 4);
        K_stodola = turbines(turbineNR, 6);
        a_eta = turbines(turbineNR, 7);        
        b_eta = turbines(turbineNR, 8);
        c_eta = turbines(turbineNR, 9);
        qmd_ref = turbines(turbineNR, 10);
        a_turb = turbines(turbineNR, 12);
        eta_nom = turbines(turbineNR, 11);     
end
end