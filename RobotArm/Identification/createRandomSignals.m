clear;
deltaT = 7;
numSims = 5;    
eventProb = 0.5;
i = 0;
R = 0.135;
Ts = 0.05;
Tsim = 35;
signalsFolder = "/home/mandicluka/FER/StemGamesEngineering2019/RobotArm/InputFiles" + "/Identification/Signals/";
open_system('../kran/kran.slx');
run('../kran/simulation_params.m')
set_param("kran/isCreate", 'value', "0");
pointOne = [0 0 0];
pointTwo = [0 0 0];
pointThree = [0 0 0];
refPointsVector = [pointThree, pointOne, pointThree, pointTwo, pointThree];
timeGain = 0;
distanceGain = 0;

rotValve = [0, [0]]; transValve1 = [0, [0]]; transValve2 = [0, [0]]; 
baseVoltage = [0, [0]]; pulleyVoltage = [0, [0]];

%while i < numSims
    %i = i+1;
    
    isBaseSet = 0;
    isRotSet = 0;
    isTrans1Set = 0;
    isTrans2Set = 0;
    isPulleySet = 0;
    
    % set crane in random position
    q1 =  rand(1) * (360);
    q2 =  0.194;
    q3 = 0.1 + rand(1) * (3 - 0.1);
    q4 = 0.1 + rand(1) * (3 - 0.1);
    pulleyMin = 800+rad2deg((q3+q4)/R);
    q5 = pulleyMin + rand(1) * (3000 - pulleyMin);

    %temp
%     q1 =  0;
%     q2 =  0.194;
%     q3 = 0;
%     q4 = 0;
%     q5 = 5000;
    
    setCraneInPosition(table(q1, q2, q3, q4, q5));
    writetable(table(q1, q2, q3, q4, q5), signalsFolder + "start_position"+num2str(i) + ".csv")
    set_param('kran','simulationcommand', 'start');
    set_param('kran','simulationcommand', 'pause');
    pause(1)

    t = 0;
    simulationTime = 0;
    baseAmp = 0; rotAmp = 0; trans1Amp = 0; trans2Amp = 0; pulleyAmp = 0;
    start = 1;
    while t < Tsim  

        if ~start
            q2 = rotCylinder.signals.values(:, 1);
            q3 = transCylinder1.signals.values(:, 1);
            q4 = transCylinder2.signals.values(:, 1);
            q5 = pulleyMotor.signals.values(:, 1);
            start = 0;
        end


        if ~isBaseSet && rand(1) < eventProb
            isBaseSet = 1;
            baseAmp = (2*round(rand(1)) - 1) * randi([1, 4]) * 40;
        else
            if rand(1) < eventProb
                baseAmp = 0;
            end
        end
        hydraulicNum = randi([1, 3]);
        rotAmp = 0; trans1Amp = 0; trans2Amp = 0;
        if hydraulicNum == 1 && ~isRotSet
            % turn on rot
            isRotSet = 1;
            if q2 < 0.2
                rotAmp = 0.05;
            elseif q2 > 0.7
                rotAmp = -0.05;
            else
                rotAmp = (2*round(rand(1)) - 1) * 0.05;
            end   

        elseif hydraulicNum == 2 && ~isTrans1Set
            % turn on trans1
            isTrans1Set = 1;
            if q3 < 1
                trans1Amp =  0.05;        
            elseif q3 > 2.5
                trans1Amp = -0.05;
            else
                trans1Amp = (2*round(rand(1)) - 1) * 0.05;
            end

        elseif hydraulicNum == 3 && ~isTrans2Set
            % turn on trans2
            isTrans2Set = 1;
            if q4 < 1
                trans2Amp = 0.05;
            elseif q4 > 2.5
                trans2Amp = -0.05;
            else
                trans2Amp = (2*round(rand(1)) - 1) * 0.05;
            end
        end


        if rand(1) < eventProb
            if R * q5(end) - q3(end) - q4(end) < 2 && ~isPulleySet
                pulleyAmp = randi([1, 4]) * 30;
            elseif ~isPulleySet
                pulleyAmp = (2*round(rand(1)) - 1) * randi([1, 4]) * 30;
            end 
            isPulleySet = 1;
        else
            if rand(1) < eventProb
                pulleyAmp = 0;
            end
        end


        % temp
%             baseAmp = 180;baseAmp = 0; rotAmp = 0; trans1Amp = 0; trans2Amp = 0; pulleyAmp = 0;
%             rotAmp = 0;
%             trans1Amp = 0;
%             trans2Amp = 0;
%             pulleyAmp = 0;
        set_param('kran/baseRef', 'Value', num2str(baseAmp));
        set_param('kran/rotRef', 'Value', num2str(rotAmp));
        set_param('kran/trans1Ref', 'Value', num2str(trans1Amp));
        set_param('kran/trans2Ref', 'Value', num2str(trans2Amp));
        set_param('kran/pulleyRef', 'Value', num2str(pulleyAmp));

        set_param('kran','simulationcommand', 'continue')
        while simulationTime < t + deltaT 
            simulationTime = get_param('kran', 'SimulationTime');
            pause(0.05);
        end   


        set_param('kran','simulationcommand', 'pause');
        simulationTime = get_param('kran', 'SimulationTime');
        t = simulationTime;
        if abs(Tsim - t) < deltaT
            break
        end

        pause(1);                       
    end

    M = [baseMotor.time, baseRef.signals.values(:, 1), rotRef.signals.values(:, 1), ...
         trans1Ref.signals.values(:, 1), trans2Ref.signals.values(:, 1), ...
         pulleyRef.signals.values(:, 1)];
    csvwrite(signalsFolder + "input_signals"+num2str(i) + ".csv", M);
    done = 1;

    set_param('kran','simulationcommand', 'stop');
    pause(5);
%end


