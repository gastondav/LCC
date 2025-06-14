#include <stdio.h>
#include <omp.h>

int main(){
    int i = 10;
    
    #pragma omp parallel private(i) //cada trhead hace una copia de i y queda privada para este 
    {
        // variable i is not initialized
        printf("thread %d: i = %d\n", omp_get_thread_num(), i);
        i = 1000;
        printf("private interna i: %d\n",i);
    }

    printf("private i = %d\n", i); //vale lo de la global
}