#include <pthread.h>
#include "ej4_redwrite_lock_profe.h"
/* protegido por mutex */

int cont_lectores;
pthread_mutex_t mutex_cont = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_int = PTHREAD_MUTEX_INITIALIZER;

int lock_read(){
    pthread_mutex_lock(&mutex_cont);
    if(cont_lectores == 0)
        pthread_mutex_lock(&mutex_int);
    cont_lectores++;
    pthread_mutex_unlock(&mutex_cont);
    return 0;
}

int lock_write(){
    pthread_mutex_lock(&mutex_int);
    return 0;
}

int unlock_read(){
    pthread_mutex_lock(&mutex_cont);
    cont_lectores--;
    if(cont_lectores == 0)
        pthread_mutex_unlock(&mutex_int);
    pthread_mutex_unlock(&mutex_cont);
    return 0;
}

int unlock_write(){
    pthread_mutex_unlock(&mutex_int);
    return 0;
}