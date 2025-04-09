#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <glob.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <stdint.h>

const char* tx_path = "/sys/class/net/{en,wl}*/statistics/tx_bytes";
const char* rx_path = "/sys/class/net/{en,wl}*/statistics/rx_bytes";
const char* unit[] = { "B ", "kB", "MB", "GB"};

long
fread_bytes(int argc, char* argv[], int oflag)
{
    long bytes = 0;
    char buff[20];
    for (int i = 0; i < argc; ++i) {
        int fd = open(argv[i], oflag);
        size_t n = read(fd, buff, sizeof(buff));
        buff[n] = 0;
        bytes += atol(buff);
    }
    return bytes;
}

long
read_update_shm_var(char* path, long val)
{
    long last_val;
    // Default permission as if user creating new file on shell.
    // mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
    // r w x
    // 4 2 1
    // owner group other
    // rw-   r--   r--
    // 420   400   400
    // 6     4     4
    int fd = open(path, O_RDWR | O_CREAT, 0644);
    read(fd, &last_val, sizeof(last_val));
    ftruncate(fd, 0);
    lseek(fd, 0, SEEK_SET);
    write(fd, &val, sizeof(val));
    return last_val;
}

int main()
{
    glob_t tx_g;
    glob_t rx_g;

    glob(tx_path, GLOB_BRACE | GLOB_NOSORT, NULL, &tx_g);
    glob(rx_path, GLOB_BRACE | GLOB_NOSORT, NULL, &rx_g);

    long tx = fread_bytes(tx_g.gl_pathc, tx_g.gl_pathv, O_RDONLY);
    long rx = fread_bytes(rx_g.gl_pathc, rx_g.gl_pathv, O_RDONLY);

    long last_tx = read_update_shm_var("/dev/shm/tx", tx);
    long last_rx = read_update_shm_var("/dev/shm/rx", rx);

    float tx_delta = tx - last_tx;
    float rx_delta = rx - last_rx;

    int rx_unit_idx = 0;
    while(rx_delta > 999) {
        rx_delta /= 1024;
        ++rx_unit_idx;
    }

    int tx_unit_idx = 0;
    while(tx_delta > 999) {
        tx_delta /= 1024;
        ++tx_unit_idx;
    }

    // int rx_decimal = (int)((rx_delta + 0.05 - (int)rx_delta) * 10) != 0;
    int rx_decimal = (rx_delta  - (int)rx_delta) > 0.05;
    int tx_decimal = (tx_delta  - (int)tx_delta) > 0.05;
    printf("%5.*f%s %5.*f%s",
        tx_decimal, tx_delta, unit[tx_unit_idx],
        rx_decimal, rx_delta, unit[rx_unit_idx]);
}
