%% IDENTIFICATION
files = dir(identifyFolder + "Input");
kranFile = "../kran/kran";


open_system(kranFile + ".slx");
set_param("kran/isIdentification", 'value', "1");

outputFileId = fopen(identifyFolder + "Input/" + "result.txt", "w");
try

    for i=1:length(files)  
        file = files(i);
        fileName = convertCharsToStrings(file.name);
        [path, name, ext] = fileparts(fileName);
        if ext == ".csv"
            signals = csvread(identifyFolder + "Input/" + fileName);
            dims = size(signals);
            if dims(2) ~= 6
                throw(exception)
            end   
        end
    end
    
catch
    fprintf(outputFileId, "Error loading fils!" + newline + ...
            "Check again for dimensions and csv format! Input has to have 6 columns: " ...
            + newline + "    time, baseVoltage, rotValve," + ...
            " transValve1, transValve2 and pulleyVoltage respectively!!");
    fclose(outputFileId);
    return
end

fprintf(outputFileId, "All files loaded successfully!" + newline);

identTime = signals(:, 1);
base = signals(:, 2);
rot = signals(:, 3);
trans1 = signals(:, 4);
trans2 = signals(:, 5);
pulley = signals(:, 6);

%baseVoltage = [identTime, [base]];
%rotValve = [identTime, [rot]];
%transValve1 = [identTime, [trans1]];
%transValve2 = [identTime, [trans2]];
%pulleyVoltage = [identTime, [pulley]];

Tsim = identTime(end);
sim(kranFile + ".slx")

close_system("kran.slx");

copyfile(identifyFolder + "Input/" + "result.txt", identifyFolder + "Output/");
fclose(outputFileId);
return




    