#include <stdio.h>
#include <fftw3.h>
#include <math.h>

#include "api.h"

static char data[1024];

#define NUM_OF_SYM_SAMPLES 100
#define CHANNEL_NUMBER 0
#define REAL 0
#define IMAG 1


#define Fs 96000.0
#define Fc 30000.0


static fftw_complex inp[NUM_OF_SYM_SAMPLES];
static fftw_complex out[NUM_OF_SYM_SAMPLES];
static fftw_plan plan; 


static char decode_qpsk(double real, double imag) {
	char bits = 0;

	if (real > 0 && imag > 0) {
		bits = 0;
	} else if (real > 0 && imag < 0) {
		bits = 1;
	} else if (real < 0 && imag > 0) {
		bits = 2;
	} else {
		bits = 3;
	}

	return bits;

}

static volatile int lock = 0; 

double mean(fftw_complex *sig, int comp) {
	double m = 0;

	for (int i = 0; i < NUM_OF_SYM_SAMPLES; i++) {
		m += sig[i][comp];
	}	

	return m / NUM_OF_SYM_SAMPLES;
}

void sym_irq(int param) {
	double channel_real, channel_imag;

	// acquisition I i Q
	for (int i = 0; i < NUM_OF_SYM_SAMPLES; i++) {
		double sig_val = (double) adc_read_data();
		inp[i][REAL] = sig_val;
		inp[i][IMAG] = sig_val;
    }

    // transpose
    for (int i = 0; i < NUM_OF_SYM_SAMPLES; i++) {
    	inp[i][REAL] *= cos((2 * M_PI * Fc * i * 1.0) / Fs);
    	inp[i][IMAG] *= sin((2 * M_PI * Fc * i * 1.0) / Fs);
    }

	// demodulation
	fftw_execute(plan);

	channel_real = out[CHANNEL_NUMBER][REAL];
	channel_imag = out[CHANNEL_NUMBER][IMAG];

	// decoding and sending to fifo
	char qpsk = decode_qpsk(channel_real, -channel_imag);
	// alternative:
	// char qpsk = decode_qpsk(mean(inp, REAL), -mean(inp, IMAG));

	send_to_fifo(qpsk);
}


int main() {
	char bits;
	char byte = 0;
	char bits_cnt = 0;
	int byte_cnt = 0;

	plan = fftw_plan_dft_1d(NUM_OF_SYM_SAMPLES, inp, out, FFTW_FORWARD, 
		FFTW_ESTIMATE);

	register_irq(&sym_irq);
	start_receiver();


	while (byte_cnt < 240) {

		if ((bits = recv_from_fifo()) >= 0) {
			byte |= (bits << (2 * (bits_cnt))); // big endian
			bits_cnt++;
			if (bits_cnt == 4) {
				data[byte_cnt++] = byte;
				bits_cnt = 0;
				byte = 0;
			}
		}
	}	

	for (int i = 0; i < 240; i++) {
		if ((unsigned char)data[i] != 0xaa && (unsigned char)data[i] != 0x55)
			printf("%c", data[i]);
	}
	printf("\n");

	return 0;
}
