function y = setCraneInPosition(table)
    
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
    
    str = "RigidTransform|Cartesian|0|m|compiletime|+Z|" + ...
          "[8 7 0]" + ...
          "|compiletime|0|m|compiletime|0|m|compiletime|0|deg|" + ...
          "compiletime|None|deg|+Z|0.0|compiletime|[0 0 1]|compiletime" + ...
          "|+X|+Y|+Y|+Z|FollowerAxes|XYX|[0 0 0]|deg|" + ...
          "compiletime|[1 0 0; 0 1 0; 0 0 1]|compiletime|" + ...
          "simmechanics.library.frames_transforms.rigid_transform"
      
    set_param("kinematics_crane/Crane/Crane Mechanics" + ...
              "/BeltAndPulley/Rigid Transform2", 'MaskValueString', str)
end


