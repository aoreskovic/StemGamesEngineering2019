This is the first task today. As it is writen in task description, your job is to find direct and inverse kinematics of a given crane.

Here are 2 folders: Ref (read-only folder) and Solution (where you submit you results). 

In Ref folder we gave you 2 files:

	direct.csv - contains all configuration points you need to reach.
		   - Every row is one configuration point
		   - q1 column - base rotation angle (degrees)
		   - q2 colimn - rotational hydraulic cylnder stroke (meters)
		   - q3 colimn - first translational hydraulic cylnder stroke (meters)
		   - q4 colimn - second translational hydraulic cylnder stroke (meters)
		   - q5 colimn - pulley rotation angle (degrees)

	inverse.csv - contains all points in space you need to reach.
   		    - Every row is one configuration point
		    - x column - x-coodinate of the bottom of load
		    - y column - y-coodinate of the bottom of load
		    - z column - z-coodinate of the bottom of load

Your task is to insert your files in Solution folder for evaluation.

1) For direct kinematics, create file with name direct.csv. In there you have to have the same number of rows as in Ref/direct.csv (for every example from Ref/direct.csv). 
First row has to be names of coordinates, and in every other you have to submit solutions for every example given in Ref/direct.csv, respectively. See Ref/inverse.csv as an example of correct submission format.

2) For inverse kinematics, create file with name inverse.csv. In there you have to have the same number of rows as in Ref/inverse.csv (for every example from Ref/inverse.csv). 
First row has to be names of generalized coordinates (q1..q5), and in every other you have to submit solutions for every example given in Ref/inverse.csv, respectively. See Ref/direct.csv as an example of correct submission format.



