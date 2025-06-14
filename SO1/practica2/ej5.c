#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <pthread.h>

#define NUM_VISITAS 400000
int visitantes = 0;
int flag1 = 0;
int flag2 = 0;
int turno;

void * hilo1(void *arg) { 
    for(int i = 0; i < NUM_VISITAS / 2; i++){
        flag1 = 1;   
        turno = 2;
        __sync_synchronize(); 
        while(turno == 2 && flag2 == 1);
        visitantes = 1 + visitantes;
        flag1 = 0;
    }
}

void * hilo2(void *arg) {
    for(int i = 0; i < NUM_VISITAS / 2; i++){
        flag2 = 1; 
        turno = 1;
        __sync_synchronize(); 
        while(turno == 1 && flag1 == 1);
        visitantes = 1 + visitantes;
        flag2 = 0;
    }
}

int main() {
    pthread_t t1, t0;
    pthread_create(&t1, NULL, hilo1, NULL);
    pthread_create(&t0, NULL, hilo2, NULL);   
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    printf("El numero de vistantes es: %d\n", visitantes);
    return 0;
}
