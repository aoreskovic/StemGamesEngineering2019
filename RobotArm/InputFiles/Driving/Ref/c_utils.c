#include "c_code.h"
#include "rot.c"
#include "trans1.c"
#include "trans2.c"
#include "base.c"
#include "pulley.c"

double wrapper_rot(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return rot(t, coord_num, *pos, *vel, *load_pos, *load_vel, *top_pos, *top_vel);
}


double wrapper_trans1(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return trans1(t, coord_num, *pos, *vel, *load_pos, *load_vel, *top_pos, *top_vel);
}

double wrapper_trans2(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return trans2(t, coord_num, *pos, *vel, *load_pos, *load_vel, *top_pos, *top_vel);
}

double wrapper_base(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return base(t, coord_num, *pos, *vel, *load_pos, *load_vel, *top_pos, *top_vel);
}

double wrapper_pulley(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return pulley(t, coord_num, *pos, *vel, *load_pos, *load_vel, *top_pos, *top_vel);
}