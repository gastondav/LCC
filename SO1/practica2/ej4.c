#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <assert.h>

volatile int x = 0;
volatile int y = 0;
pthread_mutex_t a = PTHREAD_MUTEX_INITIALIZER;

void * wr(void *arg) { 
    pthread_mutex_lock(&a);
    x = 123; 
    y = 1;
    pthread_mutex_unlock(&a); 
}

void * rd(void *arg) {
    while (!y);
    assert(x == 123);;
}

int main() {
    pthread_t t1, t0;
    pthread_create(&t1, NULL, wr, NULL);
    pthread_create(&t0, NULL, rd, NULL);   
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);

    return 0;
}

/* 
    El programa puede fallar por reordenamiento, ya que si se hace por ejemplo
    reordenamiento
    y = 1 (antes que x = 123)
    cambio de contexto
    ejecuto rd
    salfo del while
    hago el assert (x == 123) donde x = 0
    tengo error
    Se puede solucionar haciendo un mutex al ingresar en wr

*/
