#ifndef _RADIO_H
#define _RADIO_H

complex *frequency_shift(double *input, double fc, double fs, int N);
double qpsk_demodulator(complex symbol, double constellation_offset, char 
	*decoded_symbol);
char *bitstream_to_bytestream(char *bitstream, int length);
void frame_sync(char **bytestream, int length);
void frame_step(char **bytestream, int frame_length);
int frame_decoder(char *bytestream, char **data);
complex *channel_correction(complex *input, int first_carrier, int ofdm_size, 
	char *pilot_map);

double *ofdm_demodulator(complex *input, char *carrier_map, int carrier_no, 
	int ofdm_size, char **data);
unsigned short crc16_check(char *msg, int length);
int frame_decoder_valid(char *bytestream, char **data, bool *valid);

#endif
