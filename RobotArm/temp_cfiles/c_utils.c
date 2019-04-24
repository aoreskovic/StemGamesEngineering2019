#include "c_code.h"
#include "rot.c"
#include "trans1.c"
#include "trans2.c"
#include "base.c"
#include "pulley.c"

double wrapper_rot(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return rot(t, ref, pos, vel, *load_pos, *load_vel, *top_pos, *top_vel);
}


double wrapper_trans1(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return trans1(t, ref, pos, vel, *load_pos, *load_vel, *top_pos, *top_vel);
}

double wrapper_trans2(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return trans2(t, ref, pos, vel, *load_pos, *load_vel, *top_pos, *top_vel);
}

double wrapper_base(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return base(t, ref, pos, vel, *load_pos, *load_vel, *top_pos, *top_vel);
}

double wrapper_pulley(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel)
{
    return pulley(t, ref, pos, vel, *load_pos, *load_vel, *top_pos, *top_vel);
}