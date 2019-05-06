#ifndef _REFERENCE_RADIO_H
#define _REFERENCE_RADIO_H

complex *reference_frequency_shift(double *input, double fc, double fs, int N);
double reference_qpsk_demodulator(complex symbol, double constellation_offset, char 
	*decoded_symbol);
char *reference_bitstream_to_bytestream(char *bitstream, int length);
void reference_frame_sync(char **bytestream, int length);
void reference_frame_step(char **bytestream, int frame_length);
int reference_frame_decoder(char *bytestream, char **data);
double *reference_ofdm_demodulator(complex *input, int *carrier_idx, int carrier_no, 
	char **data);
unsigned short reference_crc16_check(char *msg, int length);
int reference_frame_decoder_valid(char *bytestream, char **data, bool *valid);

#endif
