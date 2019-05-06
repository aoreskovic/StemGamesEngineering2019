#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <api.h>
#include <radio.h>
#include <reference_radio.h>

static const short adc_data[] = {
#include "../../datasets/single_carrier.raw"
};

#define N 20
#define Fc 12800.0
#define Fs 192000.0

#define SIGNAL_SIZE (sizeof(adc_data) / sizeof(short))

static int frequency_shift_score = 1;
static int qpsk_demodulator_score = 1;

char demod(double *signal) {
	complex spectrum[N];
   complex reference_spectrum[N];
   complex *signal_baseband = frequency_shift(signal, Fc, Fs, N);
	complex *reference_signal_baseband = reference_frequency_shift(signal, Fc, Fs, N);

   if (memcmp(signal_baseband, reference_signal_baseband, N*sizeof(complex)))
      frequency_shift_score = 0;
   
	dft(reference_signal_baseband, reference_spectrum, N);

	char bits;
   char reference_bits;
	qpsk_demodulator(reference_spectrum[0], M_PI / 4, &bits);
   reference_qpsk_demodulator(reference_spectrum[0], M_PI / 4, &reference_bits);

   if (bits != reference_bits)
      qpsk_demodulator_score = 0;
   
	return reference_bits;
}


int main() {

	double reference_signal[N];
   double signal[N];
	char reference_bitstream[SIGNAL_SIZE / N];
   char bitstream[SIGNAL_SIZE / N];

	for (int i = 0; i < SIGNAL_SIZE; i += N) {
		for (int j = 0; j < N; j++) {
			signal[j] = (double)adc_data[i + j] / (1 << 15);
		}
		bitstream[i / N] = demod(signal);
	}
   printf("frequency_shift: %d\n", frequency_shift_score);
   printf("qpsk_demodulator: %d\n", qpsk_demodulator_score);

   memcpy(signal, reference_signal, N*sizeof(double));
   memcpy(bitstream, reference_bitstream, SIGNAL_SIZE / N * sizeof(char));

   char *bytestream = bitstream_to_bytestream(reference_bitstream, SIGNAL_SIZE / N);
	char *reference_bytestream = reference_bitstream_to_bytestream(reference_bitstream, SIGNAL_SIZE / N);

   int bitstream_to_bytestream_score = 0;
   if (!memcmp(bytestream, reference_bytestream, SIGNAL_SIZE / N / 4 * sizeof(char)))
      bitstream_to_bytestream_score = 1;
   printf("bitstream_to_bytestream: %d\n", bitstream_to_bytestream_score);

   reference_frame_sync(&reference_bytestream, (SIGNAL_SIZE / N) / 4);
	frame_sync(&bytestream, (SIGNAL_SIZE / N) / 4);
   int frame_sync_score = 0;
   if (memcmp(bytestream, reference_bytestream, ((SIGNAL_SIZE / N)-200) / 4) == 0)
      frame_sync_score = 1;
   printf("frame_sync: %d\n", frame_sync_score);

	char *data;
   char *reference_data;
   char *data_string;
   char *reference_data_string;

	int cnt = 0;
	while (cnt < (SIGNAL_SIZE / N) / 4) {
		int len = frame_decoder(reference_bytestream, &data);
		sprintf(data_string, "%s%s", data_string, data);
		bytestream += len;
		cnt += len;
	}
   
   cnt = 0;
	while (cnt < (SIGNAL_SIZE / N) / 4) {
		int len = reference_frame_decoder(reference_bytestream, &reference_data);
		sprintf(reference_data_string, "%s%s", reference_data_string, reference_data);
		bytestream += len;
		cnt += len;
	}

   int frame_decoder_score = 0;
   if (strcmp(data_string,reference_data_string) == 0)
      frame_decoder_score = 1;
   printf("frame_decoder: %d\n", frame_decoder_score);

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
