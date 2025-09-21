// used = MemTotal - MemFree - (Buffers + Cached + SReclaimable - Shmem)

#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

const char unit[] = { 'k', 'M', 'G'};

int main() {
    char buff[3*28];
    int fd = open("/proc/meminfo", O_RDONLY);
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

    printf("%3.*f%c", diff_decimal, diff, unit[unit_idx]);
}
