[targetD, ~, ~, ~] = evaluateTask1(elements,bfMatrix,targetAz);
[targetDuniform, ~, ~, ~] = evaluateTask1(elements,ones(1,length(elements)),targetAz);

fprintf('Depointing error: %2.04f deg\n', abs(maxAz-targetAz));

score = targetD - targetDuniform;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

fprintf('Score: %2.04f\n', score);
