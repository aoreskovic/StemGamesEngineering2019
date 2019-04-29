function done = setFunction(simulinkPath, code, sampleTime)
    rt = sfroot;
    methodHandles = rt.find('-isa','Stateflow.EMChart');
    for i=1:length(methodHandles)
        if string(methodHandles(i).path) == simulinkPath
           methodHandles(i).Script = code;
        end          
    end 
    set_param(simulinkPath, 'SystemSampleTime', num2str(sampleTime))
    done=1;
end

