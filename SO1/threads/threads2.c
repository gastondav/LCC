#include <pthread.h>
#include <stdio.h>
#include<unistd.h>

void* function(void* v){
    printf("thread v: %d\n",*(int*)v);
    
    sleep(2);
    
    pthread_exit(0);//NO HACE FALTA
    //return NULL;
}

//compilar con flag -pthread
int main(){
    pthread_t id;
    int v =2;
    
    printf("Main creating thread\n");
    
    pthread_create(&id, NULL, function, &v);
    //Crea el thread pero no hay cambio de contexto
    //sleep(1);
    //con el sleep mando a dormir el proceso main y fuerzo que se corra el otro thread
    int * ptr; // para leer el estado en elque termino el thread
    
    printf("Main joinning\n");
    
    pthread_join(id, (void**)&ptr);
    
    printf("ptr %p\n",ptr);
    
    printf("Main running...\n");
    return 0;
}