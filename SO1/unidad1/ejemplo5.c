#include<stdio.h>
#include<signal.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

void handler_child(int sig){
    printf("Me mandaron la señal");
}

int main(){
    pid_t pid=fork();
    if(pid==0){
        struct sigaction sa;
        sa.sa_handler = handler_child;
        sa.sa_flags = SA_RESTART;
        sigaction(SIGINT,&sa,NULL);

    }
    else{
        sleep(1);
        kill(pid,SIGINT);
        wait(NULL);
    }
    printf("Quien llego %d\n",getpid());
    return 0;
}
