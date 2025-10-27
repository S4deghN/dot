#include <stdio.h>
#include <glob.h>
#include <wchar.h>
#include <locale.h>

const char* path = "/sys/class/power_supply/BAT?/{status,capacity}";

int main()
{
    glob_t globbuf;

    int err = glob(path, GLOB_BRACE, NULL, &globbuf);
    if (err) {
        // fprintf(stderr, "ERR: %d\n", err);
        return err;
    }

    char* status_fname = globbuf.gl_pathv[0];
    char* capacity_fname = globbuf.gl_pathv[1];
    wchar_t line[7] = {0};

    FILE* fp = fopen(status_fname, "r");
    fread(line, 1, 1, fp);

    switch (line[0]) {
    case /* Unknown */      'U': line[0] = L'❗'; break;
    case /* Charging */     'C': line[0] = L'⚡'; break;
    case /* Discharging */  'D': line[0] = L'🪫'; break;
    case /* Not charging */ 'N': line[0] = L'🔌'; break;
    case /* Full */         'F': line[0] = L'🔋'; break;
    default:                   line[0] = L'❓'; break;
    }
    line[1] = ' ';

    setlocale(LC_CTYPE, "");

    fp = fopen(capacity_fname, "r");
    fgetws(line + 2, 5, fp);
    int idx = wcslen(line) - 1;
    line[idx] = '%';
    line[idx+1] = '\0';
    fputws(line, stdout);
}
