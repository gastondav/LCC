#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

struct semaforo{
    pthread_mutex_t mutex;
    pthread_cond_t cond;
    int n;
};

struct semaforo s; // SEMAFORO GLOBAL

void sem_init_casero(struct semaforo* s, int n){
    s->n = n;
    pthread_mutex_init(&s->mutex, NULL);
    pthread_cond_init(&s->cond, NULL);
}

void sem_post_casero(struct semaforo* s){
    pthread_mutex_lock(&s->mutex);
    if(s->n == 0)
        pthread_cond_broadcast(&s->cond);
    s->n++;
    pthread_mutex_unlock(&s->mutex);
}

void sem_wait_casero(struct semaforo* s){
    pthread_mutex_lock(&s->mutex);
    while(s->n == 0)
        pthread_cond_wait(&s->cond, &s->mutex);
    s->n --; 
    pthread_mutex_unlock(&s->mutex);
}

void* hilo_funcion1(void* arg) {
    printf("Hilo 1: ejecutando tarea...\n");
    sleep(2); // Simula trabajo
    printf("Hilo 1: tarea completada, liberando semáforo.\n");
    sem_post_casero(&s); // Incrementa el semáforo (libera)
    return NULL;
}

void* hilo_funcion2(void* arg) {
    printf("Hilo 2: esperando semáforo...\n");
    sem_wait_casero(&s); // Decrementa el semáforo (espera si es 0)
    printf("Hilo 2: semáforo adquirido, continuando ejecución.\n");
    return NULL;
}

int main() {
    pthread_t hilo1, hilo2;

    // Inicializa el semáforo en 0 (bloqueado)
    sem_init_casero(&s, 0);

    pthread_create(&hilo1, NULL, hilo_funcion1, NULL);
    pthread_create(&hilo2, NULL, hilo_funcion2, NULL);

    pthread_join(hilo1, NULL);
    pthread_join(hilo2, NULL);

    return 0;
}
