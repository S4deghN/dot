CFLAGS := -Wall -O3

programs = $(patsubst %.c,bin/%,$(wildcard *.c))

all: $(programs)

bin/%: %.c | bin/
	$(CC) $(CFLAGS) $< -o $@

bin/:
	mkdir -p bin
