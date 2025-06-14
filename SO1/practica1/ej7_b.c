#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <fcntl.h>

#define largo 1024
#define cant_arg 10

//recibe la linea completa del comando y lo separa en palabras y devuelve la cantidad de argumentos
int separar_argumentos(char comando[], char* args[]){
    int i = 0; 
    int j = 0; 
    int k = 0; 
    char palabra[largo];
    while(comando[i] != '\0'){
        if(comando[i] == ' ' || comando[i] == '\n'){
            palabra[k] = '\0';
            if(k>0){
                args[j] = (char*) malloc(sizeof(char) * (k+1));
                strcpy(args[j],palabra);    
                j++;
                k = 0;
            }
        }
        else{
            palabra[k] = comando[i];
            k++;
        }
        i++;
    }
    args[j] = NULL;
    return j;
}

// se fija si esta > en la lista de palabras y devuelve su posicion si no esta devuelve -1
int detecta_abridor_archivos(char* args[], int cant){
    int pos_archivo = -1;
    char simb[2];
    simb[0] = '>';
    simb[1] = '\0';
    for(int i = 0; i < cant;i++){
        if(!strcmp(args[i],simb)){
            pos_archivo = i;
            i = cant;
        }
    }
    return pos_archivo;
}

//detecta si hay un pipe y devuelve la posicion del primero que haya
int detecta_pipes(char* args[], int cant){
    int pos_pipe = -1;
    char simb[2];
    simb[0] = '|';
    simb[1] = '\0';
    for(int i = 0; i < cant;i++){
        if(!strcmp(args[i],simb)){
            pos_pipe = i;
            i = cant;
        }
    }
    return pos_pipe;
}

void comando_sin_pipes(char* args[], int cant){
    int pos_abridor = detecta_abridor_archivos(args, cant);
        if(pos_abridor != -1){
            int file = open(args[pos_abridor+1], O_CREAT | O_WRONLY | O_TRUNC, 0644);
            dup2(file,STDOUT_FILENO);
            close(file);
            args[pos_abridor] = NULL;
        }
        execvp(args[0],args);
        return;
}

//ITEM D DEL EJERCICIO 7 PARA EL CASO DE QUE EN EL COMANDO SOLO HAYA UN |

int main(){
    char comando[largo];
    char *args[cant_arg];
    pid_t pid1,pid2;
    int status;
    int cant;
    char* c1[cant_arg], *c2[cant_arg];

    while(1){
        printf("$");
        fgets(comando, largo, stdin);
        cant = separar_argumentos(comando,args);
        pid1 = fork();

        if(pid1 == 0){
            int pos_pipe = detecta_pipes(args,cant);
            if(pos_pipe == -1){
                comando_sin_pipes(args, cant);
                exit(0);
            }
            else{
                for(int i = 0; i < pos_pipe; i++) c1[i] = args[i];
                c1[pos_pipe] = NULL;

                int j = 0;
                for(int i = pos_pipe + 1; i < cant; i++)    c2[j++] = args[i];
                    c2[j] = NULL;

                int fd[2];
                pipe(fd);
                pid2 = fork();

                if(pid2 == 0){
                    close(fd[1]);
                    dup2(fd[0],STDIN_FILENO);
                    args[pos_pipe] = NULL;
                    execvp(c2[0], c2);
                    exit(0);
                }
                else{
                    close(fd[0]);
                    dup2(fd[1],STDOUT_FILENO);
                    close(fd[1]);
                    args[pos_pipe] = NULL;
                    execvp(c1[0],c1);
                    wait(NULL);
                }
            }
        }     
        else{
            wait(NULL);
        }
    }
    return 0;               
}

