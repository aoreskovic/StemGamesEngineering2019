function output = EvaluateTrajectory(Ts, refPointsVector, loadPosition)
% EVALUATE TRAJECTORY
% Functions takes referent and trajectory points and calculates control
% cost.

persistent pointIndex costArray waitTime reset isFinished time

% Initialize parameters
epsPosition = 0.25;
maxWaitTime = 5;

% Check whether vector sizes are correct
numOfPoints = length(refPointsVector)/3;
if(numOfPoints ~= round(numOfPoints))
    assert(false,'Wrong argument dimesion: refPointsVector has to have 3*N elements!');
end
% Reshape refPointsVector into matrix. This is purely because Simulink is
% unable to handle matrices as inputs. Input vector has to have 3*N
% elements, where N is number of points. 
% Vector refPointsVector has the structure [x1 y1 z1 x2 y2 z2 ... xN yN zN].
% Matrix refPoints has the structure
%   [[x1 y1 z1]
%    [x2 y2 z2]
%    ...
%    [xN yN zN]]
refPoints = reshape(refPointsVector,[3, numOfPoints])';

% Make sure loadPosition is vector row of size [1, 3]
loadPosition = reshape(loadPosition, [1, 3]);

% Initialize point number and cost value
if(isempty(pointIndex))
    pointIndex = 0;
    costArray = 1e4*ones(numOfPoints,1);
    waitTime = 0;
    reset = 1;
    isFinished = 0;
    time = -Ts;
end

% Detect change of point index
if(reset)
    if(pointIndex == numOfPoints)
       isFinished = 1;
    else
       pointIndex = pointIndex + 1;
       costArray(pointIndex) = 0;
    end    
    reset = 0;
end

if(~isFinished)
    % Calculate distance and velocity norms
    currentPoint = refPoints(pointIndex,:);
    distanceNorm = norm(loadPosition - currentPoint);

    % Update cost
    costArray(pointIndex) = costArray(pointIndex) + distanceNorm;

    % Measure time when load is inside some "ball" around the point.
    % When outside this boundaries, reset wait time.
    % If maxWaitTime has passed, move on to another point.
    if(distanceNorm <= epsPosition)
        if(waitTime >= maxWaitTime)
            reset = 1;
        end  
        waitTime = waitTime + Ts;
    else
        waitTime = 0;
    end
    time = time + Ts;
end

% Output variables
output = [costArray; pointIndex; isFinished; time];

end
