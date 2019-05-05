clear all
Q_nom = 5.4/60; % [m3/h] fuel pump nominal volume flow rate
h_nom =  4.2; %[m] fuel pump nominal head
P_nom = 100.7;
n_ref = 0.76; %[-] nominal relative speed
rho_ethanole = 789; %kg/m3, ethanole density

pump_type = 'type3'; % pump type
[a_ref,b_ref, c_ref, a_max, b_max, c_max, h_max_const, k_pipe, n_min, aP_ref, bP_ref, cP_ref, dP_ref, inverterP, aP_max, bP_max, cP_max, dP_max, Pmax] = fuel_pump_parameters(Q_nom,h_nom, P_nom, pump_type);

Q=0:0.001:10.5;
Q=Q/60;
h_max=a_max.*Q.^2+b_max.*Q+c_max;
h_max = min(h_max, h_max_const);
h_max = max(h_max,0);

relative_speed = 0.76;
assert(relative_speed >= n_min, 'pump speed too low')
a = a_ref * (n_ref/relative_speed).^2;
b = b_ref * n_ref / relative_speed;
c = c_ref;
h_ref=a.*Q.^2+b.*Q+c;
h_ref=min(h_ref,h_max);
h_ref=max(h_ref,0);


relative_speeds=0.35:0.05:1;
abc=zeros(length(relative_speeds), 3);
abc(:,1) = a_ref;
abc(:,2) = b_ref .* relative_speeds(:) ./ n_ref;
abc(:,3) = c_ref .* (relative_speeds(:)./n_ref).^2;

h=zeros(length(Q), length(relative_speeds));
for i = 1:length(relative_speeds);
    h(:,i) = abc(i,1).*Q.^2+abc(i,2).*Q+abc(i,3);
    h(:,i) = min(h(:,i),h_max');
end
h=max(h,0);
figure
plot(Q,h_ref, 'k', Q,h_max, 'k');
hold on
for i = 1:length(relative_speeds)
    plot(Q,h(:,i),'k')
end

%[~, ~, h, ~, ~, ~, ~, ~] = fuel_pump(0.7, a_ref, b_ref, c_ref, n_ref, k_pipe, a_max, b_max, c_max, h_max, n_min, rho_ethanole, aP_ref, bP_ref, cP_ref, dP_ref, inverterP, aP_max, bP_max, cP_max, dP_max, Pmax); % kg/s, nominal fuel mass flow rate
