#include "c_code.h"


// t: time
// coord_num: index of a point you are currently targeting
// pos: measured positions of actuators
// vel: measured velocities of actuators
// load_pos: measured load position
// load_vel: measured load velocity
// top_pos: measured position of the top of the crane
// top_vel: measured velocity of the top of the crane
// returns: referent valve opening [m]
inline double trans1(double t, int coord_num, Measurement pos, Measurement vel, 
           Coords load_pos, Coords load_vel,
           Coords top_pos ,Coords top_vel)
{
    // buffer_trans1 is the global buffer used for this function.
    // Example: a = buffer_trans1[4] assigns 5th element of the list to variable a


    // We recommend you to hardcode all configuration points you have to go through 
    // (points you got in inverse kinematics).
    // Example:
    // double actuator_ref_one[5] = {0, 1, 2, 3, 4};
    // double actuator_ref_two[5] = {0, 1, 2, 3, 4};
    // double actuatorr_ref_three[5] = {0, 1, 2, 3, 4};
    // double actuator_ref_array[5] = {actuatorr_ref_three,
    //                                 actuator_ref_one,
    //                                 actuatorr_ref_three,
    //                                 actuator_ref_two,
    //                                 actuatorr_ref_three};

    double a = buffer_trans1[4] = 5;
    buffer_trans1[4]++;
    return a;
}