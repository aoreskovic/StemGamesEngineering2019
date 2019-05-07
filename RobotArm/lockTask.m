function fileID = lockTask(readOnlyFolder, lockName)
    fileID = fopen(readOnlyFolder + lockName + ".lock", 'a');
    fclose(fileID);
end

