
Q_nom = 5.4/20; % [m3/h] fuel pump nominal volume flow rate
h_nom =  4.2*1.1; %[m] fuel pump nominal head
P_nom = 100.7/20;
n_ref = 0.70; %[-] nominal relative speed
n_max = 1;
pump_type = 'type1'; % pump type
[a_ref,b_ref, c_ref, a_max, b_max, c_max, h_max, k_pipe, n_min, aP_ref, bP_ref, cP_ref, dP_ref, inverterP, aP_max, bP_max, cP_max, dP_max, Pmax] = fuel_pump_parameters(Q_nom,h_nom, P_nom, pump_type);

Results = table(a_ref, b_ref, c_ref ,aP_ref, bP_ref, cP_ref, dP_ref,a_max, b_max, c_max, n_ref, n_min,n_max,h_max )