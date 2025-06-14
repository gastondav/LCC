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
int salida_archivo(char* args[], int cant){
    int pos_archivo = -1;
    char sim[2];
    sim[0] = '>';
    sim[1] = '\0';
    for(int i = 0; i < cant;i++){
        if(!strcmp(args[i],sim)){
            pos_archivo = i;
            i = cant;
        }
    }
    return pos_archivo;
}

//ITEMS A,B Y C DEL EJERCICIO 7

int main(){
    char comando[largo];
    char *args[cant_arg];
    pid_t pid;
    int status;
    int cant;
    while(1){
        printf("$");
        fgets(comando, largo, stdin);
        cant = separar_argumentos(comando,args);
        pid = fork();
        if(pid == 0){
            int pos = salida_archivo(args, cant);
            if(pos != -1){
                int fd = open(args[pos+1], O_CREAT | O_WRONLY | O_TRUNC, 0644);
                dup2(fd,STDOUT_FILENO);
                close(fd);
                args[pos] = NULL;
            }
            execvp(args[0],args);
            exit(0);
        }     
        else{
            wait(NULL);
        }
    }
    return 0;               
}