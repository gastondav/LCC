#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "timing.h"

#define size 500000000

double sum,sum2;
double* arr;

void suma_paralela(){
    #pragma omp parallel for reduction(+:sum)
        for(int i=0;i<size;i++){
            sum = sum+arr[i];
        }
}

void suma_secuencial(){
        for(int i=0;i<size;i++){
            sum2 = sum2+arr[i];
        }
}

int main(){
    arr=malloc(sizeof(double)*size);
    float time;

    sum=0,sum2=0;
    #pragma omp parallel for
        for(int i=0;i<size;i++){
            arr[i] = i;
        }
    
    TIME_void(suma_paralela(),&time);
    printf("La suma es: %f, se calculó en %f\n",sum,time);

    TIME_void(suma_secuencial(),&time);
    printf("La suma es: %f, se calculó en %f\n",sum2,time);



    return 0;
}