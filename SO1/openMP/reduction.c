#include <stdio.h>
#include <omp.h>

int main(){
    int sum = 0;
    int val = 1;
    #pragma omp parallel for reduction(+: sum)
        for (int i = 0; i < 100; i++)
        {
            sum = sum + val;
        }
        printf("sum: %d\n", sum);

}