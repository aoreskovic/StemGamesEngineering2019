#include <stdio.h>
#include "api.h"

static char data[100];

void sym_irq(void) {
	// acquisition I i Q
	// demodulation
	// decoding
	// send_to_fifo
}


int main() {
	char bits;
	char byte = 0;
	char bits_cnt = 0;
	int byte_cnt = 0;

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