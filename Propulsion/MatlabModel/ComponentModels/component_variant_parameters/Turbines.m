function [Power, p1, T1_ref, p2, K_stodola, a_eta, b_eta, c_eta, qmd_ref, a_turb, eta_nom] = Turbines(turbineID)
%Turbines Turbine parameters based on selected turbine
%   Detailed explanation goes here

    load('TurbineVars.mat', 'turbines') %load data for all turbines
    
    %input check
    assert(isscalar(turbineID), 'Turbine ID has to be scalar!')
    assert(turbineID>0, 'Turbine ID negative!')
    assert(turbineID<=length(turbines), 'Turbine ID does not exist!')
    
    Power = turbines(turbineID, 2);
    p1 = turbines(turbineID, 3);
    T1_ref = turbines(turbineID, 5);
    p2 = turbines(turbineID, 4);
    K_stodola = turbines(turbineID, 6);
    a_eta = turbines(turbineID, 7);        
    b_eta = turbines(turbineID, 8);
    c_eta = turbines(turbineID, 9);
    qmd_ref = turbines(turbineID, 10);
    a_turb = turbines(turbineID, 12);
    eta_nom = turbines(turbineID, 11);     
end