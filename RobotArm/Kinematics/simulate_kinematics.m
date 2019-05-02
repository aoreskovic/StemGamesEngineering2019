%% KINEMATICS

open_system("kinematics_crane.slx")

files = dir(solutionFolder);

numFilterPoints = 10;  % evaluate this many points from end
posEpsilon = 0.1;

direct = 0;
inverse = 0;
solutionDirectTable = 0;
solutionInverseTable = 0;

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
                outputFileId = fopen(solutionFolder + "result.txt", 'w');
                fprintf(outputFileId, "Wrong csv format for direct.");
                fclose(outputFileId);
            return
            end
            
        else % if more that 1 file for direct
            outputFileId = fopen(solutionFolder + "result.txt", 'w');
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
                  a = solutionInverseTable(j, :).q4;
                   a = solutionInverseTable(j, :).q5;
               end
            
            catch
                outputFileId = fopen(solutionFolder + "result.txt", 'w');
                fprintf(outputFileId, "Wrong csv format for inverse.");
                fclose(outputFileId);
                return
            end
            
        else % if more that 1 file for inverse
            outputFileId = fopen(solutionFolder + "result.txt", 'w');
            fprintf(outputFileId, "More than 1 file for inverse.");
            fclose(outputFileId);
            return
        end
    end
end

directCorrect = zeros(dims(1),1);
% check direct kinematics
if direct
       
    dims = size(solutionDirectTable.Variables);
    refDirectTable = readtable(readOnlyFolder + "direct.csv");
    
    for i=1:dims(1)
        status = setCraneInPosition(refDirectTable(i, :));
        refBase = [[0], [refDirectTable(i, :).q1]];
        refRot = [[0], [refDirectTable(i, :).q2]];
        refTrans1 = [[0], [refDirectTable(i, :).q3]];
        refTrans2 = [[0], [refDirectTable(i, :).q4]];
        refPulley = [[0], [refDirectTable(i, :).q5]];
        Tsim = 20;
        
        
        if(~status)
            pause(1);
            sim('kinematics_crane.slx')
            pause(1);
            posMean = mean(loadPosition.signals.values(end-numFilterPoints+1:end, :), 1);
            velMean = mean(loadVelocity.signals.values(end-numFilterPoints+1:end, :), 1);

            positionOffset = norm([posMean(1)-solutionDirectTable(i, :).x, ...
                                   posMean(2)-solutionDirectTable(i, :).y, ...
                                   posMean(3)-solutionDirectTable(i, :).z]);

            if positionOffset < posEpsilon
                directCorrect(i) = 1;
            end
        else
            directCorrect(i) = -1; % Constraint violation. Pulley angle not large enough.
        end
    end 
end

inverseCorrect = zeros(dims(1),1);
% check inverse kinematics
if inverse
    dims = size(solutionInverseTable.Variables);
    refInverseTable = readtable(readOnlyFolder + "inverse.csv");
    
    try
        for i=1:dims(1)
            status = setCraneInPosition(solutionInverseTable(i, :));
            refBase = [[0], [solutionInverseTable(i, :).q1]];
            refRot = [[0], [solutionInverseTable(i, :).q2]];
            refTrans1 = [[0], [solutionInverseTable(i, :).q3]];
            refTrans2 = [[0], [solutionInverseTable(i, :).q4]];
            refPulley = [[0], [solutionInverseTable(i, :).q5]];
            Tsim = 20;
            if(~status)
                pause(1);
                sim('kinematics_crane.slx')
                pause(1);
                posMean = mean(loadPosition.signals.values(end-numFilterPoints+1:end, :), 1);
                velMean = mean(loadVelocity.signals.values(end-numFilterPoints+1:end, :), 1);

                positionOffset = norm([posMean(1)-refInverseTable(i, :).x, ...
                                       posMean(2)-refInverseTable(i, :).y, ...
                                       posMean(3)-refInverseTable(i, :).z]);

                if positionOffset < posEpsilon
                    inverseCorrect(i) = 1;
                end
            else
                inverseCorrect(i) = -1; % Constraint violation. Pulley angle not large enough.
            end   
        end
    catch
        
    end
end

% Write results to file
resultStatus = WriteKinematicsResults(solutionFolder, direct, inverse, directCorrect, inverseCorrect);
if ~resultStatus
    copyfile(solutionFolder + "result.txt", readOnlyFolder);
end
