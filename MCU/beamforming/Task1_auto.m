clear all;
close all;

err = linkError.instance();
err.flushErorrs();

outputScoreData = ["Team"; "Scenario 1"; "Scenario 2"; "Scenario 3"; "Scenario 4"]';

teamName = "test";

% load teams. for team in teams ...
% prepare files

teamScore = [];
elements = csvread('task1_elements.csv');

% Scenario 1
fprintf('TASK 1, SCENARIO 1\n===========================\n');

targetAz = 0;
bfMatrix = csvread('task1_scenario1.csv');

try
    Task1_Sc123;
catch
    score = 0;
end

teamScore = [teamScore score];

err.printErrors();
err.flushErorrs();

% Scenario 2
fprintf('TASK 1, SCENARIO 2\n===========================\n');

targetAz = 30;
bfMatrix = csvread('task1_scenario2.csv');

try
    Task1_Sc123;
catch
    score = 0;
end

teamScore = [teamScore score];

err.printErrors();
err.flushErorrs();

% Scenario 3
fprintf('TASK 1, SCENARIO 3\n===========================\n');

targetAz = 60;
bfMatrix = csvread('task1_scenario3.csv');

try
    Task1_Sc123;
catch
    score = 0;
end

teamScore = [teamScore score];

err.printErrors();
err.flushErorrs();

% Scenario 4
fprintf('TASK 1, SCENARIO 4\n===========================\n');

targetAz = 70;
bfMatrix = csvread('task1_scenario4.csv');

try
    Task1_Sc4;
catch
    score = 0;
end

teamScore = [teamScore score];

err.printErrors();
err.flushErorrs();

% Collect score

outputScoreData = [outputScoreData ; [teamName teamScore]];

% end for

% Format and write output file

outputCsvString = '';
for team = 1:size(outputScoreData,1)
    for scenario = 1:size(outputScoreData,2)
        outputCsvString = sprintf('%s%s,',outputCsvString,outputScoreData(team,scenario));
    end
    outputCsvString = outputCsvString(1:end-1);
    outputCsvString = sprintf('%s\n',outputCsvString);
end
outputCsvFile = fopen('scores.csv','w');
fprintf(outputCsvFile,'%s',outputCsvString);
fclose(outputCsvFile);

% Time when evaluation was done

time = clock;
timeFile = fopen('time.txt','w');
fprintf(timeFile,'%d-%02d-%02d %02d:%02d:%02.0d', time(1), time(2), time(3), time(4), time(5), round(time(6)));
fclose(timeFile);
