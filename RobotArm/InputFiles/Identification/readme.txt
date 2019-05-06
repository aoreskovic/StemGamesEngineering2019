This is the second task today. As it is writen in task description, your job is to identify models of actuators of given crane. You have 2 DC motors and 3 translational hydraulic actuators.

Here are 3 folders: Your identification will be performed in Identify folder and our testing of your identification will use Ref and Solution folders.


1) Identification simulation

In Identify folder you have 2 folders: Input and Output. Output is read-only while Input is editable. 

In Input folder you submit only one file named "signals.csv". It has 6 columns: 1st column is for time. 2nd to 6th columns are references for actuators. They are base rotation DC motor, rotational hydraulic cylinder, first translational hydraulic cylinder, second translational hydraulic cylinder and pulley rotation DC motor, respectively. Motors' and hydraulic cylender references are descibed in task's description. See Output/signals_example.csv as an example.

IMPORTANT: You have to use discretization time described in the task. Time has to be continuous!


After your inputs are simulated, there will be 1 file created in Output folder, named "signals.csv" which contain time as first column and responses of base rotation DC motor, rotational hydraulic cylinder, first translational hydraulic cylinder, second translational hydraulic cylinder and pulley rotation DC motor, respectively, at 2nd to 6th column. Response for DC motors is angular velocity [rad/s] and for hydraulic cylinders is velocity [m/s].

NOTE: you can use matlab's function csvwrite('signals.csv', M); to write matlab matrix M to .csv file.


2) Test identification

Ref (read-only folder) and Solution (editable folder) are used for testing your identification.

We provide you with random generated reference signals for all actuators called "input_signals#.csv" (# is number of test case) in Ref folder. You have to perform correct identification of all actuators given this test reference signals. Also, we provide you a start crane configuration as points in configuration space (same as direct kinematics) in file "start_position#.csv". Format is the same as inputs in Identify/Input folder described above. Your solution has to have the same format as outputs in Identify/Output folder as described above (for every actuator, you write it's own file with time and velocities as columns). Name your files signals#.csv, where # is the number of test case.

Score is calculated as mean square error of whole trajectory per test case. The lower score is, the better.


IMPORTANT: Every time you send new identification signals in Identify/Input folder, new random reference will be set to Ref folder, so there won't be cheeting!! 
