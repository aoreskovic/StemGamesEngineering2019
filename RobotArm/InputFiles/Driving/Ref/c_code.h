#ifndef MYFN
#define MYFN

double buffer_trans1[200];
double buffer_trans2[200];
double buffer_rot[200];
double buffer_base[200];
double buffer_pulley[200];

typedef struct coords {
    double x;
    double y;
    double z;
} Coords;

typedef struct mesasurement {
    double rot;
    double trans1;
    double trans2;
    double base;
    double pulley;
} Measurement;


double wrapper_rot(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
double wrapper_trans1(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);                   
double wrapper_trans2(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
double wrapper_base(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
double wrapper_pulley(double t, int coord_num, Measurement* pos, Measurement* vel, 
                   Coords* load_pos, Coords* load_vel,
                   Coords* top_pos ,Coords* top_vel);
#endif
