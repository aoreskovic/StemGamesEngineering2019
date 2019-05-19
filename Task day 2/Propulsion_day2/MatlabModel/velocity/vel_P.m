velocities = [0.1:0.1:100]';
l=15;
rad = 1.5;
Powers = zeros(length(velocities),1);
for i = 1:length(velocities)
    vel=velocities(i);
    P = sub_power(vel,l, rad);
    Powers(i) = P;
end
EXCEL = [Powers velocities];
