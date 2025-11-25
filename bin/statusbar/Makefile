CFLAGS := -Wall -O3 -g -std=c23

programs = $(patsubst %.c,bin/%,$(wildcard *.c))

all: $(programs)

# debug: CFLAGS += -g
# debug: all

bin/%: %.c | bin/
	$(CC) $(CFLAGS) $< -o $@ -lX11

bin/:
	mkdir -p bin

clean:
	rm bin/*
