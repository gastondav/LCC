#include <stdlib.h>
#include "ej4_readwrite_lock.h"

pthread_cond_t cond_not_escribiendo = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond_not_leyendo = PTHREAD_COND_INITIALIZER;  

int leyendo = 0; 
int escribiendo = 0;

int lock_write(pthread_mutex_t *mutexlector, pthread_mutex_t *mutexwriter){
    pthread_mutex_lock(mutexlector);
    while(leyendo){
        pthread_cond_wait(&cond_not_leyendo,mutexlector);
    }
    pthread_mutex_lock(mutexwriter);
    while(escribiendo){
        pthread_cond_wait(&cond_not_escribiendo,mutexwriter);
    }
    escribiendo++;

    return 0;
}


int unlock_write(pthread_mutex_t *mutexlector, pthread_mutex_t *mutexwriter){
    
    escribiendo = escribiendo-1;

    pthread_cond_broadcast(&cond_not_escribiendo);
    pthread_mutex_unlock(mutexlector);
    pthread_mutex_unlock(mutexwriter);

    return 0;    
}

int lock_read(pthread_mutex_t *mutexlector,pthread_mutex_t *mutexwriter){
    pthread_mutex_lock(mutexwriter);    
    while(escribiendo){
        pthread_cond_wait(&cond_not_escribiendo,mutexwriter);
    }
    pthread_mutex_lock(mutexlector);  
    leyendo++;
    pthread_mutex_unlock(mutexlector);  
    pthread_mutex_unlock(mutexwriter);

    return 0;
}

int unlock_read(pthread_mutex_t *mutexlector){
    pthread_mutex_lock(mutexlector);
    leyendo = leyendo-1;
    if(!leyendo) pthread_cond_signal(&cond_not_leyendo);
    pthread_mutex_unlock(mutexlector); 
    return 0;   
}
