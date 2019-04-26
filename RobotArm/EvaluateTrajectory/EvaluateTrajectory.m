function output = EvaluateTrajectory(Ts, refPointsVector, loadPosition, loadVelocity)
% EVALUATE TRAJECTORY
% Functions takes referent and trajectory points and calculates control
% cost.

persistent pointIndex costArray waitTime reset

% Initialize parameters
epsPosition = 0.1;
epsVelocity = 0.01;
maxWaitTime = 1;
isFinished = 0;

% Reshape refPointsVector into matrix. This is purely because Simulink is
% unable to handle matrices as inputs. Input vector has to have 3*N
% elements, where N is number of points. 
% Vector refPointsVector has the structure [x1 y1 z1 x2 y2 z2 ... xN yN zN].
% Matrix refPoints has the structure
%   [[x1 y1 z1]
%    [x2 y2 z2]
%    ...
%    [xN yN zN]]
numOfPoints = length(refPointsVector)/3;
refPoints = reshape(refPointsVector,[3, numOfPoints])';

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
