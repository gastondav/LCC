#include <stdio.h>
#include <pthread.h>

#define NUM_VISITANTES 40000000000

int cant_vis = 0;

pthread_mutex_t mutex_visitante = PTHREAD_MUTEX_INITIALIZER;

void* molinete(void* cant){
    for(int i=0;i<NUM_VISITANTES/2;i++){
        //LOCK
        pthread_mutex_lock(&mutex_visitante);
        //REGION CRITICA
        cant_vis++;
        //UNLOCK
        pthread_mutex_unlock(&mutex_visitante);
    }
}

void* molinete2(void* cant){
    for(int i=0;i<NUM_VISITANTES/2;i++){
        //LOCK
        pthread_mutex_lock(&mutex_visitante);
        //REGION CRITICA
        cant_vis++;
        //UNLOCK
        pthread_mutex_unlock(&mutex_visitante);
    }
}

int main(){
    pthread_t t0,t1;

    pthread_create(&t0,NULL,molinete,NULL);
    pthread_create(&t1,NULL,molinete2,NULL);


    pthread_join(t0,NULL);
    pthread_join(t1,NULL);

    pthread_mutex_destroy(&mutex_visitante);

    printf("Total visitantes: %d\n",cant_vis);

    return 0;  
}
