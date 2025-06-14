#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <pthread.h> 
#include <semaphore.h>

sem_t tabaco, papel, fosforos, otra_vez;

void agente() { 
    while (1) { 
        sem_wait(&otra_vez); 
        int caso = random() % 3; 
        if (caso != 0) 
            sem_post(&fosforos); 
        
        if (caso != 1) 
            sem_post(&papel); 
        
        if (caso != 2) 
            sem_post(&tabaco); 
    } 
}

void fumar(int fumador) { 
    printf("Fumador %d: Puf! Puf! Puf!\n", fumador); 
    sleep(1);
}

void * fumador1(void *arg) { 
    while (1) { 
        sem_wait(&tabaco);
        if(sem_trywait(&papel) == -1)
            sem_post(&tabaco); 
        fumar(1); 
        sem_post(&otra_vez); 
    } 
}

void * fumador2(void *arg) { 
    while (1) { 
        sem_wait(&fosforos); 
        if(sem_trywait(&tabaco) == -1)  
            sem_post(&fosforos); 
        fumar(2); 
        sem_post(&otra_vez); 
    } 
}

void * fumador3(void *arg) { 
    while (1) { 
        sem_wait(&papel);
        if(sem_trywait(&fosforos) == -1)
            sem_post(&papel);  
        fumar(3); 
        sem_post(&otra_vez); 
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

/* 
a) 
Hay deadlock porque si bien el agente libera 2 recursos que deberian permitir a solo uno de los
fumadores fumar, si otro fumador toma antes el recurso evita que este pueda fumar y el que tomo
el recurso tampoco va a poder fumar porque los 2 recursos que libero el agente no son los que necesita,
ya que le sirve solo uno de los liberados

b)
Cada 2 fumadores necesitan 1 mismo recurso, luego los 2 van a competir por este recurso
supongamos que queremos evitar el deadlock, veo que necesita que por ejemplo 2 fumadores no pidan tabaco
primero

papel               fosforo            tabaco
Fumador1            Fumador2           Fumador3
tabaco              papel              fosforo
fosforo             tabaco             papel

Si bien aca cambiamos el orden y ninguno pide lo mismo que el otro primero, sigue habiendo deadlock,
ya que si agente libera por ejemplo fosforo y papel, fumador3 toma fosforo pero puede pasar que fumador 2
toma papel y tengo deadlock

c)

La solucion implemetada es usando sem_trywait() que devuelve -1 si no pudo disminuir el semaforo
con lo cual cuando el trywait fallo devuelve el recurso que ya habia tomado asi no el fumador no toma 
ningun recurso
*/

