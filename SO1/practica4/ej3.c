#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "timing.h"

#define size 500000000

double minimo;
double* arr;

void min_paralelo(){
    #pragma omp parallel for reduction(min: minimo) 
        for(int i=0;i<size;i++){
            if(minimo>arr[i]) minimo=arr[i]; 
        }
}

void min_secuencial(){
        for(int i=0;i<size;i++){
            if(minimo>arr[i]) minimo = arr[i];
        }
}

int main(){
    arr=malloc(sizeof(double)*size);
    float time;

    #pragma omp parallel for
        for(int i=0;i<size;i++){
            arr[i] = i;
        }
    
    minimo=arr[0];
    TIME_void(min_paralelo(),&time);
    printf("El minimo es: %f, se calculó en %f\n",minimo,time);

    minimo=arr[0];
    TIME_void(min_secuencial(),&time);
    printf("El minimo es: %f, se calculó en %f\n",minimo,time);



    return 0;
}