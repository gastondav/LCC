#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>

int disponible = 0;

struct condicional
{
    sem_t sema;
    sem_t mutex;
};

struct condicional cond;  // CONDICIONAL GLOBAL

void pthread_cond_init_casero(struct condicional* c){
    sem_init(&c->sema, 0, 0);
    sem_init(&c->mutex, 0, 1);
}

void pthread_mutex_lock_casero(struct condicional* c){
    sem_wait(&c->mutex);
}

void pthread_mutex_unlock_casero(struct condicional* c){
    sem_post(&c->mutex);
}

void pthread_cond_wait_casero(struct condicional* c){
    pthread_mutex_unlock_casero(c);  // Libera antes de esperar
    sem_wait(&c->sema);              // Espera señal
    pthread_mutex_lock_casero(c);    // Re-adquiere el mutex
}

void pthread_cond_signal_casero(struct condicional* c){
    sem_post(&c->sema);
}

void* consumidor(void* arg) {
    pthread_mutex_lock_casero(&cond);
    while (disponible == 0) {
        printf("Consumidor esperando...\n");
        pthread_cond_wait_casero(&cond);
    }
    printf("Consumidor consumió algo!\n");
    disponible = 0;
    pthread_mutex_unlock_casero(&cond);
    return NULL;
}

void* productor(void* arg) {
    pthread_mutex_lock_casero(&cond);
    disponible = 1;
    printf("Productor produjo algo!\n");
    pthread_cond_signal_casero(&cond);
    pthread_mutex_unlock_casero(&cond);
    return NULL;
}

int main() {
    pthread_t t1, t2;

    pthread_cond_init_casero(&cond);

    pthread_create(&t1, NULL, consumidor, NULL);
    sleep(1); // Asegura que el consumidor espere primero
    pthread_create(&t2, NULL, productor, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    return 0;
}
