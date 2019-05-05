function [qm, Q, h, P, flag1, flag2, flag3, flag4] = fuel_pump(relative_speed, a_ref, b_ref, c_ref, n_ref, k_pipe, a_max, b_max, c_max, h_max, n_min, rho, aP_ref, bP_ref, cP_ref, dP_ref, inverterP, aP_max, bP_max, cP_max, dP_max, Pmax)
%fuel_pump Calculation of pump flow rate
%   Inputs:
%       - relative_speed [-] relative pump speed [n_min-1]
%       - a_ref [h2/m5] pump quadratic coefficient at n_ref speed
%       - b_ref [h/m2] pump linear coefficient at n_ref speed
%       - c_ref [m] pump consrant coefficient at n_ref speed
%       - n_ref [-] reference relative pump speed
%       - k_pipe [h2/m5] pipe coefficient
%       - a_max [h2/m5] pump quadratic coefficient for maximum head
%       - b_max [h/m2] pump linear coefficient for maximum head
%       - c_max [m] pump consrant coefficient for maximum head
%       - h_max [m] maximum pump head
%       - n_min [-] minimum relative pump speed
%   Outputs:
%       - qm [kg/s] pump volume flow rate


assert(relative_speed >= n_min, 'pump speed too low')
a = a_ref;
b = b_ref * relative_speed / n_ref;
c = c_ref * (relative_speed/n_ref)^2;

k = k_pipe;
poly = [a-k, b, c];
r = roots(poly);
assert(isreal(r), 'Roots not real')
assert(any(r>0), 'negative roots')
Q = r(r>0);
assert(isscalar(Q), 'both roots positive')
h = a*Q^2+b*Q+c;
flag1=0;
flag2=0;
if h > h_max
    poly = [-k, 0, h_max];
    r = roots(poly);
    assert(isreal(r), 'Roots not real')
    assert(any(r>0), 'negative roots')
    Q = r(r>0);
    assert(isscalar(Q), 'both roots positive')
    flag1 = 1;
    h = h_max;
end
h_max_cav = a_max*Q^2+b_max*Q+c_max;
if h>h_max_cav
    poly = [a_max-k, b_max, c_max];
    r = roots(poly);
    assert(isreal(r), 'Roots not real')
    assert(any(r>0), 'negative roots')
    Q = r(r>0);
    assert(isscalar(Q), 'both roots positive')
    flag2=1;
    h = a_max*Q^2+b_max*Q+c_max;

end
qm = Q * rho / 3600; % [kg/s] pump mass flow rate
aP = aP_ref;
bP = bP_ref * relative_speed / n_ref;
cP = cP_ref * (relative_speed/n_ref)^2;
dP = dP_ref * (relative_speed/n_ref)^3;
P = aP*Q^3 + bP*Q^2 + cP*Q + dP + inverterP;
flag3=0;
flag4=0;
if P>Pmax
    P=Pmax;
    flag3 = 1;
end
P_max2 = aP_max*Q^3 + bP_max*Q^2 + cP_max*Q + dP_max + inverterP;
if P > P_max2
    P = P_max2;
    flag4 = 1;
end
end

