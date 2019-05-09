mSub = 50.1929;
mSpace = 1;
mEntrance = 1;
mFuel = 1;
mMotors = 1;
mBatteries = 1;
mTurbine = 1;



mLeftBalast = 5;
mRightBalast = 5;

% centers of mases
gSub = [0, 1, 0];
gSpace = [0, 1, 0];
gEntrance = [0, 1, 0];
gFuel = [0, 1, 0];
gMotors = [0, 1, 0];
gBatteries = [0, 1, 0];
gTurbine = [0, 1, 0];

buoyancyCenter = [0, 1, 0];


Rin = 1.5;
Rout = 1.7;
len = 15;
maxDepth = 100;

VTotal = Rout^2 * pi * len + 2 * 2/3 * Rout^3 * pi;
mTotal = mSub + mSpace + mEntrance + mFuel + mMotors + mBatteries + mTurbine + mLeftBalast + mRightBalast;

gTotal = (gSub * mSub + gSpace * mSpace + gEntrance * mEntrance + gFuel * mFuel + ...
          gMotors * mMotors + gBatteries + mBatteries + gTurbine + mTurbine) / mTotal;

Fy = 9.81 * (mTotal - 1000*VTotal);

if abs(gTotal(1) - buoyancyCenter(1)) < 2 && abs(gTotal(3) - buoyancyCenter(3)) < 2 && abs(Fy) < 2
    disp("jebeno");
    
end


