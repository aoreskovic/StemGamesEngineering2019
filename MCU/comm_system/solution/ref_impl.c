#include <math.h>
#include <stdlib.h>

#include "api.h"

#define REAL 0
#define IMAG 1

static double evm(complex symbol, complex ref) {
	double real_diff = pow(symbol[REAL] - ref[REAL], 2);
	double imag_diff = pow(symbol[IMAG] - ref[IMAG], 2);

	return sqrt(real_diff + imag_diff);
}

static char gray_map[] = {0, 2, 3, 1};

complex *frequency_shift(double *input, double fc, double fs, int N) {

	complex *output = (complex *) malloc(N * sizeof(complex));

	for (int i = 0; i < N; i++) {
		output[i][REAL] *= cos((2 * M_PI * fc * i * 1.0) / fs);
		output[i][IMAG] *= sin((2 * M_PI * fc * i * 1.0) / fs);
	}

	return output;
}

double qpsk_demodulator(complex symbol, double constellation_offset, char 
	*decoded_symbol) {

	complex ref_point[4];

	for (int i = 0; i < 4; i++) {
		ref_point[i][REAL] = cos(constellation_offset + i * M_PI / 2);
		ref_point[i][IMAG] = sin(constellation_offset + i * M_PI / 2);
	}

	double min_offset = evm(symbol, ref_point[0]);
	int min_index = 0;

	for (int i = 1; i < 4; i++) {
		double tmp = evm(symbol, ref_point[i]);
		if (tmp < min_offset) {
			min_offset = tmp;
			min_index = i;
		}
	}

	*decoded_symbol = gray_map[min_index];

	return min_offset;
}

void frame_sync(char **bitstream) {

}

void frame_step(char **bitstream, int frame_size) {
	
}


char *frame_decoder(char **bitstream, int frame_length) {
	return NULL;
}


complex *channel_correction(complex *input, int first_carrier, int ofdm_size, 
	char *pilot_map) {


	return NULL;
}