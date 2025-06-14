#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#define NUM_VISITANTES 40000000000

int cant_vis = 0;
int cant_vis2 =0;

pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex2 = PTHREAD_MUTEX_INITIALIZER;


void* thread_a(void* cant){
        //LOCK
        pthread_mutex_lock(&mutex2);
        printf("ThreadA mutex2\n");
        sleep(1);
        printf("ThreadA esperando recurso1\n");
        pthread_mutex_lock(&mutex1);
        //REGION CRITICA
        printf("Region crítica de thread A\n");
        //UNLOCK
        pthread_mutex_unlock(&mutex1);
        pthread_mutex_unlock(&mutex2);

}

void* thread_b(void* cant){
        //LOCK
        pthread_mutex_lock(&mutex1);
        printf("ThreadB mutex1\n");
        sleep(1);
        printf("ThreadB esperando recurso2\n");
        pthread_mutex_lock(&mutex2);
        //REGION CRITICA
        printf("Region crítica de thread b\n");
        //UNLOCK
        pthread_mutex_unlock(&mutex2);
        pthread_mutex_unlock(&mutex1);
}

int main(){
    pthread_t t0,t1;

    pthread_create(&t0,NULL,thread_a,NULL);
    pthread_create(&t1,NULL,thread_b,NULL);


    pthread_join(t0,NULL);
    pthread_join(t1,NULL);

    pthread_mutex_destroy(&mutex1);
    pthread_mutex_destroy(&mutex2);


    printf("Total visitantes: %d\n",cant_vis);

    return 0;  
}
