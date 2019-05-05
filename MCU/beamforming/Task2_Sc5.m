close all;

[targetD, maxD, maxAz, maxEl] = evaluateTask2(elements, bfMatrix, targetAz, targetEl);

score = targetD;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

fprintf('Score: %2.04f\n', score);
