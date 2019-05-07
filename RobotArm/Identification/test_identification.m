%% TEST IDENTIFICATION
files = dir(solutionFolder);
kranFile = "../kran/kran";


open_system(kranFile + ".slx");
set_param("kran/isIdentification", 'value', "1");
set_param("kran/isCreate", 'value', "1");
set_param('kran', 'SimParseCustomCode', "off");
set_param('kran', 'SimUserSources', "");
set_param('kran', 'SimCustomHeaderCode', "");

outputFileId = fopen(solutionFolder + "result.txt", "w");

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

score = 0;
for i=1:numTestCases
    try
        files = dir(solutionFolder);
        set = 0;
        for j=1:length(files)  
            file = files(j);
            fileName = convertCharsToStrings(file.name);
            [path, name, ext] = fileparts(fileName);
            if "signals" + num2str(i) + ".csv" == fileName
                signals = csvread(solutionFolder + file.name);
                dims = size(signals);
                if dims(2) ~= 6
                    throw(exception)
                end   
                
                solBase = signals(:, 2);
                solRot = signals(:, 3);
                solTrans1 = signals(:, 4);
                solTrans2 = signals(:, 5);
                solPulley = signals(:, 6);
                set = 1;
            end
        end
        if ~set 
           throw(exception); 
        end
    catch
        fprintf(outputFileId, "Error loading file for task " + num2str(i) + "!" + newline + ...
                "Check again for dimensions and csv format! Input has to have 6 columns: " ...
                + newline + "    time, baseVoltage, rotValve," + ...
                " transValve1, transValve2 and pulleyVoltage, respectively!!");
        continue
    end

    fprintf(outputFileId, "File for task" + num2str(i) + " loaded successfully!" + newline);
    
    % load test signals and set crane in default position
    signals = csvread(readOnlyFolder + "input_signals" + num2str(i) + ".csv");
    q1 = 0; q2 = 0.194; q3 = 0; q4 = 0; q5 = 0;

    setCraneInPosition(table(q1, q2, q3, q4, q5));
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

    pointOne = [0 0 0];
    pointTwo = [0 0 0];
    pointThree = [0 0 0];
    refPointsVector = [pointThree, pointOne, pointThree, pointTwo, pointThree];
    timeGain = 0;
    distanceGain = 0;

    try
        sim(kranFile + ".slx");
    catch
        fprintf(outputFileId, "Simulation failed! Check for actuator limits!");
        continue
    end

    try
        deltaBaseVel = baseMotor.signals.values(:, 2) - solBase;
        deltaRotVel = rotCylinder.signals.values(:, 2) - solRot;
        deltaTrans1Vel = transCylinder1.signals.values(:, 2) - solTrans1;
        deltaTrans2Vel = transCylinder2.signals.values(:, 2) - solTrans2;
        deltaPulleyVel = pulleyMotor.signals.values(:, 2) - solPulley;

    catch
        fprintf(outputFileId, "Sample time is wrong for example " + num2str(i) + ". Use Ts=" + num2str(Ts));
        continue
    end


    score = score + sum(deltaBaseVel.^2 + deltaRotVel.^2 + deltaTrans1Vel.^2 + ...
            deltaTrans2Vel.^2 + deltaPulleyVel.^2);
end

fprintf(outputFileId, "   score:" + num2str(score / numTestCases) + newline);
fclose(outputFileId);
copyfile(solutionFolder + "result.txt", readOnlyFolder);






    