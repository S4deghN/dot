CFLAGS := -Wall -O0 -g

programs = $(patsubst %.c,bin/%,$(wildcard *.c))

all: $(programs)

bin/%: %.c | bin/
	$(CC) $(CFLAGS) $< -o $@

bin/:
	mkdir -p bin
