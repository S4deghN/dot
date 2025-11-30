CFLAGS := -Wall -O2 -g -std=c23

programs = $(patsubst %.c,bin/%,$(wildcard *.c))

all: $(programs)

# debug: CFLAGS += -g
# debug: all

bin/%: %.c | bin/
	$(CC) $(CFLAGS) $< -o $@

bin/dwm-status: dwm-status.c
	$(CC) $(CFLAGS) $< -o $@ -lX11 -lxkbfile


bin/:
	mkdir -p bin

clean:
	rm bin/*
