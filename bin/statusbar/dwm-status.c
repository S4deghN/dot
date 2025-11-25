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
#include <assert.h>
#include <errno.h>

#include "timer.h"

#define leftClick   1
#define rightClick  2
#define middleClick 3
#define scrollUp    4
#define scrollDown  5

#define INIT \
    static int init = 1; \
    if (init && (init = 0) == 0)

typedef void (signalHandler_h)(int,  siginfo_t *, void *);

static uint sec_count;

static char *timer()// {{{
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

static char *net()// {{{
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

static char *cpu_temp()// {{{
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

static char *mem()// {{{
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

static char *disk()// {{{
{
    static char buff[32];
    static int stdout_redir;
    static char* number = buff;

    if (sec_count % 10) return number;

    INIT {
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
        waitpid(cpid, &wstatus, 0);

        lseek(stdout_redir, 0, SEEK_SET);
        int n = read(stdout_redir, buff, sizeof(buff));
        number = buff;
        while(57 < *number || *number < 48) ++number;
        // extra -1 to skip '\n' at the end.
        number[n - (number - buff) - 1] = '\0';
    }

    return number;
}// }}}

static char *volume(int signum, siginfo_t *si, void *ucontext)// {{{
{
    static char output_str[32];

    if (signum > SIGRTMIN) {
        int signal = signum - SIGRTMIN;
        int button = si->si_value.sival_int;

        if (button == scrollUp) {
            // pactl set-sink-volume @DEFAULT_SINK@ +5%
        }
    }

    if (sec_count % -1) {
        return output_str;
    } else {
        printf("priodic update\n");
    }

    return output_str;
}// }}}

static char *timedate(int signum, siginfo_t *si, void *ucontext)// {{{
{

    static char output_str[32];
    static struct tm tm;
    static bool alternative_format;

    if (signum > SIGRTMIN) {
        int signal = signum - SIGRTMIN;
        int button = si->si_value.sival_int;
        printf("signal: %d, button: %d\n", signal, button);
        if (button == leftClick) {
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

#define stringify(a) #a
#define hex_str(a)  stringify(\x##a)

#define block(f, signum) do {                           \
    INIT {                                              \
        struct sigaction sa = {                         \
            .sa_sigaction = (signalHandler_h*)timedate, \
            .sa_flags = SA_SIGINFO                      \
        };                                              \
        sigaction(SIGRTMIN+signum, &sa, NULL);          \
    }                                                   \
    p = stpcpy(p, hex_str(signum));                     \
    p = stpcpy(p, timedate(0, NULL, NULL));             \
    p = stpcpy(p, hex_str(signum));                     \
} while(0)

void ten_sig_handler(int signum) {
    printf("got sig: %d\n!", signum);
}

int main() {

    // signal(SIGRTMIN+10, SIG_IGN);
    if (signal(SIGRTMIN+10, ten_sig_handler) == SIG_ERR) {
        printf("error:%d: %s!\n", errno, strerror(errno));
        return 1;
    }


    Display* main_display = XOpenDisplay(0);
    Window root_window = XDefaultRootWindow(main_display);

    char *c = hex_str(1);
    printf("c = %d\n", *c);


    for (;; ++sec_count) {
        static char status_str[254];
        char *p = status_str;

        char *t = timer();
        if (t) {
            p = stpcpy(p, t);
            p = stpcpy(p, " | ");
        }
        p = stpcpy(p, net());
        p = stpcpy(p, " | ");
        p = stpcpy(p, cpu_temp());
        p = stpcpy(p, "°C");
        p = stpcpy(p, " | ");
        p = stpcpy(p, "MEM ");
        p = stpcpy(p, mem());
        p = stpcpy(p, " | ");
        p = stpcpy(p, "/ ");
        p = stpcpy(p, disk());
        p = stpcpy(p, " | ");
        block(timedate, 1);

        // snprintf(status_str, sizeof(status_str),
        //     " %s | %s | %s°C | MEM %s | / %s | %s",
        //     timer(), net(), cpu_temp(), mem(), disk(), timedate());

        XStoreName(main_display, root_window, status_str);
        XFlush(main_display);
        sleep(1);
    }
}
