#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <pthread.h>

#define LARGO 10000

int a[LARGO];
int suma = 0;

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void completar(){
    pthread_mutex_lock(&mutex);
    for(int i = 0; i < LARGO; i++)
        a[i] = i;
    pthread_mutex_unlock(&mutex);  
}

void * hilo1(void *arg) { 
    for(int i = 0; i < LARGO/2; i++){
        pthread_mutex_lock(&mutex);
        suma = suma + a[i];
        pthread_mutex_unlock(&mutex);
    }
}

void * hilo2(void *arg) {
    for(int i = LARGO/2; i < LARGO; i++){
        pthread_mutex_lock(&mutex);
        suma = suma + a[i];
        pthread_mutex_unlock(&mutex);
    }
}

int main() {
    pthread_t t1, t0;
    completar();
    pthread_create(&t1, NULL, hilo1, NULL);
    pthread_create(&t0, NULL, hilo2, NULL);   
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    printf("La suma del array es: %d\n", suma); 
    return 0;
}
