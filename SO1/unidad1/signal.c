#include<stdio.h>
#include<unistd.h>
#include<signal.h>
#include<stdlib.h>

/*
se sigue con fg

int main(){
    raise(SIGSTOP);
    
    printf("Chau\n");
    return 0;
}
*/
/* usar CONTROL+Z para pausar y despues fg para continuar
int main(){
    printf("QUE\n");
    sleep(3);
    printf("listo\n");
    return 0;
}
*/

void handler_zero_division(int signa){
        printf("Me estropearon\n");
        exit(0);
}

int main(){
    void(*signareturn)(int);
    signareturn=signal(SIGSTOP,handler_zero_division);
    printf("%d\n",getpid());
    raise(SIGSTOP);
    printf("%d\n",3);
    return 0;
}