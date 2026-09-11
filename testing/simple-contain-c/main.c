#define _GNU_SOURCE

#include <sched.h>      // clone()
#include <sys/mount.h>  // mount(), umount()
#include <sys/wait.h>   // waitpid()
#include <sys/types.h>
#include <unistd.h>     // chroot(), chdir(), execv()
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/*
 * Stack size for the child created by clone().
 *
 * clone() needs a separate stack for the child.
 */
#define STACK_SIZE (1024 * 1024)

/*
 * Global pointer to the container's root filesystem.
 *
 * Example:
 *
 *     ./mini_container ./rootfs
 *
 * rootfs/
 * ├── bin/
 * │   └── bash
 * ├── lib/
 * ├── lib64/
 * └── usr/
 */
static const char *container_root;


/*
 * This function runs INSIDE the new namespaces.
 *
 * The parent process calls clone(), and clone() starts this
 * function as the child process.
 */
static int container_main(void *arg)
{
    char *const bash_argv[] = {
        "/bin/bash",
        NULL
    };

    (void)arg;

    printf("Container process started.\n");

    /*
     * ---------------------------------------------------------
     * 1. Set a different hostname
     * ---------------------------------------------------------
     *
     * CLONE_NEWUTS gives us our own UTS namespace.
     *
     * Changing the hostname here therefore doesn't change the
     * hostname of the host system.
     */
    if (sethostname("mini-container", 15) == -1)
    {
        perror("sethostname");
        return 1;
    }


    /*
     * ---------------------------------------------------------
     * 2. Make the mount namespace private
     * ---------------------------------------------------------
     *
     * Without this, mount/unmount operations could potentially
     * propagate to the host.
     *
     * MS_PRIVATE tells Linux not to propagate mount events.
     */
    if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) == -1)
    {
        perror("mount private");
        return 1;
    }


    /*
     * ---------------------------------------------------------
     * 3. Change the root filesystem
     * ---------------------------------------------------------
     *
     * chroot() makes the specified directory appear to be "/"
     * from the process's point of view.
     *
     * If container_root is:
     *
     *     ./rootfs
     *
     * then inside the container:
     *
     *     /bin/bash
     *
     * actually refers to:
     *
     *     ./rootfs/bin/bash
     */
    if (chroot(container_root) == -1)
    {
        perror("chroot");
        return 1;
    }


    /*
     * ---------------------------------------------------------
     * 4. Move into the new root
     * ---------------------------------------------------------
     *
     * chroot() changes the filesystem root but does not
     * automatically change the current working directory.
     *
     * chdir("/") makes "/" our current directory.
     */
    if (chdir("/") == -1)
    {
        perror("chdir");
        return 1;
    }


    /*
     * ---------------------------------------------------------
     * 5. Mount /proc
     * ---------------------------------------------------------
     *
     * Bash and many Linux programs expect /proc to exist.
     *
     * Because we have a separate mount namespace, this mount
     * exists only in our container namespace.
     */
    if (mount("proc", "/proc", "proc", 0, NULL) == -1)
    {
        perror("mount /proc");
        return 1;
    }


    /*
     * ---------------------------------------------------------
     * 6. Start Bash
     * ---------------------------------------------------------
     *
     * execv() replaces this process with /bin/bash.
     *
     * The PID of bash is therefore the PID assigned to this
     * process in the new PID namespace.
     */
    printf("Starting /bin/bash...\n");

    if (execv("/bin/bash", bash_argv) == -1)
    {
        perror("execv /bin/bash");
        return 1;
    }

    return 0;
}


/*
 * Program entry point.
 */
int main(int argc, char **argv)
{
    pid_t pid;
    int status;

    /*
     * We need a root filesystem argument.
     *
     * Example:
     *
     *     sudo ./mini_container ./rootfs
     */
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <rootfs>\n", argv[0]);
        return 1;
    }

    container_root = argv[1];


    /*
     * Allocate a stack for the child.
     *
     * clone() will use the end of this memory region as the
     * child's stack.
     */
    char *stack = malloc(STACK_SIZE);

    if (stack == NULL)
    {
        perror("malloc");
        return 1;
    }


    /*
     * ---------------------------------------------------------
     * Create the container process
     * ---------------------------------------------------------
     *
     * clone() is similar to fork(), but lets us choose exactly
     * which namespaces the child should enter.
     *
     * CLONE_NEWPID
     *     New PID namespace.
     *
     * CLONE_NEWUTS
     *     New hostname/domain-name namespace.
     *
     * CLONE_NEWNS
     *     New mount namespace.
     *
     * CLONE_NEWNET
     *     New network namespace.
     *
     * CLONE_NEWIPC
     *     New IPC namespace.
     *
     * SIGCHLD
     *     Notify the parent when the child exits.
     */
    pid = clone(
        container_main,
        stack + STACK_SIZE,
        CLONE_NEWPID |
        CLONE_NEWUTS |
        CLONE_NEWNS |
        CLONE_NEWNET |
        CLONE_NEWIPC |
        SIGCHLD,
        NULL
    );

    if (pid == -1)
    {
        perror("clone");
        free(stack);
        return 1;
    }


    /*
     * The parent is still running in the HOST namespaces.
     *
     * The child is running in the container namespaces.
     */
    printf("Container started with host PID %d\n", pid);


    /*
     * Wait for the container process to terminate.
     *
     * This is similar to what a container runtime does:
     *
     *     start container
     *     wait for container process
     */
    if (waitpid(pid, &status, 0) == -1)
    {
        perror("waitpid");
        free(stack);
        return 1;
    }


    /*
     * The container has stopped.
     */
    printf("Container stopped.\n");

    free(stack);

    return 0;
}