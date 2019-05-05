function [a_ref, b_ref, c_ref, a_max, b_max, c_max, h_max, k, n_min, aP_ref, bP_ref, cP_ref, dP_ref, inverterP, aP_max, bP_max, cP_max, dP_max, Pmax] = fuel_pump_parameters(Q_nom,h_nom, P_nom, pump_type)
%fuel_pump_parameters Calculation of parameters for specific pump based on
%nominal head and flow rate and pump type
%   Inputs:
%       - Q_nom [m3/h] nominal volume flow 
%       - h_nom [m] nominal pump head
%       - P_nom [W] nominal power
%       - pump_type [-] type of pump
%   Outputs
%       - a_ref
%       - b_ref
%       - c_ref
%       - a_max
%       - b_max
%       - c_max
%       - h_max
%       - k
%       - n_min
switch pump_type
    case 'type1'
        % head/volume flow parameters
        a_nom = -0.43115; %a*(Q_nom^2) / h_nom
        b_nom = 0.30780; %b / h_nom * Q_nom
        c_nom = 1.13626; % c/h_nom
        a_max_nom = 0.411711429; %a_max*(Q_nom^2) / h_nom
        b_max_nom = -2.143285714; %b_max / h_nom * Q_nom
        c_max_nom = 2.865952381; % c_max/h_nom
        h_max_nom = 1.9048; %h_max / h_nom
        k_nom = 1;
        n_min = 0.35;
        
        % power parameters
        aP_nom = -0.231739472; %a*(Q_nom^2) / h_nom
        bP_nom = 0.269910983; %b / h_nom * Q_nom
        cP_nom = 0.715406157; % c/h_nom
        dP_nom = 0.250347567;
        inverterP = 5; % W
        aPmax_nom = 0.220011766;
        bPmax_nom = 0.233540616;
        cPmax_nom = 0.960899702;
        dPmax_nom = 0.538063555;  
        Pmax_nom = 1.100993049; %(Pmax - inverterP) / Pnom
  case 'type2'
      %everything same, cnom increased 
      
        % head/volume flow parameters
        a_nom = -5.43115; %a*(Q_nom^2) / h_nom
        b_nom = 2.0780; %b / h_nom * Q_nom
        c_nom = 1.13626+20; % c/h_nom
        a_max_nom = 3.411711429; %a_max*(Q_nom^2) / h_nom
        b_max_nom = -35.143285714; %b_max / h_nom * Q_nom
        c_max_nom = 2.865952381+50; % c_max/h_nom
        h_max_nom = 1.9048+30; %h_max / h_nom
        k_nom = 1;
        n_min = 0.35;
        
        % power parameters
        aP_nom = -0.231739472; %a*(Q_nom^2) / h_nom
        bP_nom = 0.269910983; %b / h_nom * Q_nom
        cP_nom = 0.715406157; % c/h_nom
        dP_nom = 0.250347567;
        inverterP = 5; % W
        aPmax_nom = 0.220011766;
        bPmax_nom = 0.233540616;
        cPmax_nom = 0.960899702;
        dPmax_nom = 0.538063555;  
        Pmax_nom = 1.100993049; %(Pmax - inverterP) / Pnom
        
        case 'type3'
        % positive displacement
        % head/volume flow parameters
        a_nom = -30.43115; %a*(Q_nom^2) / h_nom
        b_nom = 2.0780; %b / h_nom * Q_nom
        c_nom = 1.13626+20; % c/h_nom
        a_max_nom = 3.411711429; %a_max*(Q_nom^2) / h_nom
        b_max_nom = -35.143285714; %b_max / h_nom * Q_nom
        c_max_nom = 2.865952381+50; % c_max/h_nom
        h_max_nom = 1.9048+30; %h_max / h_nom
        k_nom = 1;
        n_min = 0.35;
        
        % power parameters
        aP_nom = -0.231739472; %a*(Q_nom^2) / h_nom
        bP_nom = 0.269910983; %b / h_nom * Q_nom
        cP_nom = 0.715406157; % c/h_nom
        dP_nom = 0.250347567;
        inverterP = 5; % W
        aPmax_nom = 0.220011766;
        bPmax_nom = 0.233540616;
        cPmax_nom = 0.960899702;
        dPmax_nom = 0.538063555;  
        Pmax_nom = 1.100993049; %(Pmax - inverterP) / Pnom
    otherwise
        error('pump type not recognised')
end


k = k_nom * h_nom / (Q_nom^2);
a_ref = a_nom*h_nom / (Q_nom^2);
b_ref = b_nom*h_nom / Q_nom;
c_ref = c_nom*h_nom;

a_max = a_max_nom*h_nom / (Q_nom^2);
b_max = b_max_nom*h_nom / Q_nom;
c_max = c_max_nom*h_nom;
h_max = h_max_nom*h_nom;

aP_ref = aP_nom / (Q_nom^3) * P_nom;
bP_ref = bP_nom / (Q_nom^2) * P_nom;
cP_ref = cP_nom / Q_nom * P_nom;
dP_ref = dP_nom * P_nom;

aP_max = aPmax_nom / (Q_nom^3) * P_nom;
bP_max = bPmax_nom / (Q_nom^2) * P_nom;
cP_max = cPmax_nom / Q_nom * P_nom;
dP_max = dPmax_nom * P_nom;
Pmax = Pmax_nom * P_nom + inverterP;

end

