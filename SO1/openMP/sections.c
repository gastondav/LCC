#include <stdio.h>
#include <omp.h>

int main(){
    int num = 4;

    #pragma omp parallel sections num_threads(num)
    {

    #pragma omp section 
    {
        printf("Thread id %d numthreads: %d seccion1\n",omp_get_thread_num(),omp_get_num_threads());
        
    }

    #pragma omp section
    {
        printf("Thread id %d numthreads: %d seccion2\n",omp_get_thread_num(),omp_get_num_threads());
    }

    }

    return 0;
}
