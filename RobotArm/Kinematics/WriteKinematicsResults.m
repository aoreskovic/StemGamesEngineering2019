function resultStatus = WriteKinematicsResults(resultsFolder, direct, inverse, directCorrect, inverseCorrect)
% WRITE KINEMATICS RESULTS 
% The function writes kinemtaics evaluation results into results.txt file
% placed into solutionFolder. The function returns non-zero value if some
% error appeared.

resultsFile = fopen(resultsFolder + "result.txt",'a');

if(resultsFile ~= -1)
    fprintf(resultsFile,"Successfully loaded results.\n\n");
    
    if direct
        fprintf(resultsFile,"DIRECT KINEMATICS\n");

        directTestNum = length(directCorrect);
        for i=1:directTestNum
            fprintf(resultsFile,"    Example " + num2str(i) + ": ");
            if(directCorrect(i) == -1)
                fprintf(resultsFile,"Configuration not possible!\n");
            elseif(directCorrect(i) == 0)
                fprintf(resultsFile,"Failed! Try again!\n");
            elseif(directCorrect(i) == 1)
                fprintf(resultsFile,"Successful! Congratz!\n");
            end
        end
    end
    
    if inverse
        fprintf(resultsFile,"\nINVERSE KINEMATICS\n");

        inverseTestNum = length(inverseCorrect);
        for i=1:inverseTestNum
            fprintf(resultsFile,"    Example " + num2str(i) + ": ");
            if(inverseCorrect(i) == -1)
                fprintf(resultsFile,"Configuration not possible!\n");
            elseif(inverseCorrect(i) == 0)
                fprintf(resultsFile,"Failed! Try again!\n");
            elseif(inverseCorrect(i) == 1)
                fprintf(resultsFile,"Successful! Congratz!\n");
            end
        end   
    end
else
   assert(false, "Could not open result.txt file!");
end


fclose(resultsFile);
resultStatus = 0; % By default everything is OK
end

