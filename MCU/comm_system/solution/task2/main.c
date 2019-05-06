#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <api.h>
#include <radio.h>

static const short adc_data[] = {
#include "../../datasets/ofdm_carrier.raw"
};

#define N 128
#define Fc 36000.0
#define Fs 192000.0

#define SIGNAL_SIZE (sizeof(adc_data) / sizeof(short))

static int carrier_idx[] = {125, 126, 2, 3};
#define CARRIER_NO 4

char *demod(double *signal) {
	complex spectrum[N];
	complex *signal_baseband = frequency_shift(signal, Fc, Fs, N);
	dft(signal_baseband, spectrum, N);
	
	char *bits;
	ofdm_demodulator(spectrum, carrier_idx, CARRIER_NO, &bits);

	return bits;
}


int main() {

	double signal[N];
	char bitstream[SIGNAL_SIZE * CARRIER_NO / N];
	char *p = &bitstream[0];
	for (int i = 0; i < SIGNAL_SIZE; i += N) {
		for (int j = 0; j < N; j++) {
			signal[j] = (double)adc_data[i + j] / (1 << 15);
		}
		char *data = demod(signal);
	
		for (int k = 0; k < 4; k++) {
			*(p++) = data[k];
		}
		free(data);
	}

	char *bytestream = bitstream_to_bytestream(bitstream, SIGNAL_SIZE / N);

	frame_sync(&bytestream, (SIGNAL_SIZE / N) / 4);

	char *data;


	int cnt = 0;
	while (cnt < (SIGNAL_SIZE / N) / 4) {
		int len = frame_decoder(bytestream, &data);
		printf("%s", data);
		bytestream += len;
		cnt += len;
	}


	printf("\n");
	

	// for (int i = 0; i < SIGNAL_SIZE / N; i++) {
	// 	printf("%x", (int)bitstream[i] & 0x3);
	// }

	// printf("\n");

	// for (int i = 0; i < (SIGNAL_SIZE / N) / 4; i++) {
	// 	printf("%0m2x", (int)bytestream[i] & 0xFF);
	// 	if (bytestream[i] < 127 && bytestream[i] > 30) {
	// 		//printf("%c", bytestream[i]);
	// 	} 
	// }
	// }

	// printf("\n");
	// printf("\n");
	
	// printf("%s", data);	
	

	return 0;
} 
