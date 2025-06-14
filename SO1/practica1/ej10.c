#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

pid_t otro_pid;

void handler(int sig) {
    printf("PID %d recibió una señal\n", getpid());
    kill(otro_pid, SIGUSR1);  // Envío de vuelta
}

int main() {
    otro_pid = getpid();
    
    pid_t pid = fork();
    
    signal(SIGUSR1, handler);  // Se instala una vez

    if (pid == 0) {
        // Hijo
        while (1) pause();  // Espera señal
    } 
    else {
        // Padre
        otro_pid = pid;;
        sleep(1);  // Esperamos que el hijo instale el handler
        kill(pid, SIGUSR1);  // Iniciamos el ping-pong

        while (1) pause();  // Espera señal
    }

    return 0;
}
