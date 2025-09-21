#include <stdio.h>
#include <glob.h>
#include <wchar.h>
#include <locale.h>

const char*
temp_file = "/sys/devices/platform/coretemp.0/hwmon/hwmon?/temp1_input";

int
main(void)
{
    glob_t globbuf;
    int err = glob(temp_file, 0, NULL, &globbuf);
    if (err) {
        fprintf(stderr, "ERR: %d\n", err);
        return err;
    }

    FILE* fp = fopen(globbuf.gl_pathv[0], "r");
    if (!fp) {
        fprintf(stderr, "Could not open file: %s", globbuf.gl_pathv[0]);
        return -1;
    }

    wchar_t line[5];
    fgetws(line, 3, fp);
    line[2] = L'°',
    line[3] = L'C',
    line[4] = L'\0',

    setlocale(LC_CTYPE, "");
    fputws(line, stdout);
}
