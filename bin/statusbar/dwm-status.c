#define _GNU_SOURCE
#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <glob.h>
#include <time.h>
#include <string.h>
#include <wchar.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/XKBlib.h>
#include <X11/extensions/XKB.h>
#include <X11/extensions/XKBstr.h>
#include <X11/extensions/XKBrules.h>
#include <assert.h>
#include <errno.h>
#include <pthread.h>

#include "timer.h"

#define countof(a) (sizeof(a)/sizeof(a[0]))
#define stringify(a) #a
#define hex_str(a)  stringify(\x##a)

#define INIT \
    static int init = 1; \
    if (init && (init = 0) == 0)

#define LeftClick   1
#define MiddleClick 2
#define RightClick  3
#define ScrollUp    4
#define ScrollDown  5

typedef void (*SignalCb)(int,  siginfo_t *, void *);
typedef char *(*BlockCb)(int,  siginfo_t *, void *);

typedef struct {
    BlockCb cb;
    int rt_signum;
    char *prefix;
    char *postfix;
} StatusBlock;


static uint sec_count;

static char *timer(int signum, siginfo_t *si, void *ucontext)// {{{
{
    static char output_str[32];
    static Timer *t = NULL;

    if (access("/dev/shm/timer", F_OK) == 0) {
        if (!t) {
            int fd = open("/dev/shm/timer", O_RDONLY);
            t = mmap(NULL, sizeof(*t), PROT_READ, MAP_SHARED, fd, 0);
            assert(t != MAP_FAILED);
            close(fd);
        }
    } else {
        if (t) {
            munmap(t, sizeof(*t));
            t = NULL;
        }
        return NULL;
    }

    timer_snprintf(output_str, sizeof(output_str), t);
    return output_str;
}// }}}

static char *net(int signum, siginfo_t *si, void *ucontext)// {{{
{
    const char* tx_path = "/sys/class/net/{en,wl}*/statistics/tx_bytes";
    const char* rx_path = "/sys/class/net/{en,wl}*/statistics/rx_bytes";
    const char* unit[] = { "B ", "kB", "MB", "GB"};

    static char out_str[32];
    static int  fdc;
    static int *tx_fds;
    static int *rx_fds;
    static long last_tx_bytes;
    static long last_rx_bytes;

    INIT {
        glob_t tx_g;
        glob_t rx_g;
        glob(tx_path, GLOB_BRACE | GLOB_NOSORT, NULL, &tx_g);
        glob(rx_path, GLOB_BRACE | GLOB_NOSORT, NULL, &rx_g);
        fdc = tx_g.gl_pathc;
        tx_fds = malloc(sizeof(*tx_fds) * fdc);
        rx_fds = malloc(sizeof(*rx_fds) * fdc);
        for (int i = 0; i < fdc; ++i) {
            tx_fds[i] = open(tx_g.gl_pathv[i], O_RDONLY);
            rx_fds[i] = open(rx_g.gl_pathv[i], O_RDONLY);
        }
    }

    long tx_bytes = 0;
    long rx_bytes = 0;
    char tx_buff[20];
    char rx_buff[20];
    for (int i = 0; i < fdc; ++i) {
        lseek(tx_fds[i], 0, SEEK_SET);
        lseek(rx_fds[i], 0, SEEK_SET);
        size_t tx_n = read(tx_fds[i], tx_buff, sizeof(tx_buff));
        size_t rx_n = read(rx_fds[i], rx_buff, sizeof(rx_buff));
        tx_buff[tx_n] = 0;
        rx_buff[rx_n] = 0;
        tx_bytes += atol(tx_buff);
        rx_bytes += atol(rx_buff);
    }

    float tx_delta = tx_bytes - last_tx_bytes;
    float rx_delta = rx_bytes - last_rx_bytes;
    last_tx_bytes = tx_bytes;
    last_rx_bytes = rx_bytes;

    int tx_unit_idx = 0;
    while(tx_delta > 999 && ++tx_unit_idx)
        tx_delta /= 1024;

    int rx_unit_idx = 0;
    while(rx_delta > 999 && ++rx_unit_idx)
        rx_delta /= 1024;

    int rx_decimal = (rx_delta  - (int)rx_delta) > 0.05;
    int tx_decimal = (tx_delta  - (int)tx_delta) > 0.05;

    // ↓ ↑
    snprintf(out_str, sizeof(out_str), "↓%5.*f%s ↑%5.*f%s",
        rx_decimal, rx_delta, unit[rx_unit_idx],
        tx_decimal, tx_delta, unit[tx_unit_idx]);

    return out_str;
}// }}}

