function output = EvaluateTrajectory(Ts, refPoints, loadPosition, loadVelocity)
% EVALUATE TRAJECTORY
% Functions takes referent and trajectory points and calculates control
% cost.

persistent pointIndex costArray waitTime reset

% Initialize parameters
epsPosition = 0.1;
epsVelocity = 0.01;
maxWaitTime = 1;
numOfPoints = size(refPoints,1);
isFinished = 0;

% Initialize point number and cost value
if(isempty(pointIndex))
    pointIndex = 0;
    costArray = 1e5*ones(numOfPoints,1);
    waitTime = 0;
    reset = 1;
end

% Detect change of point index
if(reset)
    if(pointIndex == numOfPoints)
       isFinished = 1;
    else
       pointIndex = pointIndex + 1;
       costArray(pointIndex) = 0;
       isFinished = 0;
    end    
    reset = 0;
end

% Calculate distance and velocity norms
currentPoint = refPoints(pointIndex,:);
distanceNorm = norm(loadPosition - currentPoint);
velocityNorm = norm(loadVelocity);

% Update cost
costArray(pointIndex) = costArray(pointIndex) + distanceNorm;

% Measure time when load is inside some "ball" around the point and its
% velocity is small enough. When outside this boundaries, reset wait time.
% If maxWaitTime has passed, move on to another point.
if(distanceNorm <= epsPosition && velocityNorm <= epsVelocity)
    waitTime = waitTime + Ts;
    if(waitTime >= maxWaitTime)
        reset = 1;
    end  
else
    waitTime = 0;
end

% Output variables
output = [costArray; pointIndex; isFinished];

end
