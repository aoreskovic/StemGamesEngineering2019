#include <math.h>

#include "api.h"

#define REAL 0
#define IMAG 1

void dft(complex *input, complex *output, int N) {
	for (int i = 0; i < N; i++) {
		output[i][REAL] = 0;
		output[i][IMAG] = 0;
	}

	for (int k = 0; k < N; k++) {
		for (int i = 0; i < N; i++) {
			output[k][REAL] += input[i][REAL] * cos(2 * (M_PI * k * i) / N)
			+ input[i][IMAG] * sin(2 * (M_PI * k * i) / N);
			output[k][IMAG] += input[i][IMAG] * cos(2 * (M_PI * k * i) / N)
			- input[i][REAL] * sin(2 * (M_PI * k * i) / N);
		}
		output[k][REAL] /= N;
		output[k][IMAG] /= N;
	}
}

double complex_abs(complex c) {
   return sqrt(pow(c[REAL], 2) + pow(c[IMAG], 2));
}

double complex_angle(complex c) {
   return atan2(c[IMAG], c[REAL]);
}

void complex_add_angle(complex *c, double delta) {
	double r = complex_abs(*c);
	double phi = complex_angle(*c);

	phi += delta;

	*c[REAL] = r * cos(phi);
	*c[IMAG] = r * sin(phi);
}