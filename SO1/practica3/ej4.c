#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include "ej4_readwrite_lock.h"

#define M 5
#define N 5
#define ARRLEN 10240

int arr[ARRLEN];

pthread_mutex_t mut_escritor = PTHREAD_MUTEX_INITIALIZER; 
pthread_mutex_t mut_lector = PTHREAD_MUTEX_INITIALIZER; 


void * escritor(void *arg)
{
    int i;
    int num = arg - (void*)0;
    while (1) {
        sleep(random() % 3);
        printf("Escritor %d escribiendo\n", num);
        
        lock_write(&mut_lector,&mut_escritor);
        for (i = 0; i < ARRLEN; i++)
            arr[i] = num;
        unlock_write(&mut_lector,&mut_escritor);
    }

    return NULL;
}

void * lector(void *arg){

    int v, i;
    int num = arg - (void*)0;
    while (1) {
        sleep(random() % 3);
        lock_read(&mut_lector,&mut_escritor);

        v = arr[0];
        for (i = 1; i < ARRLEN; i++) {
            if (arr[i] != v)
                break;
        }
        unlock_read(&mut_lector);
        if (i < ARRLEN)
            printf("Lector %d, error de lectura\n", num);
        else
            printf("Lector %d, dato %d\n", num, v);
    }
    return NULL;
}

int main() {
        
    pthread_t lectores[M], escritores[N];
    int i;
    for (i = 0; i < M; i++)
        pthread_create(&lectores[i], NULL, lector, i + (void*)0);
    for (i = 0; i < N; i++)
        pthread_create(&escritores[i], NULL, escritor, i + (void*)0);
    pthread_join(lectores[0], NULL); /* Espera para siempre */
    
    return 0;
}