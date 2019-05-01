function resultStatus = WriteKinematicsResults(resultsFolder, loadStatus, directCorrect, inverseCorrect)
% WRITE KINEMATICS RESULTS 
% The function writes kinemtaics evaluation results into results.txt file
% placed into solutionFolder. The function returns non-zero value if some
% error appeared.

resultsFile = fopen(resultsFolder + "results.txt",'w+');

if(resultsFile ~= -1)
    
    if(loadStatus)
        fprintf(resultsFile,"Results loading failed.");
    else             
        fprintf(resultsFile,"Successfully loaded results.\n\n");
        fprintf(resultsFile,"DIRECT KINEMATICS\n");
        
        directTestNum = length(directCorrect);
        for i=1:directTestNum
            fprintf(resultsFile,"Example " + num2str(i) + ": ");
            if(directCorrect(i) == -1)
                fprintf(resultsFile,"Belt not long enough\n");
            elseif(directCorrect(i) == 0)
                fprintf(resultsFile,"Failed\n");
            elseif(directCorrect(i) == 1)
                fprintf(resultsFile,"Successful\n");
            end
        end
        
        fprintf(resultsFile,"\nINVERSE KINEMATICS\n");
        
        inverseTestNum = length(inverseCorrect);
        for i=1:inverseTestNum
            fprintf(resultsFile,"Example " + num2str(i) + ": ");
            if(inverseCorrect(i) == -1)
                fprintf(resultsFile,"Belt not long enough\n");
            elseif(inverseCorrect(i) == 0)
                fprintf(resultsFile,"Failed\n");
            elseif(inverseCorrect(i) == 1)
                fprintf(resultsFile,"Successful\n");
            end
        end
    end   
else
   assert(false, "Could not open result.txt file!");
end

fclose(resultsFile);
resultStatus = 0; % By default everything is OK
end

