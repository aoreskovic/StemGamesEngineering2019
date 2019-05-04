clear all;
close all;

err = linkError.instance();
err.flushErorrs();

% outputScoreData = ["Team"; "Scenario 1"; "Scenario 2"; "Scenario 3"; "Scenario 4"; "Total"; "Last evaluated"]';

teams = ["reference"];

for teamIdx = 1:length(teams)
    teamName = teams(teamIdx);
    teamScore = [];

    delete(strcat(teamName,"/log.txt"));
    diary(strcat(teamName,"/log.txt"));
    diary on;

    time = clock;
    teamTime = sprintf('%02d:%02d:%02d', time(4), time(5), round(time(6)));

    disp(sprintf("Evaluation started at %s\n\n",teamTime));

    if (exist(teamName,'dir') ~= 7)
        error('No team folder');
    end

    if (exist(strcat(teamName,"/elements1.csv"),'file') ~= 2)
        teamScore = zeros(1,4);
        disp("No beamformer implemented for task 1.");
    else

        elements = csvread(strcat(teamName,"/elements1.csv"));

        % Scenario 1
        fprintf('===========================\nTASK 1, SCENARIO 1\n===========================\n');

        targetAz = 0;

        if (exist(strcat(teamName,"/scenario1.csv"),'file') ~= 2)
            score = 0;
            disp("No solution for scenario 1.");
        else
            bfMatrix = csvread(strcat(teamName,"/scenario1.csv"));

            try
                Task1_Sc123;
            catch e
                disp(e.message);
                score = 0;
            end
        end

        teamScore = [teamScore score];

        err.printErrors();
        err.flushErorrs();

        % Scenario 2
        fprintf('\n===========================\nTASK 1, SCENARIO 2\n===========================\n');

        targetAz = 30;

        if (exist(strcat(teamName,"/scenario2.csv"),'file') ~= 2)
            score = 0;
            disp("No solution for scenario 2.");
        else
            bfMatrix = csvread(strcat(teamName,"/scenario2.csv"));

            try
                Task1_Sc123;
            catch e
                disp(e.message);
                score = 0;
            end
        end

        teamScore = [teamScore score];

        err.printErrors();
        err.flushErorrs();

        % Scenario 3
        fprintf('\n===========================\nTASK 1, SCENARIO 3\n===========================\n');

        targetAz = 60;

        if (exist(strcat(teamName,"/scenario3.csv"),'file') ~= 2)
            score = 0;
            disp("No solution for scenario 3.");
        else
            bfMatrix = csvread(strcat(teamName,"/scenario3.csv"));

            try
                Task1_Sc123;
            catch e
                disp(e.message);
                score = 0;
            end
        end

        teamScore = [teamScore score];

        err.printErrors();
        err.flushErorrs();

        % Scenario 4
        fprintf('\n===========================\nTASK 1, SCENARIO 4\n===========================\n');

        targetAz = 70;

        if (exist(strcat(teamName,"/scenario4.csv"),'file') ~= 2)
            score = 0;
            disp("No solution for scenario 4.");
        else
            bfMatrix = csvread(strcat(teamName,"/scenario4.csv"));

            try
                Task1_Sc4;
            catch e
                disp(e.message);
                score = 0;
            end
        end

        teamScore = [teamScore score];

        err.printErrors();
        err.flushErorrs();

    end

    if (exist(strcat(teamName,"/elements2.csv"),'file') ~= 2)
        teamScore = zeros(1,4);
        disp("No beamformer implemented for task 2.");
    else

        elements = csvread(strcat(teamName,"/elements2.csv"));

        % Scenario 5
        fprintf('===========================\nTASK 2, SCENARIO 5\n===========================\n');

        targetAz = 45;
        targetEl = 60;

        if (exist(strcat(teamName,"/scenario5.csv"),'file') ~= 2)
            score = 0;
            disp("No solution for scenario 5.");
        else
            bfMatrix = csvread(strcat(teamName,"/scenario5.csv"));

            try
                Task2_Sc5;
            catch e
                disp(e.message);
                score = 0;
            end
        end

        teamScore = [teamScore score];

        err.printErrors();
        err.flushErorrs();
    end
    
    close all;
    
    % Collect score

    teamScore = [teamScore sum(teamScore)];

    time = clock;
    teamTime = sprintf('%02d:%02d:%02d', time(4), time(5), round(time(6)));
    
    disp(sprintf("\n\n===========================\nTotal score: %2.04f\nEvaluation completed at %s", teamScore(end), teamTime));

    diary off;

    % Format and write output file

    outputCsvString = strcat(teamName,";");
    for col = 1:length(teamScore)
        outputCsvString = sprintf('%s%2.4f;',outputCsvString,teamScore(col));
    end
    outputCsvString = outputCsvString(1:end-1);
    outputCsvString = sprintf('%s;%s',outputCsvString,teamTime);
    
    outputCsvFile = fopen(strcat("score_",teamName,".csv"),'w');
    fprintf(outputCsvFile,'%s',outputCsvString);
    fclose(outputCsvFile);

end
