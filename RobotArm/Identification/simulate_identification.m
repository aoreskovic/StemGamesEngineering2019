%% IDENTIFICATION
files = dir(identifyFolder + "Input");
kranFile = "../kran/kran";


open_system(kranFile + ".slx");
set_param("kran/isIdentification", 'value', "1");

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
            " transValve1, transValve2 and pulleyVoltage respectively!!");
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


[t, base, rot, trans1, trans2, pulley] = createRandomSignals(100, Ts);
M = [t', base', rot', trans1', trans2', pulley'];
csvwrite(readOnlyFolder + "signals.csv", M);


fprintf(outputFileId, "New reference set!" + newline);

try
    sim(kranFile + ".slx")
catch
    fprintf(outputFileId, "Simulation failed! Check for actuator limits!");
    fclose(outputFileId);
    return
end

M = [rotCylinder.time, rotCylinder.signals.values(:, 2)];
csvwrite(identifyFolder + "Output/" + "rot.csv", M);
M = [transCylinder1.time, transCylinder1.signals.values(:, 2)];
csvwrite(identifyFolder + "Output/" + "trans1.csv", M);
M = [transCylinder2.time, transCylinder2.signals.values(:, 2)];
csvwrite(identifyFolder + "Output/" + "trans2.csv", M);
M = [baseMotor.time, baseMotor.signals.values(:, 2)];
csvwrite(identifyFolder + "Output/" + "base.csv", M);
M = [pulleyMotor.time, pulleyMotor.signals.values(:, 2)];
csvwrite(identifyFolder + "Output/" + "pulley.csv", M);

fprintf(outputFileId, "Outputs created!");

copyfile(identifyFolder + "Input/" + "result.txt", identifyFolder + "Output/");
fclose(outputFileId);
return




    