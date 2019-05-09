function status = ReadMotorParameters(solutionFolder)
%READ MOTOR PARAMETERS

status = 0;
fileExists = 0;
alreadyEvaluated = 0;
files = dir(solutionFolder);

for i=1:length(files) 
    file = files(i);
    fileName = convertCharsToStrings(file.name);
    [path, name, ext] = fileparts(fileName);
    
    if name == "evaluation"
        alreadyEvaluated = 1;
    end
    
    if (name == "machine_parameters" && ~alreadyEvaluated)
        fileExists = 1;
        try  % check for csv format (if all fields exist)
            solutionTable = readtable(solutionFolder + fileName);
            dims = size(solutionTable);
            outputFileId = fopen(solutionFolder + "evaluation.txt", 'w');
            
            if(dims(2) ~= 6)
                fprintf(outputFileId, "Wrong number of parameters.");
                fclose(outputFileId);
                return
            else
               points = 18;
               pointStep = 3;
               fprintf(outputFileId, "MACHINE PARAMETERS EVALUATION\n\n");
               
               fprintf(outputFileId, "Ds: ");
               if(solutionTable.Ds - 0.3056 > 0.05)
                   fprintf(outputFileId, "Incorrect\n");
                   points = points - pointStep;
               else
                   fprintf(outputFileId, "Correct\n");
               end
               
               fprintf(outputFileId, "Dr: ");
               if(solutionTable.Dr - 0.2966 > 0.05)
                   fprintf(outputFileId, "Incorrect\n");
                   points = points - pointStep;
               else
                   fprintf(outputFileId, "Correct\n");
               end
               
               fprintf(outputFileId, "delta: ");
               if(solutionTable.delta - 0.003 > 0.05)
                   fprintf(outputFileId, "Incorrect\n");
                   points = points - pointStep;
               else
                   fprintf(outputFileId, "Correct\n");
               end
               
               fprintf(outputFileId, "z: ");
               if(solutionTable.z ~= 2)
                   fprintf(outputFileId, "Incorrect\n");
                   points = points - pointStep;
               else
                   fprintf(outputFileId, "Correct\n");
               end
               
               fprintf(outputFileId, "Nf: ");
               if(solutionTable.Nf ~= 136)
                   fprintf(outputFileId, "Incorrect\n");
                   points = points - pointStep;
               else
                   fprintf(outputFileId, "Correct\n");
               end
               
               fprintf(outputFileId, "Xd: ");
               if(solutionTable.Xd - 1.5618 > 0.05)
                   fprintf(outputFileId, "Incorrect\n");
                   points = points - pointStep;
               else
                   fprintf(outputFileId, "Correct\n");
               end
               
               fprintf(outputFileId, "\nTotal number of points: " + num2str(points) + "/18");
               fclose(outputFileId);
            end
        catch
            outputFileId = fopen(solutionFolder + "evaluation.txt", 'w');
            fprintf(outputFileId, "Wrong csv format. Please check for unnoticed line breaks or spaces.");
            fprintf(outputFileId, "\nAdditionally, make sure that the parameters in table are as follows: ");
            fprintf(outputFileId, " Ds, Dr, delta, z, Nf, Xd.");
            fclose(outputFileId);
        return
        end
    end
end

if(~fileExists && ~alreadyEvaluated)
    outputFileId = fopen(solutionFolder + "evaluation.txt", 'w');
    fprintf(outputFileId, "File name is not correct. Please name it machine_parameters.csv.");
    fclose(outputFileId);
end

end

