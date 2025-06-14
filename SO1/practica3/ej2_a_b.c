#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>

#define N_FILOSOFOS 5
#define ESPERA 500
pthread_mutex_t tenedor[N_FILOSOFOS];

pthread_mutex_t * izq(int i) {
    return &tenedor[i]; 
}

pthread_mutex_t * der(int i) { 
    return &tenedor[(i+1) % N_FILOSOFOS]; 
}


void pensar(int i){
    printf("Filosofo %d pensando...\n", i);
    usleep(random() % ESPERA);
}

void comer(int i){
    printf("Filosofo %d comiendo...\n", i);
    usleep(random() % ESPERA);
}

void tomar_tenedores(int i){
    if (i == 0){        
        pthread_mutex_lock(izq(i));
        pthread_mutex_lock(der(i));
    }
    else{
        pthread_mutex_lock(der(i));
        pthread_mutex_lock(izq(i)); 
    };
    
}

void dejar_tenedores(int i){
    pthread_mutex_unlock(der(i));
    pthread_mutex_unlock(izq(i));
}

void * filosofo(void *arg){
    int i = arg - (void*)0;
    while (1) {
    tomar_tenedores(i);
    comer(i);
    dejar_tenedores(i);
    pensar(i);
}

}

int main(){
    pthread_t filo[N_FILOSOFOS];
    int i;

    for (i = 0; i < N_FILOSOFOS; i++)
        pthread_mutex_init(&tenedor[i], NULL);

    for (i = 0; i < N_FILOSOFOS; i++)
        pthread_create(&filo[i], NULL, filosofo, i + (void*)0);
        pthread_join(filo[0], NULL);
    return 0;
}

/* 
a-

Puede terminar en deadlock si todos los filosofos toman un tenedor y se quedan esperando el otro que no
lo va a soltar nadie

b-

Llamemos 1 al filosofo que toma primero el tenedor izquierdo y 2 al filosofo que esta a su izquierda

Antes habia deadlock pq todos tomaban el tenedor derecho antes del izquiero, con lo cual si todos
tomaban el derecho se quedaban esperando a que el izquierdo este libre (y esto no pasaba nunca).
Ahora nunca va a pasar que todos tomen un tenedor ya que 1 y 2 compiten por el mismo tenedor 
y el que no llega a tomar el tenedor, no toma ninguno de los tenedores ni el derecho ni el izquierdo,
con lo cual tengo 5 tenedores para 4 filosofos, lo cual hace que siempre pueda comer uno.

*/