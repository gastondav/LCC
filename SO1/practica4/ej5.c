#include <stdio.h>
#include <stdlib.h>
#include "timing.h"

#define N 1000

int A[N][N], B[N][N], C[N][N];

void mult_parallel(int A[N][N], int B[N][N], int C[N][N]){
    int i, j, k;
    
    #pragma omp parallel for
    for (i = 0; i < N; i++)
        #pragma omp parallel for
        for (j = 0; j < N; j++)
            #pragma omp parallel for
            for (k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];
}

void mult(int A[N][N], int B[N][N], int C[N][N]){
    int i, j, k;
    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++)
            for (k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];
}

int main(){
    int i, j;
    float time;

    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            A[i][j] = random() % 1000;
            B[i][j] = random() % 1000;
        }
    }

    TIME_void(mult(A, B, C),&time);

    TIME_void(mult_parallel(A, B, C),&time);


    return 0;
}

/* 
b)
for (k = 0; k < N; k++)
    C[i][j] += A[i][k] * B[k][j];

Vemos que cuando multiplico hago A[i][k] por lo cual accedo a posiciones en la misma fila
por lo que accedo a memoria contigua, mientras que en B[k][j] voy saltando filas con lo cual se pierde
tiempo buscando la posicion en memoria
Por lo tanto cambiar indices se puede mejorar el rendimiento

c)

Al hacer A * B^t se mejora el rendimiento pq hacemos 

C[i][j] = A[i][k] * B[j][k]

con lo cual tanto en A como en B me voy moviendo por la misma fila dentro del for con lo cual
es mas eficiente.
*/