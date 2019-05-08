clear all; % Obavezno ocistiti persistent varijable!!!
teamFolder = pwd + "\InputFiles";
signalsFolder = teamFolder + "\Identification\Signals\";
Ts = 0.05;

files = dir(signalsFolder);
kranFile = ".\kran\kran";

for i=1:length(files)  
        file = files(i);
        fileName = convertCharsToStrings(file.name);
        [path, name, ext] = fileparts(fileName);
        if ext == ".csv"
            signals = csvread(string(signalsFolder + fileName));
        end
end