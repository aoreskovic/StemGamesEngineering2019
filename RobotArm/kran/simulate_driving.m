clear;
teamFolder = "/home/mandicluka/FER/StemGamesEngineering2019/RobotArm/InputFiles";
run('simulation_params.m')

%% DRIVING
run('simulation_data.m')
folder = teamFolder + "/Driving/";
files = dir(folder);

rt = sfroot;
methodHandles = rt.find('-isa','Stateflow.EMChart');

% find extension of files
last = files(end);
lastName = convertCharsToStrings(last.name);
[path, name, ext] = fileparts(lastName);
isC = ext == ".c";

set_param('kran/isIdentification', 'value', "0")
if isC
    set_param('kran', 'SimParseCustomCode', "on")
else
    set_param('kran', 'SimParseCustomCode', "off")
end

% if .c files, first create .m files
str = "";
if isC
    for i=1:length(files)  
        file = files(i);
        fileName = convertCharsToStrings(file.name);
        [path, name, ext] = fileparts(fileName);
        if ext == ".c"
            fileId = fopen(folder + name + ".m",'w');
            fprintf(fileId,'%s', "function y = " + name + "(t, u, x, y)" + newline ...
                                 + "   y = coder.ceval('" + name + "',t, u, x, y);" ...
                                 + newline + "end");
            str = str + folder + fileName + " ";
            fclose(fileId);
        elseif ext == "." || ext == ".h"
            continue
        else
            assert(false, 'Not all files are .c files!!')
        end
    end 
    set_param('kran', 'SimUserSources', str)
    set_param('kran', 'SimCustomHeaderCode', "#include """ + folder + "c_code.h""")
    
end

% set .m files
files = dir(folder);
mask = [0, 0, 0, 0, 0];
for i=1:length(files)
    file = files(i);
    fileName = convertCharsToStrings(file.name);
    [path, name, ext] = fileparts(fileName);
    
    if name == "base" && ext ==".m"
        fileID = fopen(folder + fileName, 'r');
        code = fscanf(fileID, '%c');
        setFunction("kran/ControllerBase/RegulatorBase", code, Ts);
        mask = mask + [1, 0, 0, 0, 0];
    elseif name == "pulley" && ext ==".m"
        fileID = fopen(folder + fileName, 'r');
        code = fscanf(fileID, '%c');
        setFunction("kran/ControllerPulley/RegulatorPulley", code, Ts);
        mask = mask + [0, 1, 0, 0, 0];
    elseif name == "rot" && ext ==".m"
        fileID = fopen(folder + fileName, 'r');
        code = fscanf(fileID, '%c');
        setFunction("kran/ControllerRot/RegulatorRot", code, Ts);
        mask = mask + [0, 0, 1, 0, 0];
    elseif name == "trans1" && ext ==".m" 
        fileID = fopen(folder + fileName, 'r');
        code = fscanf(fileID, '%c');
        setFunction("kran/ControllerTrans1/RegulatorTrans1", code, Ts);
        mask = mask + [0, 0, 0, 1, 0];
    elseif name == "trans2" && ext ==".m"
        fileID = fopen(folder + fileName, 'r');
        code = fscanf(fileID, '%c');
        setFunction("kran/ControllerTrans2/RegulatorTrans2", code, Ts);
        mask = mask + [0, 0, 0, 0, 1];
    end

end

% if .c files, delete .m files
files = dir(folder);
if isC
    for i=1:length(files)
        file = files(i);
        fileName = convertCharsToStrings(file.name);
        [path, name, ext] = fileparts(fileName);
        if ext == ".m"
            delete(folder + fileName)
        end
    end
end

if mask ~= [1, 1, 1, 1, 1]
    assert(false, 'Not all files are set!!')
end
    