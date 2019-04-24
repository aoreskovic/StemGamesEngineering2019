#ifndef MYFN
#define MYFN

double buffer_t1[200];
double buffer_t2[200];
double buffer_rot[200];
double buffer_base[200];
double buffer_pulley[200];

typedef struct coords {
    double x;
    double y;
    double z;
} Coords;


double wrapper_rot(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
double wrapper_trans1(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);                   
double wrapper_trans2(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
double wrapper_base(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
double wrapper_pulley(double t, double ref, double pos, double vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
#endif
