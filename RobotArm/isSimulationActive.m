function simulate = IsSimulationActive(folder, file)
% Checks if file exists in folder
% folder = folder_path; file = (string)name

simulate = 1;
files = dir(folder);
if length(files) > 2   % . and .. are in dir
    for i=1:length(files)
        if files(i).name == file
            simulate = 0;
            return 
        end
    end
else
   simulate = 0;
end




