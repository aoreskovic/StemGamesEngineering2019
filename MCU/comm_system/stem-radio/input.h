#ifndef _INPUT_H_
#define _INPUT_H_

#define SIGNAL_SIZE (sizeof(adc_data) / sizeof(short))


static int arr_cnt = 0;
static const int SAMPLES_PER_SYMBOL = 100;

static const short adc_data[] = {
#include "../signal.txt"
};

#endif