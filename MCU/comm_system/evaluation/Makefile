SRC=$(wildcard *.c)
SRC+=api/api.c
OBJS=$(patsubst %.c, %.o, $(SRC))
INC= -I . -I api

CFLAGS += $(INC)

all: main.elf Makefile ../datasets/single_carrier.raw

%.elf: $(OBJS)
	gcc $^ -lm -o $@

%.o: %.c
	gcc -c -g $(CFLAGS) $< -o $@

clean:
	rm main.elf