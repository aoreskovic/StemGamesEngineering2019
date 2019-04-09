SRC=$(wildcard *.c)
OBJS=$(patsubst %.c, %.o, $(SRC))
INC= -I .

CFLAGS += $(INC)

all: solution.elf Makefile ../signal.txt

%.elf: $(OBJS)
	gcc $^ -lm -lfftw3 -o $@

%.o: %.c
	gcc -c -g $(CFLAGS) $<

clean:
	rm solution.elf