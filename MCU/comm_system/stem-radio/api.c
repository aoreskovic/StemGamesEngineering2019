#include <signal.h>
#include <unistd.h>
#include "queue.h"
#include "input.h"

static queue_t *fifo;

void register_irq(void (*irq_func)(int)) {
	signal(SIGALRM, irq_func);
}

void start_receiver(void) {
	fifo = queue_init(1024);
	ualarm(10 * 1000, 10 * 1000);
}

short adc_read_data(void) {
	return adc_data[arr_cnt++];
}

char recv_from_fifo(void) {
	return queue_dequeue(fifo);
}

void send_to_fifo(char data) {
	queue_enqueue(fifo, data);
}

void print_fifo() {
	print_queue(fifo);
}