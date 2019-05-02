%% TEST IDENTIFICATION
files = dir(solutionFolder);
kranFile = "../kran/kran";


open_system(kranFile + ".slx");
set_param("kran/isIdentification", 'value', "1");

outputFileId = fopen(solutionFolder + "result.txt", "w");
try
    for i=1:length(files)
        file = files(i);
        fileName = convertCharsToStrings(file.name);
        [path, name, ext] = fileparts(fileName);
        if ext == ".csv"
            if name == "base"
                solBase = csvread(solutionFolder + fileName);
                solBase = solBase(:,1:2);
                dims = size(solBase);
                if dims(2) ~= 2
                    throw(exception)
                end
            elseif name == "rot"
                solRot = csvread(solutionFolder + fileName);
                solRot = solRot(:,1:2);
                dims = size(solRot);
                if dims(2) ~= 2
                    throw(exception)
                end
            elseif name == "trans1"
                solTrans1 = csvread(solutionFolder + fileName);
                solTrans1 = solTrans1(:,1:2);
                dims = size(solTrans1);
                if dims(2) ~= 2
                    throw(exception)
                end
            elseif name == "trans2"
                solTrans2 = csvread(solutionFolder + fileName);
                solTrans2 = solTrans2(:,1:2);
                dims = size(solTrans2);
                if dims(2) ~= 2
                    throw(exception)
                end
            elseif name == "pulley"
                solPulley = csvread(solutionFolder + fileName);
                solPulley = solPulley(:,1:2);
                dims = size(solPulley);
                if dims(2) ~= 2
                    throw(exception)
                end
            else
                fprintf(outputFileId, "Unknown csv file! Remove it and try again!");
                fclose(outputFileId);
                return    
            end
        end
    end  
catch
    fprintf(outputFileId, "Error loading fils!" + newline + ...
            "Check again for dimensions and csv format! Soulution has to have 5 files: " ...
            + newline + "    base, rot, trans1," + ...
            " trans2 and pulley." + newline + "Every file hast to have 2 columns: " ...
            + newline + "    time and position.");
            
    fclose(outputFileId);
    return
end

fprintf(outputFileId, "All files loaded successfully!" + newline);

% needs to be done again...
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


% load test signals and set crane in default position
signals = csvread(readOnlyFolder + "signals.csv");
q1 = 0; q2 = 0.194; q3 = 0; q4 = 0; q5 = 0;
table = table(q1, q2, q3, q4, q5);
          
setCraneInPosition(table);
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

Tsim = identTime(end);

try
    sim(kranFile + ".slx");
catch
    fprintf(outputFileId, "Simulation failed! Check for actuator limits!");
    fclose(outputFileId);
    return
end

try
    deltaBaseVel = baseMotor.signals.values(:, 1) - solBase(:, 2);
    deltaRotVel = rotCylinder.signals.values(:, 1) - solRot(:, 2);
    deltaTrans1Vel = transCylinder1.signals.values(:, 1) - solTrans1(:, 2);
    deltaTrans2Vel = transCylinder2.signals.values(:, 1) - solTrans2(:, 2);
    deltaPulleyVel = pulleyMotor.signals.values(:, 1) - solPulley(:, 2);
    
catch
    fprintf(outputFileId, "Sample time is wrong. Use Ts=" + num2str(Ts));
    fclose(outputFileId);
    return
end


score = deltaBaseVel^2 + deltaRotVel^2 + deltaTrans1Vel^2 + deltaTrans2Vel^2 + deltaPulleyVel^2;

copyfile(solutionFolder + "result.txt", readOnlyFolder);
fclose(outputFileId);
return




    