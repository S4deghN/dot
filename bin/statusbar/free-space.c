#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>

int main() {
    int stdout_fd = shm_open("/stdout", O_CREAT | O_RDWR, 0644);
    int current_flags = fcntl(stdout_fd, F_GETFD);
    int err = fcntl(stdout_fd, F_SETFD, current_flags & (~FD_CLOEXEC));
    if (err) {
        printf("ERR: %s\n", strerror(errno));
    }

    pid_t cpid = fork();

    if (cpid == 0) {
        close(STDOUT_FILENO);
        int ret = dup2(stdout_fd, STDOUT_FILENO);
        if (ret == -1) {
            fprintf(stderr, "ERR: %s\n", strerror(errno));
        }
        printf("test!\n");

        printf("hello form Child!\n");
        execve("/usr/bin/ls", (char*[]){"ls", "-a", NULL}, NULL);
    } else {
        int wstatus;
        waitpid(cpid, &wstatus, 0);

        // printf("shm: %*.s\n", 10, shmp);

        printf("hello form Parent!\n");

        char buff[10];
        lseek(stdout_fd, 0, SEEK_SET);
        int n = read(stdout_fd, buff, 10);
        buff[n] = 0;
        printf("n: %d out: %s\n", n, buff);
    }
}
