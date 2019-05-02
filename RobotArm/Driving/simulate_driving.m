%% DRIVING
files = dir(solutionFolder);
rt = sfroot;
methodHandles = rt.find('-isa','Stateflow.EMChart');
kranFile = "../kran/kran";
% find extension of files
last = files(end);
lastName = convertCharsToStrings(last.name);
[path, name, ext] = fileparts(lastName);
isC = ext == ".c";

open_system(kranFile + ".slx");


set_param("kran/isIdentification", 'value', "0");
if isC
    set_param('kran', 'SimParseCustomCode', "on");
else
    set_param('kran', 'SimParseCustomCode', "off");
end


try
    % if .c files, first create .m files
    if isC
        str = "";
        for i=1:length(files)  
            file = files(i);
            fileName = convertCharsToStrings(file.name);
            [path, name, ext] = fileparts(fileName);
            if ext == ".c"
                fileId = fopen(readOnlyFolder + name + ".m",'w');                 
                fprintf(fileId,'%s', ... 
                  "function y = " + name + "_reg" + "(t, posRef, pos, vel, load_pos, load_vel, top_pos, top_vel)" + newline ...
                  + "loadVel.x = load_vel(1); loadVel.y = load_vel(2); loadVel.z = load_vel(3);" + newline ...
                  + "loadPos.x = load_pos(1); loadPos.y = load_pos(2); loadPos.z = load_pos(3);" + newline ...
                  + "topPos.x = top_pos(1); topPos.y = top_pos(2); topPos.z = top_pos(3);" + newline ...
                  + "topVel.x = top_vel(1); topVel.y = top_vel(2); topVel.z = top_vel(3);" + newline ...
                  + "y = 0;" + newline ...
                  + "coder.cstructname(loadVel, 'Coords');" + newline ...
                  + "coder.cstructname(loadPos, 'Coords');" + newline ...
                  + "coder.cstructname(topPos, 'Coords');" + newline ...
                  + "coder.cstructname(topVel, 'Coords');" + newline ...
                  + "y = coder.ceval('wrapper_" + name + "',t , posRef , pos , vel, coder.ref(loadVel), ..." + newline ...
                  + "coder.ref(loadPos), coder.ref(topPos), coder.ref(topVel));" + newline ...
                  + "end");

                str = str + solutionFolder + fileName + " ";
                fclose(fileId);
            end
        end 
        str = str + readOnlyFolder + "c_utils.c";
        set_param('kran', 'SimUserSources', str)
        set_param('kran', 'SimCustomHeaderCode', "#include """ + readOnlyFolder + "c_code.h""")
    end

    % set .m files
    
    if isC
        folder = readOnlyFolder;
    else
        folder = solutionFolder;
    end
    
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
    
    if isC
        files = dir(readOnlyFolder);
        for i=1:length(files)
            file = files(i);
            fileName = convertCharsToStrings(file.name);
            [path, name, ext] = fileparts(fileName);
            if ext == ".m"
                delete(readOnlyFolder + fileName)
            end
        end
    end

    if mask ~= [1, 1, 1, 1, 1]
        throw(exception);
    end

catch
   outputFileId = fopen(solutionFolder + "result.txt", "w");
   fprintf(outputFileId, "Error while loading files. All files should be .m or .c files!");
   fclose(outputFileId);
   return
end


pointOne = [8 5.65 0];
pointTwo = [-7.5 3.4 7.5]; %Rijeseno
pointThree = [0 2.9 2.5]; %Rijeseno

refPointsVector = [pointThree, pointOne, pointThree, pointTwo, pointThree];

actuatorRefOne = [0, 0.7, 3.4, 3.4, 6150];
actuatorRefTwo = [-135, 0.415, 3.4, 3.4, 4300];
actuatorRefThree = [-90, 0.8, 0, 0, 2000];
actuatorRefVector = [actuatorRefThree; actuatorRefOne,; actuatorRefThree; actuatorRefTwo; actuatorRefThree];



sim(kranFile + ".slx")

WriteDrivingResults(solutionFolder, activeTime, performanceCost, pointIndex, isFinished)
copyfile(solutionFolder + "result.txt", readOnlyFolder);
fclose(outputFileId);
return




    