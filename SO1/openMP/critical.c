#include <stdio.h>
#include <omp.h>

#define N_VISITANTES 1000
int visitantes = 0;    


void molinete(void){
    for(int i=0;i<N_VISITANTES;i++)
    #pragma omp critical 
    {
        visitantes++;
    }
}

int main(){
    int nt = 2;
    #pragma omp parallel num_threads(nt)
    {
        molinete();
    }

    printf("Molinete: %d ",visitantes);
}