#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "timing.h"
#include <math.h>

long int num;
long int size;
int cond;

void primo_paralelo(){
    volatile int found = 0;

    #pragma omp parallel shared(found)
    {
        #pragma omp for
        for(long int i = 2; i <= size; i++){
            if(num % i == 0 && !found){
                #pragma omp atomic write
                found = 1;
                #pragma omp cancel for
            }
            #pragma omp cancellation point for
        }
    }
    cond = !found;
}


void primo_secuencial(){
 
    for(int i=2;i <= size;i++){
            if(num % i == 0){
                cond = 0;
                i = size;
            } 
        }
}

int main(){
    //num = 10101;
    num = 32416190071;
    float time;
    size = round(sqrt(num));

    cond = 1;
    TIME_void(primo_paralelo(),&time);
    printf("El numero es primo: %d, se calculó en %f\n",cond,time);
   
    cond = 1;
    TIME_void(primo_secuencial(),&time);
    printf("El numero es primo: %d, se calculó en %f\n",cond,time);

    return 0;
}