%% KINEMATICS

open_system("kinematics_crane.slx")

files = dir(solutionFolder);

numFilterPoints = 10;  % evaluate this many points from end
posEpsilon = 0.25;

direct = 0;
inverse = 0;
solutionDirectTable = 0;
solutionInverseTable = 0;

outputFileId = fopen(solutionFolder + "result.txt", 'w');

for i=1:length(files)  
    file = files(i);
    fileName = convertCharsToStrings(file.name);
    [path, name, ext] = fileparts(fileName);
    if name == "direct"
        if direct == 0
            direct = 1;
            
            try  % check for csv format (if all fields exist)
                solutionDirectTable = readtable(solutionFolder + fileName);
                dims = size(solutionDirectTable.Variables);
                for j=1:dims(1)
                   a = solutionDirectTable(j, :).x;
                   a = solutionDirectTable(j, :).y;
                   a = solutionDirectTable(j, :).z;                   
                end
            catch
            fprintf(outputFileId, "Wrong csv format for direct.");
            fclose(outputFileId);
            return
            end
            
        else % if more that 1 file for direct
            fprintf(outputFileId, "More than 1 file for direct.");
            fclose(outputFileId);
            return
        end
        
        
    elseif name == "inverse"    
        if inverse == 0
            inverse = 1;
            
            try % check for csv format (if all fields exist)
               solutionInverseTable = readtable(solutionFolder + fileName);
               dims = size(solutionInverseTable.Variables);
               for j=1:dims(1)
                  a = solutionInverseTable(j, :).q1;
                  a = solutionInverseTable(j, :).q2;
                  a = solutionInverseTable(j, :).q3;
                  a = solutionDirectTable(j, :).q4;
                   a = solutionDirectTable(j, :).q5;
               end
            
            catch
                fprintf(outputFileId, "Wrong csv format for inverse.");
                fclose(outputFileId);
                return
            end
            
        else % if more that 1 file for inverse
            fprintf(outputFileId, "More than 1 file for inverse.");
            fclose(outputFileId);
            return
        end
    end
end

fprintf(outputFileId, "All files loaded successfully!" + newline);

% check direct kinematics
if direct
       
    dims = size(solutionDirectTable.Variables);
<<<<<<< HEAD
    directCorrect = zeros(dims(1));
    refDirectTable = readtable(readOnlyFolder + "direct.csv");
=======
    directCorrect = zeros(dims(1),1);
    refDirectTable = readtable(refFolder + "direct.csv");
    assert(all((size(solutionDirectTable.Variables) == [dims(1), 3])), "Wrong csv format for direct.");
>>>>>>> 5dd398c3c52546c19faadee6414c7c32bdccb4d3
    
    for i=1:dims(1)
        status = setCraneInPosition(refDirectTable(i, :));
        refBase = [[0], [refDirectTable(i, :).q1]];
        refRot = [[0], [refDirectTable(i, :).q2]];
        refTrans1 = [[0], [refDirectTable(i, :).q3]];
        refTrans2 = [[0], [refDirectTable(i, :).q4]];
        refPulley = [[0], [refDirectTable(i, :).q5]];
        Tsim = 20;
        pause(1);
<<<<<<< HEAD
        sim('kinematics_crane.slx')
        
        pause(1);
        posMean = mean(loadPosition.signals.values(end-numFilterPoints+1:end, :), 1);
        velMean = mean(loadVelocity.signals.values(end-numFilterPoints+1:end, :), 1);
        
        try       
        positionOffset = norm([posMean(1)-solutionDirectTable(i, :).x, ...
                               posMean(2)-solutionDirectTable(i, :).y, ...
                               posMean(3)-solutionDirectTable(i, :).z]);
                   
        catch
            fprintf(outputFileId, "Direct kinematics cannot be done." + newline + ...
                                  "Check again for csv format and actiatior limits");
            fclose(outputFileId);
            return
        end
        
        if positionOffset < posEpsilon 
            directCorrect(i) = 1;
