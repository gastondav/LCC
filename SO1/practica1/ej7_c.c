#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <fcntl.h>

#define largo 1024
#define cant_arg 10

int separar_argumentos(char comando[], char* args[]) {
    int i = 0, j = 0, k = 0;
    char palabra[largo];
    while (comando[i] != '\0') {
        if (comando[i] == ' ' || comando[i] == '\n') {
            palabra[k] = '\0';
            if (k > 0) {
                args[j] = (char*)malloc(sizeof(char) * (k + 1));
                strcpy(args[j], palabra);
                j++;
                k = 0;
            }
        } else {
            palabra[k] = comando[i];
            k++;
        }
        i++;
    }
    args[j] = NULL;
    return j;
}

int detecta_abridor_archivos(char* args[], int cant) {
    for (int i = 0; i < cant; i++) {
        if (strcmp(args[i], ">") == 0) return i;
    }
    return -1;
}

int detecta_pipes(char* args[], int cant, int inicio) {
    for (int i = inicio; i < cant; i++) {
        if (strcmp(args[i], "|") == 0) return i;
    }
    return -1;
}

void ejecutar_con_pipes(char* args[], int cant) {
    int pipes[2][2];
    int comando_inicio = 0;
    int comando_fin;
    int i = 0;
    int entrada = 0;

    while ((comando_fin = detecta_pipes(args, cant, comando_inicio)) != -1) {
        pipe(pipes[i % 2]);

        if (fork() == 0) {
            dup2(entrada, STDIN_FILENO);
            dup2(pipes[i % 2][1], STDOUT_FILENO);
            close(pipes[i % 2][0]);
            args[comando_fin] = NULL;
            execvp(args[comando_inicio], &args[comando_inicio]);
            perror("exec");
            exit(1);
        }
        close(pipes[i % 2][1]);
        entrada = pipes[i % 2][0];
        comando_inicio = comando_fin + 1;
        i++;
    }

    // Último comando (puede tener redirección)
    int pos_abridor = detecta_abridor_archivos(args, cant);
    if (fork() == 0) {
        dup2(entrada, 0);
        if (pos_abridor != -1) {
            int file = open(args[pos_abridor + 1], O_CREAT | O_WRONLY | O_TRUNC, 0644);
            dup2(file, STDOUT_FILENO);
            close(file);
            args[pos_abridor] = NULL;
        }
        execvp(args[comando_inicio], &args[comando_inicio]);
        perror("exec");
        exit(1);
    }

    // Espera por todos los hijos
    while (wait(NULL) > 0);
}

int main() {
    char comando[largo];
    char* args[cant_arg];
    int cant;

    while (1) {
        printf("$");
        fgets(comando, largo, stdin);
        cant = separar_argumentos(comando, args);
        ejecutar_con_pipes(args, cant);
    }
    return 0;
}
