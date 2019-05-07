This is the third and last task today. As it is writen in task description, your job is to write controllers for driving a crane!

Here are 2 folders: Ref (read-only folder) and Regulators (editable folder).

In Ref there are our C utils files you can see but not edit (used for C files, if you want to use it). Also, there is ref.csv containing all points you have to reach with your crane.

You can choose to write your controllers as matlab functions (.m) or C, C++ files (.c). Examples and prototypes of functions can be found in Ref/Examples folder. 

base, pulley, rot, trans1, trans2 are controllers for base rotation DC motor, pulley rotation DC motor, rotational hydraulic cylinder, first translational hydraulic cylinder and second translational hydraulic cylinder, respectively. 

IMPORTANT: You have to use the same names as listed in Examples folder!

Function is called with sample time given in the task description.

NOTE: We recommend you to design regulators based on your identified model for best results. If you are lucky, you can do this without identification, though we would not recommend it.
