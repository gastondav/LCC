#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <assert.h>

pid_t childpid;

char *split(char *s, char delim)
{
	char *p = strchr(s, delim);

	if (!p) return NULL;

	*p = 0;
	return p + 1;
}

void prompt()
{
	printf("$ ");
	fflush(stdout);
}

void quit (char *s)
{
	perror(s);
	exit(1);
}

void handler(int sig)
{
	/* if (childpid) */
	/*         kill(childpid, sig); */

	printf("\n");

	if (!childpid)
		prompt();
}

void exec_cmd_args(char *s)
{
	char *cmd;
	char *args[20];
	char *t;
	int narg;
	int rc;

	cmd = strtok(s, " \t");
	args[0] = cmd;
	t = cmd;
	narg = 1;

	while ((t = strtok(NULL, " \t")))
		args[narg++] = t;
	args[narg] = NULL;

	rc = execvp(cmd, args);
	if (rc < 0)
		quit("execvp");
}

void redir_to(char *f)
{
	int fd;
	char *s = strtok(f, "\t ");

	fd = open(s, O_CREAT | O_TRUNC | O_WRONLY, 0644);
	if (fd < 0)
		quit("open");

	close(1);
	dup(fd);
	close(fd);
}

void exec_cmd_redir(char *c)
{
	char *c1 = strtok(c,    ">");
	char *f  = strtok(NULL, ">");

	if (!f) {
		exec_cmd_args(c);
		return;
	}

	redir_to(f);
	exec_cmd_args(c1);
}

void exec1(char *c, int infd, int outfd)
{
	if (infd != 0) {
		close(0);
		dup(infd);
		close(infd);
	}
	if (outfd != 1) {
		close(1);
		dup(outfd);
		close(outfd);
	}
	exec_cmd_redir(c);
	exit(1); /* por si el exec falla */
}

void fork_and_exec1(char *c, int infd, int outfd)
{
	pid_t p;
	p = fork();
	if (p < 0)
		quit("fork");

	/* el padre (shell) retorna */
	if (p)
		return;

	exec1(c, infd, outfd);
}

int fork_and_exec_cmd_pipe(char *c, int infd, int outfd)
{
	char *c1 = c;
	char *c2 = split(c1, '|');

	/* Si hay algo a la derecha */
	if (c2) {
		int pip[2];
		int n;
		pipe(pip);

		/* 1er proceso */
		if (fork() == 0) {
			close(pip[0]);
			exec1(c1, infd, pip[1]);
		}

		/* Seguimos ejecutando el resto */
		close(pip[1]); /* no vamos a escribir a este pipe */

		/*
		 * Si estamos en un llamado recursivo.. ya tenemos un extremo de
		 * lectura de un pipe abierto, pero no lo vamos a usar. si no lo
		 * cerramos, es un leak.
		 */
		if (infd != 0)
			close(infd);

		n = fork_and_exec_cmd_pipe(c2, pip[0], outfd);

		/* Al terminar, la shell cierra la lectura del pipe */
		close(pip[0]);
		return n+1;
	} else {
		fork_and_exec1(c1, infd, outfd);
		return 1;
	}
}

void shell1()
{
	char buf[200];
	char c;
	int i, n;

	prompt();

	i = 0;
	while ((c = getchar()) != EOF && c != '\n')
		buf[i++] = c;
	buf[i] = 0;

	if (i == 0 && c == EOF) {
		printf("\n");
		exit(0);
	}

	n = fork_and_exec_cmd_pipe(buf, 0, 1);
	for (i = 0; i < n; i++)
		wait(NULL);
}

void shell()
{
	while(1)
		shell1();
}

int main()
{
	signal(SIGINT, handler);
	shell();
}
