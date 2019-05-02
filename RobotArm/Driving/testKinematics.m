actuatorVector = [actuatorRefOne; actuatorRefTwo; actuatorRefThree];

for i=1:3
    table.q1 = actuatorVector(i,1);
    table.q2 = actuatorVector(i,2);
    table.q3 = actuatorVector(i,3);
    table.q4 = actuatorVector(i,4);
    table.q5 = actuatorVector(i,5);
    
    % Calculate top of the crane position and set load position
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
    if(theta <= pi/4)
        deltaY = (1 + R*deg2rad(table.q5) - table.q3 - table.q4 - 0.36*sin(theta))/2 + 0.36*sin(theta);
        xp = (x0+ (L-0.18)*cos(theta))*cos(deg2rad(table.q1));
        yp = y0 + L*sin(theta) - deltaY - 1.325;
        zp = -(x0+ (L-0.18)*cos(theta))*sin(deg2rad(table.q1));
    else
        deltaY = (1 + R*deg2rad(table.q5) - table.q3 - table.q4)/2;
        xp = (x0+ L*cos(theta))*cos(deg2rad(table.q1));
        yp = y0 + L*sin(theta) - deltaY - 1.325;
        zp = -(x0+ L*cos(theta))*sin(deg2rad(table.q1));   
    end

    position(i,:) = [xp, yp, zp];

    %xt = (x0+ L*cos(theta))*cos(deg2rad(table.q1));
    %yt = y0 + L*sin(theta);
    %zt = -(x0+ L*cos(theta))*sin(deg2rad(table.q1));
end
position