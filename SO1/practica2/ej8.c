#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <pthread.h>

#define N 40
int visitantes = 0;

void * proc1(void *arg) { 
    int i; 
    int id = arg- (void*)0; 
    for (i = 0; i < N; i++) { 
        int c; 
        /* sleep? */ 
        c = visitantes; 
        sleep(0.1);
        /* sleep? */ 
        visitantes = c + 1; 
        /* sleep? */ 
    } 
    return NULL; 
}


void * proc2(void *arg) { 
    int i; 
    int id = arg- (void*)0; 
    for (i = 0; i < N; i++) { 
        int c; 
        /* sleep? */ 
        c = visitantes; 
        /* sleep? */ 
        sleep(0.1);
        visitantes = c + 1;
        /* sleep? */ 
    } 
    return NULL; 
}

int main() {
    pthread_t t1, t0;
    pthread_create(&t1, NULL, proc1, NULL);
    pthread_create(&t0, NULL, proc2, NULL);   
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    printf("El numero de vistantes es: %d\n", visitantes);
    return 0;
}

/* 
    El sleep tiene que ir en el medio para tener el minimo valor posible ya que, con el sleep
    hago que un hilo guarde el valor de visitante en c y luego con el sleep fuerzo el cambio de contexto,
    mientras en el otro hilo vuelvo a guardar el mismo valor de vistante en el otro c, con lo pierdo 
    siempre pierdo una suma
*/