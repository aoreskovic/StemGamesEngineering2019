SRC=$(wildcard *.c)
OBJS=$(patsubst %.c, %.o, $(SRC))
INC= -I .

CFLAGS += $(INC)

all: solution.elf

%.elf: $(OBJS)
	echo $(OBJS)
	gcc $^ -lm -lfftw3 -o $@

%.o: %.c
	gcc -c $(CFLAGS) $<