static char *cpu_temp(int signum, siginfo_t *si, void *ucontext)// {{{
{
    const char* temp_file = "/sys/devices/platform/coretemp.0/hwmon/hwmon?/temp1_input";
    static char output_str[3];
    static int fd;

    if (sec_count % 2) return output_str;

    INIT {
        glob_t globbuf;
        if (glob(temp_file, 0, NULL, &globbuf) != 0) {
            return "ERR";
        }
        fd = open(globbuf.gl_pathv[0], O_RDONLY);
        if (fd == -1) {
            fprintf(stderr, "Could not open file: %s", globbuf.gl_pathv[0]);
            return "ERR";
        }
    }

    lseek(fd, 0, SEEK_SET);
    read(fd, output_str, 3);
    output_str[2] = '\0';

    return output_str;
}// }}}

static char *mem(int signum, siginfo_t *si, void *ucontext)// {{{
{
    const char unit[] = { 'k', 'M', 'G'};
    static char out_str[16];
    static char buff[3*28];
    static int fd;

    if (sec_count % 3) return out_str;

    INIT {
        fd = open("/proc/meminfo", O_RDONLY);
    }

    lseek(fd, 0, SEEK_SET);
    int n = read(fd, buff, sizeof(buff));

    char* cursor = buff;
    long number[3];
    int index = 0;
    while(cursor < buff + n) {
        if (57 < *cursor || *cursor < 48) { // skip non-number characters.
            ++cursor;
        } else {
            number[index++] = strtol(cursor, &cursor, 10);
            if (index == 3) {
                break;
            }
        }
    }

    float diff = number[0] - number[2];
    int unit_idx = 0;
    while (diff > 999) {
        diff /= 1000;
        ++unit_idx;
    }
    int diff_decimal = (unit_idx > 1) ? ((diff  - (int)diff) > 0.05) : 0;

    snprintf(out_str, sizeof(out_str), "%3.*f%c", diff_decimal, diff, unit[unit_idx]);
    return out_str;
}// }}}

static char *disk(int signum, siginfo_t *si, void *ucontext)// {{{
{
    static char *buff;
    static int stdout_redir;
    static char* number;

    if (sec_count % 10) return number;

    INIT {
        buff = malloc(32);
        number = buff;
        stdout_redir = memfd_create("stdout_redirect", 0);
    }

    pid_t cpid = fork();

    if (cpid == 0) {
        close(STDOUT_FILENO);
        dup2(stdout_redir, STDOUT_FILENO);
        lseek(stdout_redir, 0, SEEK_SET);
        execve("/usr/bin/df",
            (char*[]){"df", "/", "--si", "-h", "--output=avail", NULL},
            NULL);
    } else {
        int wstatus;
        if (waitpid(cpid, &wstatus, 0) == -1) {
            fprintf(stderr, "%s: errno = %d: %s\n", __FUNCTION__, errno, strerror(errno));
        }

        lseek(stdout_redir, 0, SEEK_SET);
        int n = read(stdout_redir, buff, 32);
        number = buff;
        while(57 < *number || *number < 48) ++number;
        // extra -1 to skip '\n' at the end.
        number[n - (number - buff) - 1] = '\0';
    }

    return number;
}// }}}

// static char *volume(int signum, siginfo_t *si, void *ucontext)// {{{
// {
//     static char output_str[32];

//     if (signum > SIGRTMIN) {
//         int signal = signum - SIGRTMIN;
//         int button = si->si_value.sival_int;

//         if (button == ScrollUp) {
//             // pactl set-sink-volume @DEFAULT_SINK@ +5%
//         }
//     }

//     if (sec_count % -1) {
//         return output_str;
//     } else {
//         printf("priodic update\n");
//     }

//     return output_str;
// }// }}}

static char *timedate(int signum, siginfo_t *si, void *ucontext)// {{{
{

    static char output_str[32];
    static struct tm tm;
    static bool alternative_format;

    if (signum > SIGRTMIN) {
        int signal = signum - SIGRTMIN;
        int button = si->si_value.sival_int;
        printf("signal: %d, button: %d\n", signal, button);
        if (button == LeftClick) {
            alternative_format = !alternative_format;
        }
    }

    time_t t = time(NULL);
    localtime_r(&t, &tm);

    if (alternative_format) {
        strftime(output_str, sizeof(output_str), "%b-%d %H:%M", &tm);
    } else {
        strftime(output_str, sizeof(output_str), "%Y-%m-%d %H:%M:%S", &tm);
    }

    return output_str;
}// }}}

