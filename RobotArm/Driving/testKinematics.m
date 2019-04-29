table.q1 = 0;
table.q2 = 0.7;
table.q3 = 3.4;
table.q4 = 3.4;
table.q5 = 6150;

L = 4.85949 + table.q3 + table.q4;
a = 1.81648;
b = 0.6634945;
c0 = 1.331 + 0.194;
c = 1.331 + table.q2;
R = 0.135;

gamma = acos((c^2 - a^2 - b^2)/(-2*a*b));
gamma0 = acos((c0^2 - a^2 - b^2)/(-2*a*b));
theta = gamma - gamma0;

x0 = -0.24164;
y0 = 2.640;
deltaY = (R*deg2rad(table.q5) - table.q3 - table.q4 - 0.31*sin(theta))/2 + 0.31*sin(theta);

xp = (x0+ (L-0.15)*cos(theta))*cos(deg2rad(table.q1));
yp = y0 + L*sin(theta) - deltaY  - 0.5 -0.825;
zp = -(x0+ (L-0.15)*cos(theta))*sin(deg2rad(table.q1));

xt = (x0+ L*cos(theta))*cos(deg2rad(table.q1));
yt = y0 + L*sin(theta);
zt = -(x0+ L*cos(theta))*sin(deg2rad(table.q1));