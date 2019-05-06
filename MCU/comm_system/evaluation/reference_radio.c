#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#include "api.h"

#define REAL 0
#define IMAG 1

static double evm(complex symbol, complex ref) {
	double real_diff = pow(symbol[REAL] - ref[REAL], 2);
	double imag_diff = pow(symbol[IMAG] - ref[IMAG], 2);

	return sqrt(real_diff + imag_diff);
}

static char gray_map[] = {0, 1, 3, 2};

complex *reference_frequency_shift(double *input, double fc, double fs, int N) {

	complex *output = (complex *) malloc(N * sizeof(complex));

	for (int i = 0; i < N; i++) {
		output[i][REAL] = input[i] * cos((2 * M_PI * fc * i * 1.0) / fs);
		output[i][IMAG] = -input[i] * sin((2 * M_PI * fc * i * 1.0) / fs);
	}

	return output;
}

double reference_qpsk_demodulator(complex symbol, double constellation_offset, char 
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

#define PREAMBLE_LENGTH 8
#define PREAMBLE_BYTE 0xa5
#define BITS_IN_STREAM 2

char *reference_bitstream_to_bytestream(char *bitstream, int length) {
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


void reference_frame_sync(char **bytestream, int length) {
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

void reference_frame_step(char **bytestream, int frame_length) {
	*bytestream += frame_length;
}


int reference_frame_decoder(char *bytestream, char **data) {
	bytestream += PREAMBLE_LENGTH; // skip preamble

	int len = *(bytestream++); // get packet length and move to data

	if (len <= 0) {
		printf("Invalid length");
		exit(1);
	}

	*data = (char *) malloc(len + 1);
	(*data)[len] = 0;

	for (int i = 0; i < len; i++) {
		(*data)[i] = bytestream[i];
	}

	return len + PREAMBLE_LENGTH * 2 + 2 + 1;
}

double *reference_ofdm_demodulator(complex *spectrum, int *carrier_idx, int carrier_no, 
	char **data) {

	*data = (char *) malloc(carrier_no);  
	double *evm = (double *) malloc(sizeof(double) * carrier_no);

	int cnt = 0;
	for (int i = 0; i < carrier_no; i++) {
		char tmp;
		evm[i] = reference_qpsk_demodulator(spectrum[carrier_idx[i]], M_PI / 4, &tmp);
		(*data)[i] = tmp;
	}

	return evm;
}

unsigned short reference_crc16_check(char *msg, int length) {
	int counter;
    unsigned short crc = CRC16_START_VAL;
 
    for (counter = 0; counter < length; counter++) {
        crc = (crc<<8) ^ crc16tab[((crc>>8) ^ *(char *)msg++)&0x00FF];
    }

    return crc;
}

int reference_frame_decoder_valid(char *bytestream, char **data, bool *valid) {
	int len = reference_frame_decoder(bytestream, data);
	len -= 2 * PREAMBLE_LENGTH + 2 + 1;
	// message length without 2 bytes for CRC hash
	unsigned short crc = reference_crc16_check(*data, len);
	// crc from message
	unsigned short msg_crc = 0;
	msg_crc |= bytestream[PREAMBLE_LENGTH + 1 + len] & 0xFF;
	msg_crc = (msg_crc << 8); 
	msg_crc |= bytestream[PREAMBLE_LENGTH + 1 + len + 1] & 0xFF; 

	*valid = msg_crc == crc;

	return len += 2 * PREAMBLE_LENGTH + 2 + 1;  
}