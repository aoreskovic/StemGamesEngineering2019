#ifndef _API_H
#define _API_H

void register_irq(void (*irq_func)(int));
void start_receiver(void);
short adc_read_data(); //get I, get Q
char recv_from_fifo(void);
void send_to_fifo(char data);


#endif