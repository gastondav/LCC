#include <stdio.h>
#include <pthread.h>
#include <omp.h>
#include "timing.h"

#define size 1000

void qsort(int a[], int N);

struct qarg{
    int* a;
    int n;
};


void swap(int* a,int* b){
    int t = *a;
    *a = *b;
    *b = t;
}

/* Particion de Lomuto, tomando el primer elemento como pivote */
int particionar(int a[], int n){
    int i, j = 0;
    int p = a[0];
    swap(&a[0], &a[n-1]);
    for (i = 0; i < n-1; i++) {
        if (a[i] <= p)
        swap(&a[i], &a[j++]);
    }
    swap(&a[j], &a[n-1]);
    return j;
}

void qsort(int a[], int N){
    pthread_t t1,t2;
    if (N < 2) return;

    int p = particionar(a, N);
    struct qarg argumento1,argumento2;

    #pragma omp parallel sections
    {
        #pragma omp section
        {
            qsort(a, p);
        }
        #pragma omp section
        {
            qsort(a + p + 1, N - p - 1);
        }
    }
}

void imprimir_arreglo(int a[]){
    for(int i=0; i < size; i++){
        printf("%d ",a[i]);
    }
}

void completar_arreglo(int a[]){
    for(int i=0;i<size;i++){
        a[i] = size-i;
    }
}

int main(){
    int arr[size];
    float time;

    completar_arreglo(arr);
    //imprimir_arreglo(arr);

    TIME_void(qsort(arr,size),&time);

    printf("\nSorteado:\n");
    //imprimir_arreglo(arr);

    return 0;
}