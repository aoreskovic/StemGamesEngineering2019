function y = trans1(t, coordNum, pos, vel, load_pos, load_vel, top_pos, top_vel)
% t: time
% coordNum: index of a point you are currently targeting
% pos: measured positions of actuators
% vel: measured velocities of actuators
% load_pos: measured load position
% load_vel: measured load velocity
% top_pos: measured position of the top of the crane
% top_vel: measured velocity of the top of the crane
% y: referent valve opening [m]


% bufferTrans1 is the global buffer used for this function.
% Example: a = bufferTrans1[4] assigns 4th element of the list to variable a


% We recommend you to hardcode all configuration points you have to go through 
% (points you got in inverse kinematics).
% Example:
% actuatorRefOne = [1, 2, 3, 4, 5];
% actuatorRefTwo = [1, 2, 3, 4, 5];
% actuatorRefThree = [1, 2, 3, 4, 5];
% actuatorRefVector = [actuatorRefThree; 
% 		       actuatorRefOne; 
% 		       actuatorRefThree; 
% 		       actuatorRefTwo; 
% 		       actuatorRefThree];
	y = 0;
end
