// TODO:
// - Support human readlable time input. 1h, 50min, ...
// - Simplify logic and avoid unnecessary write calls.
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

typedef struct {
    long prev;
    long period;
    long remain;
    long paused;
} Timer;

int main(int argc, char* argv[]) {
    Timer t;
    int fd;

    if (argc > 1 && *argv[1] == 's') {
        t.prev = time(NULL);
        t.period = argc > 2 ? atol(argv[2]) : 3600;
        t.remain = t.period;
        t.paused = 0;
        int fd = shm_open("/timer", O_RDWR | O_CREAT, 0644);
        write(fd, &t, sizeof(t));
    } else if ((fd = shm_open("/timer", O_RDWR, 0644)) != -1) {
        long now = time(NULL);
        read(fd, &t, sizeof(t));

        if (argc > 1) {
            if (*argv[1] == 'p') {
                t.prev = t.paused ? now : t.prev;
                t.paused = !t.paused;
            } else if (*argv[1] == 'r') {
                t.prev = now;
                t.remain = t.period;
            }
        }

        if (!t.paused) {
            t.remain -= (now - t.prev);
            t.prev = now;
        }

        int remain = abs(t.remain);
        char* symbol = t.remain > 0 ?
            "🍅 " :
            remain%2 ? "🍅 -" : "💢 -";

        if (remain > 3600) {
            printf("%s%dh%dm%ds\n", symbol, remain/3600, (remain%3600)/60,
                remain%60);
        } else if (remain > 60) {
            printf("%s%dm%ds\n", symbol, remain/60, remain%60);
        } else {
            printf("%s%ds\n", symbol, remain%60);
        }

        lseek(fd, 0, SEEK_SET);
        write(fd, &t, sizeof(t));

        // printf("t: %ld, %ld, %ld, %ld\n", t.period, t.prev, t.remain, t.paused);
    }
}
