#ifndef BIN_STATUSBAR_TIMER_H
#define BIN_STATUSBAR_TIMER_H

#include <stdio.h>

typedef struct {
    long prev;
    long period;
    long remain;
    long paused;
} Timer;

int
timer_snprintf(char *buff, unsigned int n, Timer *t)
{
    int remain = abs(t->remain);
    char* symbol = t->remain > 0 ?
        "🍅 " :
        remain%2 ? "🍅 -" : "💢 -";

    if (remain > 3600) {
        return snprintf(buff, n, "%s%dh%dm%ds", symbol, remain/3600, (remain%3600)/60,
            remain%60);
    } else if (remain > 60) {
        return snprintf(buff, n, "%s%dm%ds", symbol, remain/60, remain%60);
    } else {
        return snprintf(buff, n, "%s%ds", symbol, remain%60);
    }
}

#endif
