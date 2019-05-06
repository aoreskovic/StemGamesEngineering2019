%% SIMULATE IDENTIFICATION
files = dir(identifyFolder + "Input");
kranFile = "../kran/kran";


open_system(kranFile + ".slx");
set_param("kran/isIdentification", 'value', "1");
set_param("kran/isCreate", 'value', "1");
set_param('kran', 'SimParseCustomCode', "off");
set_param('kran', 'SimUserSources', "");
set_param('kran', 'SimCustomHeaderCode', "");

outputFileId = fopen(identifyFolder + "Input/" + "result.txt", "w");
try
    for i=1:length(files)  
        file = files(i);
        fileName = convertCharsToStrings(file.name);
        [path, name, ext] = fileparts(fileName);
        if ext == ".csv"
            signals = csvread(identifyFolder + "Input/" + fileName);
            dims = size(signals);
            if dims(2) ~= 6
                throw(exception)
            end   
        end
    end
    
catch
    fprintf(outputFileId, "Error loading fils!" + newline + ...
            "Check again for dimensions and csv format! Input has to have 6 columns: " ...
            + newline + "    time, baseVoltage, rotValve," + ...
            " transValve1, transValve2 and pulleyVoltage, respectively!!");
    fclose(outputFileId);
    return
end

fprintf(outputFileId, "All files loaded successfully!" + newline);

% needs to be done...
rt = sfroot;
methodHandles = rt.find('-isa','Stateflow.EMChart');
code = "function y = base(t, coordNum, pos, vel, load_pos, load_vel, top_pos, top_vel)" + ...
       newline + "  y = 0;" + newline + "end";
for i=1:length(methodHandles)
    if string(methodHandles(i).path) == "kran/ControllerRot/RegulatorRot"
       methodHandles(i).Script = code;
       set_param(methodHandles(i).path, 'SystemSampleTime', num2str(Ts));
    end
    if string(methodHandles(i).path) == "kran/ControllerTrans1/RegulatorTrans1"
       methodHandles(i).Script = code;
       set_param(methodHandles(i).path, 'SystemSampleTime', num2str(Ts));
    end   
    if string(methodHandles(i).path) == "kran/ControllerTrans2/RegulatorTrans2"
       methodHandles(i).Script = code;
       set_param(methodHandles(i).path, 'SystemSampleTime', num2str(Ts));
    end   
    if string(methodHandles(i).path) == "kran/ControllerBase/RegulatorBase"
       methodHandles(i).Script = code;
       set_param(methodHandles(i).path, 'SystemSampleTime', num2str(Ts));
    end   
    if string(methodHandles(i).path) == "kran/ControllerPulley/RegulatorPulley"
       methodHandles(i).Script = code;
       set_param(methodHandles(i).path, 'SystemSampleTime', num2str(Ts));
    end   
end 

try
    identTime = signals(:, 1);
    base = signals(:, 2);
    rot = signals(:, 3);
    trans1 = signals(:, 4);
    trans2 = signals(:, 5);
    pulley = signals(:, 6);

    baseVoltage = [identTime, [base]];
    rotValve = [identTime, [rot]];
    transValve1 = [identTime, [trans1]];
    transValve2 = [identTime, [trans2]];
    pulleyVoltage = [identTime, [pulley]];
    
catch
    fprintf(outputFileId, "Dimensions of input vectors are not equal!");
    fclose(outputFileId);
    return
end

Tsim = identTime(end);

pointOne = [0 0 0];
pointTwo = [0 0 0];
pointThree = [0 0 0];
refPointsVector = [pointThree, pointOne, pointThree, pointTwo, pointThree];
timeGain = 0;
distanceGain = 0;

q1 = 0; q2 = 0.194; q3 = 0; q4 = 0; q5 = 0;

setCraneInPosition(table(q1, q2, q3, q4, q5))

try
    sim(kranFile + ".slx")
catch
    fprintf(outputFileId, "Simulation failed! Check for actuator limits!");
    fclose(outputFileId);
    return
end

M = [baseMotor.time,  baseMotor.signals.values(:, 2), rotCylinder.signals.values(:, 2), ...
     transCylinder1.signals.values(:, 2), transCylinder2.signals.values(:, 2), ...
     pulleyMotor.signals.values(:, 2)];

csvwrite(identifyFolder + "Output/" + "signals.csv", M);

fprintf(outputFileId, "Outputs created!" + newline);

files = dir(readOnlyFolder);
for i=1:length(files)
   name = string(files(i).name);
   if name ~= "." && name ~= ".."
        delete(readOnlyFolder + name);
   end
end


files = dir(signalsFolder);
indices = randsample(round((length(files)-2) /2), numTestCases);
for i=1:length(indices)
    copyfile(signalsFolder + "input_signals" + num2str(indices(i)) + ".csv", readOnlyFolder);
    copyfile(signalsFolder + "start_position" + num2str(indices(i)) + ".csv", readOnlyFolder);  
end


len = length(dir(readOnlyFolder));
filesCount = 1;
for i=1:len
    
    files = dir(readOnlyFolder);
    [~, name, ext] = fileparts(files(i).name);
    name = string(name); ext = string(ext);
    if startsWith(name, "input_signals")
        index = str2num(erase(name, "input_signals"));
        currName = "input_signals" + num2str(filesCount) + ".csv";
        cont = 0;
        for j=1:length(files)
           if string(files(j).name) == currName
               cont = 1;
               break
           end
        end
        
        if cont
            filesCount = filesCount + 1;
            continue
        end
        
        movefile(readOnlyFolder + files(i).name, readOnlyFolder + currName);
        movefile(readOnlyFolder + "start_position" + num2str(index) + ".csv", ...
                 readOnlyFolder + "start_position" + num2str(filesCount) + ".csv");
        filesCount = filesCount + 1;
    end
end

fprintf(outputFileId, "New reference set!" + newline);

copyfile(identifyFolder + "Input/" + "result.txt", identifyFolder + "Output/");
fclose(outputFileId);
return




    