clear;
teamFolder = "/home/mandicluka/FER/StemGamesEngineering2019/RobotArm/InputFiles";
run('simulation_params.m')

%% KINEMATICS
folder = teamFolder + "/Kinematics/";
files = dir(folder);


direct = 0;
inverse = 0;
direct_table = 0;
inverse_table = 0;
for i=1:length(files)  
    file = files(i);
    fileName = convertCharsToStrings(file.name);
    [path, name, ext] = fileparts(fileName);
    if name == "direktna"
        if direct == 0
            direct = 1;
            direct_table = readtable(folder + fileName);
        else
            assert(false, "More than 1 file for direct.")
        end
    elseif name == "inverzna"
        if inverse == 0
            inverse = 1;
            inverse_table = readtable(folder + fileName);
        else
            assert(false, "More than 1 file for inverse.")
        end
    end
end



if direct
    assert(all((size(direct_table.Variables) == [1, 5])), "Wrong csv format for direct.");
    
    setCraneInPosition(direct_table)
    refBase = [[0], [direct_table.q1]];
    refRot = [[0], [direct_table.q2]];
    refTrans1 = [[0], [direct_table.q3]];
    refTrans2 = [[0], [direct_table.q4]];
    refPulley = [[0], [direct_table.q5]];
    
end

if inverse
    
end

