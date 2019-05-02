function status = setCraneInPosition(table)
    
    status = 0; % By defaulty, return OK
    rot_pattern1 = '^(?:[^|]*\|){33}([^|]*)';
    rot_pattern2 = '(?:[^|]*\|){6}([^|]*)$';
    trans_pattern1 = '^(?:[^|]*\|){33}([^|]*)';
    trans_pattern2 = '(?:[^|]*\|){31}([^|]*)$';

    % set base
    str = get_param("kinematics_crane/Crane/Crane Mechanics/Revolute4", 'MaskValueString');
    [s, e] = regexp(str, rot_pattern1);
    str1 = str(s:e) + "|";
    [s, e] = regexp(str, rot_pattern2);
    str2 =  "|" + str(s:e);
    str = str1 + "on|High|" + num2str(table.q1) + "|deg" + str2;
    set_param('kinematics_crane/Crane/Crane Mechanics/Revolute4', 'MaskValueString', str);
    
    % set rot
    str = get_param("kinematics_crane/Crane/Crane Mechanics/" + ...
                    "hidraulicki_rot_1/Cylindrical Joint", 'MaskValueString');
    [s, e] = regexp(str, trans_pattern1);
    str1 = str(s:e) + "|";
    [s, e] = regexp(str, trans_pattern2);
    str2 =  "|" + str(s:e);
    str = str1 + "on|High|" + num2str(table.q2) + "|m" + str2;
    set_param("kinematics_crane/Crane/Crane Mechanics/" + ...
              "hidraulicki_rot_1/Cylindrical Joint", 'MaskValueString', str);
    
    % set trans1
    str = get_param("kinematics_crane/Crane/Crane Mechanics/" + ...
                    "hidraulicki_trans1_1/Cylindrical Joint", 'MaskValueString');
    [s, e] = regexp(str, trans_pattern1);
    str1 = str(s:e) + "|";
    [s, e] = regexp(str, trans_pattern2);
    str2 =  "|" + str(s:e);
    str = str1 + "on|High|" + num2str(table.q3) + "|m" + str2;
    set_param("kinematics_crane/Crane/Crane Mechanics/" + ...
              "hidraulicki_trans1_1/Cylindrical Joint", 'MaskValueString', str);
    
    % set trans2
    str = get_param("kinematics_crane/Crane/Crane Mechanics/" + ...
                    "hidraulicki_trans2_2/Cylindrical Joint", 'MaskValueString');
    [s, e] = regexp(str, trans_pattern1);
    str1 = str(s:e) + "|";
    [s, e] = regexp(str, trans_pattern2);
    str2 =  "|" + str(s:e);
    str = str1 + "on|High|" + num2str(table.q4) + "|m" + str2;
    set_param("kinematics_crane/Crane/Crane Mechanics/" + ...
              "hidraulicki_trans2_2/Cylindrical Joint", 'MaskValueString', str);
    
    % set pulley
    str = get_param("kinematics_crane/Crane/Crane Mechanics" + ...
                    "/BeltAndPulley/Revolute Joint", 'MaskValueString');
    [s, e] = regexp(str, rot_pattern1);
    str1 = str(s:e) + "|";
    [s, e] = regexp(str, rot_pattern2);
    str2 =  "|" + str(s:e);
    str = str1 + "on|High|" + num2str(table.q5) + "|deg" + str2;
    set_param("kinematics_crane/Crane/Crane Mechanics" + ... 
              "/BeltAndPulley/Revolute Joint", 'MaskValueString', str);
    
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
        deltaY = (1 + R*deg2rad(table.q5) - table.q3 - table.q4 - 0.31*sin(theta))/2 + 0.31*sin(theta);
        xp = (x0+ (L-0.18)*cos(theta))*cos(deg2rad(table.q1));
        yp = y0 + L*sin(theta) - deltaY;
        zp = -(x0+ (L-0.18)*cos(theta))*sin(deg2rad(table.q1));
    else
        deltaY = (1 + R*deg2rad(table.q5) - table.q3 - table.q4)/2;
        xp = (x0+ L*cos(theta))*cos(deg2rad(table.q1));
        yp = y0 + L*sin(theta) - deltaY;
        zp = -(x0+ L*cos(theta))*sin(deg2rad(table.q1));   
    end

    position_str = "[" + num2str([xp yp zp]) + "]";
    angle_str =  num2str(table.q1 + 180);
    
    str = "RigidTransform|Cartesian|0|m|compiletime|+Z|" + ...
          position_str + ...
          "|compiletime|0|m|compiletime|0|m|compiletime|0|deg|" + ...
          "compiletime|StandardAxis|deg|+Y|" + angle_str + ...
          "|compiletime|[0 0 1]|compiletime" + ...
          "|+X|+Y|+Y|+Z|FollowerAxes|XYX|[0 0 0]|deg|" + ...
          "compiletime|[1 0 0; 0 0 -1; 0 1 0]|compiletime|" + ...
          "simmechanics.library.frames_transforms.rigid_transform";
      
    set_param("kinematics_crane/Crane/Crane Mechanics" + ...
              "/BeltAndPulley/Rigid Transform2", 'MaskValueString', str);
          
    % Check whether pulley angle is large enough not to break physical
    % constraints in the simulation
    dPulley = deltaY - 0.05; % Distance from the pulley to the top of the crane
    dTop = 0.18*sin(theta);
    if(dPulley - dTop <= 0.01)
        status = 1; % Constraints would be violated
    end
end



