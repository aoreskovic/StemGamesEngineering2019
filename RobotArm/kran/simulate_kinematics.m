%% KINEMATICS

files = dir(solutionFolder);

numFilterPoints = 10;  % evaluate this many points from end
posEpsilon = 0.1;
velEpsilon = 0.01;

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
            solutionDirectTable = readtable(solutionFolder + fileName);
        else
            assert(false, "More than 1 file for direct.")
        end
    elseif name == "inverse"
        if inverse == 0
            inverse = 1;
            solutionInverseTable = readtable(solutionFolder + fileName);
        else
            assert(false, "More than 1 file for inverse.")
        end
    end
end



if direct
    dims = size(solutionDirectTable.Variables);
    directCorrect = zeros(dims(1));
    refDirectTable = readtable(refFolder + "direct.csv");
    assert(all((size(solutionDirectTable.Variables) == [dims(1), 3])), "Wrong csv format for direct.");
    
    for i=1:dims(1)
        setCraneInPosition(refDirectTable(i, :));
        refBase = [[0], [refDirectTable(i, :).q1]];
        refRot = [[0], [refDirectTable(i, :).q2]];
        refTrans1 = [[0], [refDirectTable(i, :).q3]];
        refTrans2 = [[0], [refDirectTable(i, :).q4]];
        refPulley = [[0], [refDirectTable(i, :).q5]];
        Tsim = 20;
        pause(1);
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
    end
 
end

if inverse
    dims = size(solutionInverseTable.Variables);
    inverseCorrect = zeros(dims(1));
    refInverseTable = readtable(refFolder + "inverse.csv");
    assert(all((size(solutionInverseTable.Variables) == [dims(1), 5])), "Wrong csv format for direct.");
    
    for i=1:dims(1)
        setCraneInPosition(solutionInverseTable(i, :));
        refBase = [[0], [solutionInverseTable(i, :).q1]];
        refRot = [[0], [solutionInverseTable(i, :).q2]];
        refTrans1 = [[0], [solutionInverseTable(i, :).q3]];
        refTrans2 = [[0], [solutionInverseTable(i, :).q4]];
        refPulley = [[0], [solutionInverseTable(i, :).q5]];
        Tsim = 20;
        sim('kinematics_crane.slx')
        
        pause(0.5);
        posMean = mean(loadPosition.signals.values(end-numFilterPoints+1:end, :), 1);
        velMean = mean(loadVelocity.signals.values(end-numFilterPoints+1:end, :), 1);

        positionOffset = norm([posMean(1)-refInverseTable(i, :).x, ...
                               posMean(2)-refInverseTable(i, :).y, ...
                               posMean(3)-refInverseTable(i, :).z]);
                           
        if positionOffset < posEpsilon && norm(velMean) < velEpsilon
            inverseCorrect(i) = 1;
        end
    end

end