uint xk_led_state;
char xk_layout[8];
void *_xkeyboard_listener(void *arg);
char *xkeyboard(int signum, siginfo_t *si, void *ucontext)// {{{
{
    static char output_str[32] = {0};

    INIT {
        pthread_t xk_thr;
        int *xk_signum = &(((StatusBlock*)ucontext)->rt_signum);
        pthread_create(&xk_thr, NULL, _xkeyboard_listener, xk_signum);
        pthread_detach(xk_thr);
    }

    if (signum > SIGRTMIN) {
        if (si && si->si_value.sival_int) {
        }
        output_str[0] = '\0';
        char *p = output_str;

        p = stpcpy(p, xk_layout);

        if (xk_led_state & 0x01) {
            p = stpcpy(p, ":CAPS");
        }
        if (xk_led_state & 0x02) {
            p = stpcpy(p, ":NUM");
        }

        // snprintf(output_str, sizeof(output_str), "XKB 0x%x", state);
    }

    return output_str;
}// }}}
void _xkeyboard_get_layout(Display *dpy, char *layout_buf, int size)// {{{
{
    XkbRF_VarDefsRec vd;
    XkbStateRec state;

    XkbGetState(dpy, XkbUseCoreKbd, &state);
    XkbRF_GetNamesProp(dpy, NULL, &vd);

    char *group = strtok(vd.layout, ",");
    for (int i = 0; i < state.group; i++) {
        group = strtok(NULL, ",");
        if (group == NULL) {
            fprintf(stderr, "Group out of bounds: %d\n", state.group);
            return;
        }
    }
    strncpy(layout_buf, group, size);
}// }}}
void *_xkeyboard_listener(void *arg)// {{{
{
    int xk_signum = *(int*)arg;
    int xkb_event_base;
    XEvent event;
    XkbEvent *xkb_event = (XkbEvent*)&event;
    Display *main_display = XOpenDisplay(0);

    // update on startup
    XkbGetIndicatorState(main_display, XkbUseCoreKbd, &xk_led_state);
    _xkeyboard_get_layout(main_display, xk_layout, sizeof(xk_layout));

    xkeyboard(SIGRTMIN+xk_signum, NULL, NULL);

    XkbSelectEvents(main_display, XkbUseCoreKbd,
        XkbIndicatorStateNotifyMask, XkbIndicatorStateNotifyMask);

    if (!XkbQueryExtension(main_display, NULL, &xkb_event_base, NULL, NULL, NULL)) {
        fprintf(stderr, "XKB extension not available\n");
        return NULL;
    }

    while (1) {
        XNextEvent(main_display, &event);

        if (event.type != xkb_event_base + XkbEventCode) {
            fprintf(stderr, "WARN: stray event %d\n", event.type);
        }

        switch (xkb_event->any.xkb_type) {
            case XkbIndicatorStateNotify: {
                xk_led_state = xkb_event->indicators.state;
                _xkeyboard_get_layout(main_display, xk_layout, sizeof(xk_layout));
                sigqueue(getpid(), SIGRTMIN+xk_signum, (union sigval)0);
            } break;
            default:
                printf("uncaught event: %d\n", xkb_event->any.xkb_type);
            break;
        }
    }
}// }}}

StatusBlock blocks[] = {
    {timer,     1, hex_str(1),       hex_str(1)},
    {net,       2, hex_str(2),       hex_str(2)},
    {cpu_temp,  3, hex_str(3),       "°C"hex_str(3)},
    {mem,       4, hex_str(4)"MEM ",  hex_str(4)},
    {disk,      5, hex_str(5)"/ ",   hex_str(5)},
    {xkeyboard, 6, hex_str(6)" ",   hex_str(6)},
    {timedate,  7, hex_str(7),       hex_str(7)},
};


int main() {
    Display* main_display = XOpenDisplay(0);
    Window root_window = XDefaultRootWindow(main_display);

    for (int i = 0; i < countof(blocks); ++i) {
        struct sigaction sa = {
            .sa_flags = SA_SIGINFO,
            .sa_sigaction = (SignalCb)blocks[i].cb,
        };
        sigaction(SIGRTMIN + blocks[i].rt_signum, &sa, NULL);
    }

    for (;; ++sec_count) {
        static char status_str[254];
        char *p = status_str;

        for (int i = 0; i < countof(blocks); ++i) {
            char *block_str = blocks[i].cb(0, NULL, &blocks[i]);
            if (block_str) {
                p = stpcpy(p, blocks[i].prefix);
                p = stpcpy(p, block_str);
                p = stpcpy(p, blocks[i].postfix);
                p = stpcpy(p, " | ");
            }
        }

        // fprintf(stderr, "%s\n", status_str);

        XStoreName(main_display, root_window, status_str);
        XFlush(main_display);
        sleep(1);
    }
}
