#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>

int denom = 0; 

void handler(int s) { 
    printf("ouch!\n"); 
    denom = 1; 
} 

int main() { 
    int r; 
    signal(SIGFPE, handler); 
    r = 1 / denom; 
    printf("r = %d\n", r); 
    return 0; 
}

/* 
    Lo que pasa al correr el programa es que imprime infinitamente ouch!
   Esto se debe a que cuando se hace la division por cero el valor de denom = 0 esta guardado en un registro
   pero al cambiar este valor en el handler la compu hace optimizaciones que hacen que al cambiar este valor
   se cambie el valor de denom en memoria, pero el registro para hacer la operacion r = 1 / denom y 
   que tiene el valor de denom no es modificado, con lo cual la operacion vuelve a hacerse con el valor de 
   denom = 0 

*/