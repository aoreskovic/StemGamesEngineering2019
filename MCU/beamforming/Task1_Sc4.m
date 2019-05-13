close all;

disp("Evaluating with given beamforming weights ...");
[targetD, ~, ~, ~] = evaluateTask1(elements,bfMatrix,targetAz,false);
disp("Evaluating with uniform excitation ...");
[targetDuniform, ~, ~, ~] = evaluateTask1(elements,ones(1,length(elements)),targetAz,false);

fprintf('Depointing error: %2.04f deg\n', abs(maxAz-targetAz));

score = targetD - targetDuniform;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

score = score * 2;
if score > 25
    score = 25;
end

if score < 0 
    score = 0;
end

fprintf('Score: %2.04f\n', score);
