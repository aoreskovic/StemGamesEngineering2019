clear all;
close all;

err = linkError.instance();
err.flushErorrs();

gdrive = "C:/work/gdrive/STEM Games 2019/Teams - Day 2 - References/";
teams = ["Akvanauti","Božje ovèice","Divljaè velikog momenta tromosti","FERIT","FESB","Gemischt","Kornjaèe","Mamlazi","Mehrob","Narodne mošnje","Njemaèki strikani","Papkovi papci","Pero Tips","STEM Gains","Stroicizam","Šiljo i Družina","Škrgiæi","Team Pokemon","Torpedo"];

while 1

    for teamIdx = 1:length(teams)
        teamName = teams(teamIdx);
        teamScore = [];

        if (exist(strcat(gdrive,teamName),'dir') ~= 7)
            error('No team folder');
        end

        delete("log.txt");
        diary("log.txt");
        diary on;

        time = clock;
        teamTime = sprintf('%02d:%02d:%02d', time(4), time(5), round(time(6)));

        disp(sprintf("Evaluation started at %s\n\n",teamTime));

        if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/elements1.csv"),'file') ~= 2)
            teamScore = zeros(1,4);
            disp("No beamformer implemented for task 1.");
        else

            elements = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/elements1.csv"));

            % Scenario 1
            fprintf('===========================\nTASK 1, SCENARIO 1\n===========================\n');

            targetAz = 0;

            if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario1.csv"),'file') ~= 2)
                score = 0;
                disp("No solution for scenario 1.");
            else
                bfMatrix = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario1.csv"));

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

            if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario2.csv"),'file') ~= 2)
                score = 0;
                disp("No solution for scenario 2.");
            else
                bfMatrix = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario2.csv"));

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

            if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario3.csv"),'file') ~= 2)
                score = 0;
                disp("No solution for scenario 3.");
            else
                bfMatrix = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario3.csv"));

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

            if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario4.csv"),'file') ~= 2)
                score = 0;
                disp("No solution for scenario 4.");
            else
                bfMatrix = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario4.csv"));

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

        if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/elements2.csv"),'file') ~= 2)
            teamScore = [teamScore 0];
            disp("No beamformer implemented for task 2.");
        else

            elements = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/elements2.csv"));

            % Scenario 5
            fprintf('===========================\nTASK 2, SCENARIO 5\n===========================\n');

            targetAz = 45;
            targetEl = 60;

            if (exist(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario5.csv"),'file') ~= 2)
                score = 0;
                disp("No solution for scenario 5.");
            else
                bfMatrix = csvread(strcat(gdrive,teamName,"/Beamforming/beamformer/scenario5.csv"));

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
        copyfile("log.txt",strcat(gdrive,teamName,"/Beamforming/simulation/log.txt"),'f');

        % Format and write output file

        outputCsvString = strcat(teamName,";");
        for col = 1:length(teamScore)
            outputCsvString = sprintf('%s%2.4f;',outputCsvString,teamScore(col));
        end
        outputCsvString = outputCsvString(1:end-1);
        outputCsvString = sprintf('%s;%s',outputCsvString,teamTime);

        outputCsvFile = fopen(strcat(gdrive,"../Results/Beamforming/score_",teamName,".csv"),'w');
        fprintf(outputCsvFile,'%s',outputCsvString);
        fclose(outputCsvFile);

        pause(1)

    end

end