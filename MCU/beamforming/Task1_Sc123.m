close all;

[targetD, maxD, maxAz, lobesValid] = evaluateTask1(elements,bfMatrix,targetAz,true);

fprintf('Depointing error: %2.04f deg\n', abs(maxAz-targetAz));

if lobesValid(1)
    score = targetD - abs(maxAz-targetAz);
elseif lobesValid(2)
    score = targetD - abs(maxAz-targetAz)/10;
else
    err.invokeError('lobes');
end

if targetD < 0
    err.invokeError('negativeDirectivity');
end

if score < 0
    score = 0;
end

fprintf('Score: %2.04f\n', score);

