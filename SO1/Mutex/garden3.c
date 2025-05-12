#include <stdio.h>
#include <pthread.h>

#define NUM_VISITANTES 400000

int cant_vis = 0;

int flag[2] = {0,0};

void* molinete(void* cant){
    for(int i=0;i<NUM_VISITANTES/2;i++){
        //LOCK
        flag[0] = 1;
        while(flag[1]);
        //REGION CRITICA
        cant_vis++;
        //UNLOCK
        printf("m1: %d\n",cant_vis);
        flag[0] = 0;
    }
}

void* molinete2(void* cant){
    for(int i=0;i<NUM_VISITANTES/2;i++){
        //LOCK
        flag[1] = 1;
        while(flag[0]);
        //REGION CRITICA
        cant_vis++;
        //UNLOCK
        printf("m2: %d\n",cant_vis);
        flag[1] = 0;
    }
}

int main(){
    pthread_t t0,t1;

    pthread_create(&t0,NULL,molinete,NULL);
    pthread_create(&t1,NULL,molinete2,NULL);


    pthread_join(t0,NULL);
    pthread_join(t0,NULL);

    printf("Total visitantes: %d\n",cant_vis);

    return 0;  
}