=======
        if(~status)
            sim('kinematics_crane.slx')

            pause(1);
            posMean = mean(loadPosition.signals.values(end-numFilterPoints+1:end, :), 1);
            velMean = mean(loadVelocity.signals.values(end-numFilterPoints+1:end, :), 1);

            positionOffset = norm([posMean(1)-solutionDirectTable(i, :).x, ...
                                   posMean(2)-solutionDirectTable(i, :).y, ...
                                   posMean(3)-solutionDirectTable(i, :).z]);

            if positionOffset < posEpsilon && norm(velMean) < velEpsilon
                directCorrect(i) = 1;
            end
        else
            directCorrect(i) = -1; % Constraint violation. Pulley angle not large enough.
>>>>>>> 5dd398c3c52546c19faadee6414c7c32bdccb4d3
        end
    end
    
    % print direct kinematics results
    fprintf(outputFileId, "Direct Kinematics: " + newline);
    for i=1:dims(1) 
        if directCorrect(i) == 1
            fprintf(outputFileId, "    Example " + num2str(i) + " successfull. Congratz!" + newline);
        else
            fprintf(outputFileId, "    Example " + num2str(i) + " failed. Try again!" + newline);
        end    
    end
 
end

fprintf(outputFileId, newline);

% check inverse kinematics
if inverse
    dims = size(solutionInverseTable.Variables);
<<<<<<< HEAD
    inverseCorrect = zeros(dims(1));
    refInverseTable = readtable(readOnlyFolder + "inverse.csv");
    
    try
=======
    inverseCorrect = zeros(dims(1),1);
    refInverseTable = readtable(refFolder + "inverse.csv");
    assert(all((size(solutionInverseTable.Variables) == [dims(1), 5])), "Wrong csv format for direct.");
>>>>>>> 5dd398c3c52546c19faadee6414c7c32bdccb4d3
    
    for i=1:dims(1)
        status = setCraneInPosition(solutionInverseTable(i, :));
        refBase = [[0], [solutionInverseTable(i, :).q1]];
        refRot = [[0], [solutionInverseTable(i, :).q2]];
        refTrans1 = [[0], [solutionInverseTable(i, :).q3]];
        refTrans2 = [[0], [solutionInverseTable(i, :).q4]];
        refPulley = [[0], [solutionInverseTable(i, :).q5]];
        Tsim = 20;
        if(~status)
            sim('kinematics_crane.slx')

<<<<<<< HEAD
        positionOffset = norm([posMean(1)-refInverseTable(i, :).x, ...
                               posMean(2)-refInverseTable(i, :).y, ...
                               posMean(3)-refInverseTable(i, :).z]);
                           
        if positionOffset < posEpsilon
            inverseCorrect(i) = 1;
        end
    end
    
    catch
        fprintf(outputFileId, "Inverse kinematics cannot be done." + newline + ...
                              "Check again for csv format and actiatior limits");
        fclose(outputFileId);
        return
    end
    
    % print inverse kinematics results
    fprintf(outputFileId, "Inverse Kinematics: " + newline);
    for i=1:dims(1) 
        if inverseCorrect(i) == 1
            fprintf(outputFileId, "    Example " + num2str(i) + " successfull. Congratz!" + newline);
        else
            fprintf(outputFileId, "    Example " + num2str(i) + " failed. Try again!" + newline);
        end    
    end
end



fclose(outputFileId);

copyfile(solutionFolder + "result.txt", readOnlyFolder);

return
=======
            pause(0.5);
            posMean = mean(loadPosition.signals.values(end-numFilterPoints+1:end, :), 1);
            velMean = mean(loadVelocity.signals.values(end-numFilterPoints+1:end, :), 1);

            positionOffset = norm([posMean(1)-refInverseTable(i, :).x, ...
                                   posMean(2)-refInverseTable(i, :).y, ...
                                   posMean(3)-refInverseTable(i, :).z]);

            if positionOffset < posEpsilon && norm(velMean) < velEpsilon
                inverseCorrect(i) = 1;
            end
        else
            inverseCorrect(i) = -1; % Constraint violation. Pulley angle not large enough.
        end   
    end
   
end

% Write results to file
loadStatus = 0; % All files successfully loaded. Ovo treba dodat negdje, mozda umjesto assert?
resultStatus = WriteKinematicsResults(solutionFolder, loadStatus, directCorrect, inverseCorrect);
>>>>>>> 5dd398c3c52546c19faadee6414c7c32bdccb4d3

