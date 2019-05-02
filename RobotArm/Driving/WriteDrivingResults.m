function resultStatus = WriteDrivingResults(resultsFolder, activeTime, performanceCost, pointIndex, isFinished)
% WRITE DRIVING RESULTS 
% The function writes driving regulator evaluation results into results.txt file
% placed into resultsFolder. The function returns non-zero value if some
% error appeared.

resultsFile = fopen(resultsFolder + "result.txt",'a');

% Extract data
finishFlag = isFinished.signals.values(end);
timePassed = activeTime.signals.values(end);
numOfPoints = pointIndex.signals.values(end);
cost = performanceCost.signals.values(end);

if(resultsFile ~= -1)
        
    fprintf(resultsFile,"Successfully loaded results.\n\n");

    if(~finishFlag)
        if(numOfPoints == 1)
            fprintf(resultsFile,"Not a single point has been reached.\n\n");
        else
            fprintf(resultsFile,"Test is finished up to position " + num2str(numOfPoints-1) + ".\n\n");
        end
    else
        fprintf(resultsFile,"Test is fully finished.\n\n");
    end

    fprintf(resultsFile,"Test duration: " + num2str(timePassed) +"s\n");

    if(numOfPoints > 1)
        pointChangeIndex = find([0; diff(pointIndex.signals.values)]); % Find times when index changes

        if(~finishFlag)
            pointChangeTime = diff([0; pointIndex.time(pointChangeIndex)]);

            for i=1:numOfPoints-1
               fprintf(resultsFile,"Duration " + num2str(i-1) + " to " + num2str(i) + ": ");   
               fprintf(resultsFile,num2str(pointChangeTime(i)) + "s\n"); 
            end
        else
            pointChangeTime = diff([0; pointIndex.time(pointChangeIndex); timePassed]);

            for i=1:numOfPoints
               fprintf(resultsFile,"Duration " + num2str(i-1) + " to " + num2str(i) + ": ");   
               fprintf(resultsFile,num2str(pointChangeTime(i)) + "s\n"); 
            end
        end
        
        fprintf(resultsFile,"\nPerformance cost: " + num2str(cost));           
    end   
else
   assert(false, "Could not open result.txt file!");
end

fclose(resultsFile);
resultStatus = 0; % By default everything is OK
end

