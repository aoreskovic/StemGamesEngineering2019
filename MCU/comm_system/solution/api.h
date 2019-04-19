#ifndef _API_H
#define _API_H

typedef double complex[2];

void dft(complex *input, complex *output, int N);
void idft(complex *input, complex *output, int N);

#endif