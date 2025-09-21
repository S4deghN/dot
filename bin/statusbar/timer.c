// TODO:
// - Support human readlable time input. 1h, 50min, ...
#define __USE_XOPEN       /* See feature_test_macros(7) */
#define _XOPEN_SOURCE       /* See feature_test_macros(7) */
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>

struct Option {
    char* sym1;
    char* sym1_arg;
    char* des;
    bool is_set;
    void (*handle)(int* argc, char** argv[]);
};

extern struct Option __start_op_section;
extern struct Option __stop_op_section;
#define op_list(a) (&__start_op_section + a)
#define op_list_end() &__stop_op_section

// Strange thing is that this struct of size 24 bytes is not automatically
// alined if you create a list of it or increment a pointer they both move by 24
// byte steps! But when you define variables of them on a custom section they
// are put into the section with 32 byte alignment!
// Solution is to set alignment for variables when defined.
#define option(type, name, sym1, sym1_arg, des)  \
    void name##_h(int*, char**[]);               \
__attribute__((section ("op_section")))          \
__attribute__((aligned (alignof(struct Option))))\
struct Option name = {                           \
    sym1,                                        \
    sym1_arg,                                    \
    des,                                         \
    false,                                       \
    name##_h                                     \
};                                               \
type name##_val;                                 \
void name##_h (int* argc, char** argv[])

#define shift(xs_sz, xs) ((xs_sz)--, *(xs)++)

typedef struct {
    long prev;
    long period;
    long remain;
    long paused;
} Timer;

Timer t;
int fd;

option(bool, help, "h", "", "Print Help") {
    help.is_set = true;
    // Find the longest sym1 + sym1_arg for spacing.
    int longest_tab = 0;
    for(auto l = op_list(0); l != op_list_end(); ++l) {
        int opt_len = strlen(l->sym1) + strlen(l->sym1_arg);
        if (longest_tab < opt_len) {
            longest_tab = opt_len;
        }
    }

    for(auto l = op_list(0); l != op_list_end(); ++l) {
        int tab = longest_tab - (strlen(l->sym1) + strlen(l->sym1_arg));
        printf("%s %s%*c\t%s\n", l->sym1, l->sym1_arg, tab, ' ', l->des);
    }
}

option(long, start, "s", "[period]", "Start tiemr") {
    start.is_set = true;
    t.prev = time(NULL);
    t.period = *argc > 0 ? ({ struct tm time = {0}; strptime(shift(*argc, *argv), "%H:%M", &time); time.tm_hour * 3600 + time.tm_min * 60; }) : 3600;
    t.remain = t.period;
    t.paused = 0;
    int fd = shm_open("/timer", O_RDWR | O_CREAT, 0644);
    write(fd, &t, sizeof(t));
}

option(int, pause_unpause, "p", "", "Pause/Unpause tiemr") {
    pause_unpause.is_set = true;
    t.prev = t.paused ? time(0) : t.prev;
    t.paused = !t.paused;
}

option(int, reset, "r", "", "Reset tiemr") {
    reset.is_set = true;
    t.prev = time(0);
    t.remain = t.period;
}

int main(int argc, char* argv[]) {

    if ((fd = shm_open("/timer", O_RDWR, 0644)) != -1) {
        read(fd, &t, sizeof(t));
    }

    shift(argc, argv);
    while(argc > 0) {
        const char* token = shift(argc, argv);
        bool matched = false;
        for(auto l = op_list(0); l != op_list_end(); ++l) {
            if (strcmp(l->sym1, token) == 0) {
                matched = true;
                l->handle(&argc, &argv);
                break;
            }
        }
        if (!matched) {
            fprintf(stderr, "Unknow option \"%s\"\n", token);
        }
    }

    if (fd == -1 || start.is_set || help.is_set) {
        return 0;
    }

    if (!t.paused) {
        long now = time(0);
        t.remain -= (now - t.prev);
        t.prev = now;
    }

    if (!t.paused || pause_unpause.is_set || reset.is_set) {
        lseek(fd, 0, SEEK_SET);
        write(fd, &t, sizeof(t));
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
}
