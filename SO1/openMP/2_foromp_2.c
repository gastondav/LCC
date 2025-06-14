#include <stdio.h>
#include <omp.h>


int main(){
    int a[100000];
    #pragma omp parallel
    {
        #pragma omp for
        for (int i = 0; i < 100000; i++){
            a[i] = 2 * i;
            printf("Thread %d, numero: %d\n",omp_get_thread_num(),a[i]);
        }
    }
}