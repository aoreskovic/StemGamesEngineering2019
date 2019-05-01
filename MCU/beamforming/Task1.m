%% Scenario 1
clear all;
close all;

err = linkError.instance();

fprintf('TASK 1, SCENARIO 1\n===========================\n');
targetAz = 0;
elements = csvread('task1_elements.csv');
bfMatrix = csvread('task1_scenario1.csv');
[targetD, maxD, maxAz] = evaluateTask1(elements,bfMatrix,targetAz);

scoreMainLobe = maxD;
scoreFirstSideLobe = 2*targetD - maxD - abs(maxAz-targetAz)/10;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

fprintf('Main lobe score: %2.04f\n', scoreMainLobe);
fprintf('First side lobe score. %2.04f\n', scoreFirstSideLobe);
fprintf('Verify lobe validity!\n');

err.printErrors();
err.flushErorrs();

pause;

%% Scenario 2
clear all;
close all;

err = linkError.instance();

fprintf('TASK 1, SCENARIO 2\n===========================\n');
targetAz = 30;
elements = csvread('task1_elements.csv');
bfMatrix = csvread('task1_scenario2.csv');
[targetD, maxD, maxAz] = evaluateTask1(elements,bfMatrix,targetAz);

scoreMainLobe = maxD;
scoreFirstSideLobe = 2*targetD - maxD - abs(maxAz-targetAz)/10;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

fprintf('Main lobe score: %2.04f\n', scoreMainLobe);
fprintf('First side lobe score. %2.04f\n', scoreFirstSideLobe);
fprintf('Verify lobe validity!\n');

err.printErrors();
err.flushErorrs();

pause;

%% Scenario 3
clear all;
close all;

err = linkError.instance();

fprintf('TASK 1, SCENARIO 3\n===========================\n');
targetAz = 60;
elements = csvread('task1_elements.csv');
bfMatrix = csvread('task1_scenario3.csv');
[targetD, maxD, maxAz] = evaluateTask1(elements,bfMatrix,targetAz);

scoreMainLobe = maxD;
scoreFirstSideLobe = targetD - abs(maxAz-targetAz)/10;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

fprintf('Main lobe score: %2.04f\n', scoreMainLobe);
fprintf('First side lobe score. %2.04f\n', scoreFirstSideLobe);
fprintf('Verify lobe validity!\n');

err.printErrors();
err.flushErorrs();

pause;

%% Scenario 4
clear all;
close all;

err = linkError.instance();

fprintf('TASK 1, SCENARIO 4\n===========================\n');
targetAz = 70;
elements = csvread('task1_elements.csv');
bfMatrix = csvread('task1_scenario4.csv');
[targetD, ~, ~] = evaluateTask1(elements,bfMatrix,targetAz);
[targetDuniform, ~, ~] = evaluateTask1(elements,ones(1,length(elements)),targetAz);

score = targetD - targetDuniform;

if targetD < 0
    err.invokeError('negativeDirectivity');
end

fprintf('Score: %2.04f\n', score);

err.printErrors();
err.flushErorrs();

pause;

