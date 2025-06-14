#include<stdio.h>
#include<unistd.h>
#include<signal.h>
#include<stdlib.h>

void handler_zero_division(int signa){
        printf("DIVISION POR 0\n");
        exit(0);
}

int main(){
    void(*signareturn)(int);
    signareturn=signal(SIGFPE,handler_zero_division);
    int a=1;
    int b=0;
    int res=1/0;
    printf("%d\n",res);
    return 0;
}
