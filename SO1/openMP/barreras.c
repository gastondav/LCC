#include <pthread.h>
#include <stdio.h>


pthread_barrier_t barrier;

void* thread_fun(void* arg){
    
    printf("Thread %d antes de la barrera\n", (int)arg);
    pthread_barrier_wait(&barrier);
    printf("Thread %d despues de la barrera\n", (int)arg);

}

int main(){
    pthread_barrier_init(&barrier,NULL,3);
    pthread_t thread[3];
    for(int i=0;i<3;i++){
        pthread_create(thread+i,NULL,thread_fun,(void*)(i+1));
    }
    for(int i=0;i<3;i++){
        pthread_join(thread[i],NULL);
    }

    return 0; 
}