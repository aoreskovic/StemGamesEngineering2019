#include <stdio.h>
#include <fftw3.h>

#include "api.h"

static char data[100];

#define NUM_OF_SYM_SAMPLES 100
#define CHANNEL_NUMBER 10
#define REAL 0
#define IMAG 1


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

void sym_irq(void) {
	double channel_real, channel_imag;

	// acquisition I i Q
	for (int i = 0; i < NUM_OF_SYM_SAMPLES; i++) {
		inp[i][REAL] = adc_read_data();
		inp[i][IMAG] = adc_read_data();
	}
	// demodulation
	fftw_execute(plan);

	channel_real = out[CHANNEL_NUMBER][REAL];
	channel_imag = out[CHANNEL_NUMBER][IMAG];

	// decoding and sending to fifo
	send_to_fifo(decode_qpsk(channel_real, channel_imag));
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

	while (byte_cnt < 100) {

		while (bits = recv_from_fifo() < 0) {
			byte |= bits << (2 * (3 - bits_cnt));
			bits_cnt++;
			if (bits_cnt == 4) {
				data[byte_cnt++] = byte;
				bits_cnt = 0;
				byte = 0;
			}
		}
	}	


	printf("%s\r\n", data);

	return 0;
}
