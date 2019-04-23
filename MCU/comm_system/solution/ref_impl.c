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

static char gray_map[] = {0, 1, 3, 2};

complex *frequency_shift(double *input, double fc, double fs, int N) {

	complex *output = (complex *) malloc(N * sizeof(complex));

	for (int i = 0; i < N; i++) {
		output[i][REAL] = input[i] * cos((2 * M_PI * fc * i * 1.0) / fs);
		output[i][IMAG] = -input[i] * sin((2 * M_PI * fc * i * 1.0) / fs);
	}

	return output;
}

complex *f2() {
	complex *vals = (complex *) malloc(20 * sizeof(complex));

	vals[2][0] = 3;
	vals[2][1] = 2;

	return vals;
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

	//printf("%d\n", min_index);
	//printf("%lf, %lf\n", symbol[REAL], symbol[IMAG]);

	*decoded_symbol = gray_map[min_index];

	return min_offset;
}

#define PREAMBLE_LENGTH 8
#define PREAMBLE_BYTE 0xa5
#define BITS_IN_STREAM 2

char *bitstream_to_bytestream(char *bitstream, int length) {
	int bytelen = length / 4;
	char *bytestream = (char *) malloc(bytelen);
	int byte_cnt = 0;
	char curr_byte = 0;
	int bits_cnt = 0;

	for (int i = 0; i < length; i++) {
		curr_byte |= (bitstream[i] << (BITS_IN_STREAM * (3 - bits_cnt))); 
		bits_cnt++;
		if (bits_cnt == 8 / BITS_IN_STREAM) {
			bits_cnt = 0;
			bytestream[byte_cnt++] = curr_byte;
			curr_byte = 0;
		}
	}

	return bytestream;
}


void frame_sync(char **bytestream, int length) {
	int cnt = 0;

	for (int i = 0; i < length; i++) {
		if (cnt == PREAMBLE_LENGTH) {
			// preamble detected
			*bytestream = &(*bytestream[i - cnt]);
			break;
		}
		if (*bytestream[i] == PREAMBLE_BYTE && cnt < PREAMBLE_LENGTH) {
			cnt++;
		} else if (*bytestream[i] != PREAMBLE_BYTE && cnt < PREAMBLE_LENGTH) {
			cnt = 0;
		}
	}
}

void frame_step(char **bytestream, int frame_length) {
	*bytestream += frame_length;
}


int frame_decoder(char *bytestream, char **data) {
	bytestream += PREAMBLE_LENGTH; // skip preamble

	int len = *(bytestream++); // get packet length and move to data

	*data = (char *) malloc(len);

	for (int i = 0; i < len; i++) {
		(*data)[i] = bytestream[i];
	}

	return len + PREAMBLE_LENGTH * 2 + 2 + 1;
}

#define REF_PILOT_PHASE 0

complex *channel_correction(complex *input, int first_carrier, int ofdm_size, 
	char *pilot_map) {

	complex *output = (complex *) malloc(sizeof(complex) * ofdm_size);
	dft(input, output, ofdm_size);

	double delta = 0.0;

	for (int i = first_carrier; i < ofdm_size; i++) {
		if (pilot_map[i]) {
			delta = complex_angle(input[i]) - REF_PILOT_PHASE;
		} else {
			complex_add_angle(&input[i], delta);
		}
	}

}

double *ofdm_demodulator(complex *input, char *carrier_map, int carrier_no, 
	int ofdm_size, char **data) {

	complex spectrum[ofdm_size];

	dft(input, spectrum, ofdm_size);

	*data = (char *) malloc(2 * carrier_no); // 2 bits per carrier  
	double *evm = (double *) malloc(sizeof(double) * carrier_no);

	int cnt = 0;
	for (int i = 0; i < ofdm_size; i++) {
		if (carrier_map[i]) {
			char tmp;
			evm[cnt] = qpsk_demodulator(spectrum[i], M_PI / 4, &tmp);
			*data[cnt] = tmp;
			cnt++;
		}
	}

	return evm;
}

unsigned short crc16_check(char *msg, int length) {
	int counter;
    unsigned short crc = CRC16_START_VAL;
 
    for (counter = 0; counter < length; counter++) {
        crc = (crc<<8) ^ crc16tab[((crc>>8) ^ *(char *)msg++)&0x00FF];
    }

    return crc;
}

bool frame_decoder_valid(char *bytestream, char **data) {
	bytestream += PREAMBLE_LENGTH; // skip preamble

	int len = *(bytestream++); // get packet length and move to data

	*data = (char *) malloc(len);

	for (int i = 0; i < len; i++) {
		*data[i] = bytestream[i];
	}

	// message length without 2 bytes for CRC hash
	unsigned short crc = crc16_check(*data, len - 2);
	// crc from message
	unsigned short msg_crc = *data[len - 1] << 8 | *data[len - 2]; 

	return crc == msg_crc;  
}