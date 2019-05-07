function done = unlockTask(readOnlyFolder)
    done = 0;
    
    files = dir(readOnlyFolder);
    for i=1:length(files)
        [~, ~, ext] = fileparts(files(i).name);
        if ext == ".lock"
            delete(string(files(i).folder) + string(files(i).name))
        end     
    end
end

