function simulate = isSimulationActive(solutionFolder, readOnlyFolder, fileName)
% Checks if file exists in folder
% folder = folder_path; file = (string)name

simulate = 1;

files = dir(solutionFolder);
if length(files) > 2   % . and .. are in dir
    for i=1:length(files)
        [~, ~, ext] = fileparts(files(i).name);
        if files(i).name == fileName
            simulate = 0;
            return 
        end
    end
else
   simulate = 0;
end

files = dir(readOnlyFolder);
for i=1:length(files)
    [~, ~, ext] = fileparts(files(i).name);
    if ext == ".lock"
        simulate = 0;
        return 
    end
end





