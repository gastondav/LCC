#include <pthread.h>
#include "ej4_redwrite_lock_profe.h"

/* protegido por mutex */
int cont_lectores;
int cont_escritores;

pthread_mutex_t mutex_lectores = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_escritores = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t no_lectores = PTHREAD_COND_INITIALIZER;
pthread_cond_t no_escritores = PTHREAD_COND_INITIALIZER;

int lock_read(){
    pthread_mutex_lock(&mutex_escritores);
    while(cont_escritores)
        pthread_cond_wait(&no_escritores,&mutex_escritores);
    pthread_mutex_lock(&mutex_lectores);    
    cont_lectores++;
    pthread_mutex_unlock(&mutex_lectores);
    pthread_mutex_unlock(&mutex_escritores);
    return 0;
}

int lock_write(){
    pthread_mutex_lock(&mutex_escritores);
    while(cont_escritores)
        pthread_cond_wait(&no_escritores,&mutex_escritores);
    pthread_mutex_lock(&mutex_lectores);    
    while(cont_lectores)
        pthread_cond_wait(&no_lectores, &mutex_lectores);
    cont_escritores++;
    
    pthread_mutex_unlock(&mutex_lectores);
    pthread_mutex_unlock(&mutex_escritores);
    return 0;
}

int unlock_read(){
    pthread_mutex_lock(&mutex_lectores);    
    cont_lectores--;
    if(cont_lectores == 0)
        pthread_cond_signal(&no_lectores);
    pthread_mutex_unlock(&mutex_lectores);
    return 0;
}

int unlock_write(){
    pthread_mutex_lock(&mutex_escritores);
    if(cont_escritores)
        cont_escritores--;
    if(cont_escritores == 0)
        pthread_cond_broadcast(&no_escritores);
    pthread_mutex_unlock(&mutex_escritores);
    return 0;
}