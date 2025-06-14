#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <assert.h>


int x = 0, y = 0, a = 0, b = 0;

void * foo(void *arg) { 
    x = 1; 
    a = y; 
    return NULL; 
}

void * bar(void *arg) { 
    y = 1; 
    b = x; 
    return NULL; 
}
 
int main() {
    pthread_t t0, t1;
    pthread_create(&t0, NULL, foo, NULL);
    pthread_join(t0, NULL);
    pthread_create(&t1, NULL, bar, NULL);   
    pthread_join(t1, NULL);
    assert (a || b);
    return 0;
}

/* 
    El assert puede fallar en algun caso de optimizacion del compilador.
    Por ejemplo, el compilador detecta que "y" no cambia en foo, y que "x" no cambia en bar, con lo cual
    puede hacer 
    a = y = 0 (ya que optimiza esta operacion pensando que "y" no va a cambiar)
    b = x = 0 (ya que optimiza esta operacion pensando que "x" no va a cambiar)

    Se puede arreglar el programa declarando x e y como volatile

*/