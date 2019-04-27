clear all;

Ts = 0.05;
%refPointsVector = [0 0 0 0.5 0 0 1 0 0 1.65 0 0 -0.2 0 0 -2 0 0];
refPointsVector = [0 0 0 0.5 0 0 1 0 0];
loadPosition = [0 0 0];
loadVelocity = [1e-3 1e-3 1e-3];

numOfPoints = length(refPointsVector)/3;
if(numOfPoints ~= round(numOfPoints))
    assert(false,'Wrong argument dimesion: refPointsVector has to have 3*N elements!');
end
refPoints = reshape(refPointsVector,[3, numOfPoints])';
