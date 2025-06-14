#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

// Semáforos del agente
sem_t tabaco, papel, fosforos, otra_vez;

// Semáforos por fumador
sem_t puede_fumar[2];

// Mutex para detectar combinaciones
pthread_mutex_t mesa = PTHREAD_MUTEX_INITIALIZER;

void fumar(int i) {
    printf("Fumador %d: Puf! Puf! Puf!\n", i + 1);
    sleep(1);
}

void * fumador1(void *arg) { 
    while (1) { 
        sem_wait(&puede_fumar[0]);
        sem_wait(&tabaco);
        sem_wait(&papel);
        fumar(1); 
        sem_post(&otra_vez); 
    } 
}

void * fumador2(void *arg) { 
    while (1) { 
        sem_wait(&puede_fumar[1]);
        sem_wait(&fosforos); 
        sem_wait(&tabaco);
        fumar(2); 
        sem_post(&otra_vez); 
    } 
}

void * fumador3(void *arg) { 
    while (1) { 
        sem_wait(&puede_fumar[2]);
        sem_wait(&papel);
        sem_wait(&fosforos);  
        fumar(3); 
        sem_post(&otra_vez); 
    } 
}

void agente() { 
    while (1) { 
        sem_wait(&otra_vez); 
        int caso = random() % 3; 

        if (caso == 0){
            sem_post(&papel);
            sem_post(&tabaco); 
            sem_post(&puede_fumar[0]);
        }
        
        if (caso == 1){ 
            sem_post(&fosforos);
            sem_post(&tabaco);
            sem_post(&puede_fumar[1]); 
        }

        if (caso == 2){ 
            sem_post(&fosforos);
            sem_post(&papel); 
            sem_post(&puede_fumar[2]);
        }
    } 
}

int main() { 
    pthread_t s1, s2, s3; 
    sem_init(&tabaco, 0, 0);
    sem_init(&papel, 0, 0); 
    sem_init(&fosforos, 0, 0); 
    sem_init(&otra_vez, 0, 1); 

    pthread_create(&s1, NULL, fumador1, NULL); 
    pthread_create(&s2, NULL, fumador2, NULL); 
    pthread_create(&s3, NULL, fumador3, NULL); 

    agente(); 
    return 0; 
}