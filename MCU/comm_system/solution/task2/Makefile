SRC=$(wildcard *.c)
SRC+=../radio.c ../api/api.c
OBJS=$(patsubst %.c, %.o, $(SRC))
INC= -I . -I ../api -I ../

CFLAGS += $(INC)

all: main.elf Makefile ../../datasets/ofdm_carrier.raw

%.elf: $(OBJS)
	gcc $^ -lm -o $@

%.o: %.c
	gcc -c -g $(CFLAGS) $< -o $@

clean:
	rm main.elf