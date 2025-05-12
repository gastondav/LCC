#include <stdio.h>
#include <pthread.h>

#define NUM_VISITANTES 400000

int cant_vis = 0;
//int flag = 0 ; //0 si RC libre 1 sino
int turno = 0; //0 sin turno turno es 1 molinete1 | 2 molinete2 


void* molinete(void* cant){
    for(int i=0;i<NUM_VISITANTES/2;i++){
        //LOCK
        turno = 2;
        while(turno == 2);
        //REGION CRITICA
        cant_vis++;
        //UNLOCK
        printf("m1: %d\n",cant_vis);
        turno = 2;
    }
}

void* molinete2(void* cant){
    for(int i=0;i<NUM_VISITANTES/2;i++){
        //LOCK
        turno = 1;
        while(turno == 1);
        //REGION CRITICA
        cant_vis++;
        //UNLOCK
        printf("m2: %d\n",cant_vis);
        turno = 1;
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


