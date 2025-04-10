// For memfd.
#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/mman.h>

int main() {
    int stdout_redir = memfd_create("stdout_redirect", 0);
    // int stdout_redir = shm_open("/stdout", O_CREAT | O_RDWR, 0644);
    // ftruncate(stdout_redir, 0);
    // int current_flags = fcntl(stdout_redir, F_GETFD);
    // int err = fcntl(stdout_redir, F_SETFD, current_flags & (~FD_CLOEXEC));
    // if (err) {
    //     printf("ERR: %s\n", strerror(errno));
    // }

    pid_t cpid = fork();

    if (cpid == 0) {
        close(STDOUT_FILENO);
        dup2(stdout_redir, STDOUT_FILENO);
        execve("/usr/bin/df",
            (char*[]){"df", "/", "--si", "-h", "--output=avail", NULL},
            NULL);
    } else {
        int wstatus;
        waitpid(cpid, &wstatus, 0);

        lseek(stdout_redir, 0, SEEK_SET);
        char buff[32];
        int n = read(stdout_redir, buff, sizeof(buff));
        char* number = buff;
        while(57 < *number || *number < 48) ++number;
        write(STDOUT_FILENO, number, n - (number - buff));
    }
}
