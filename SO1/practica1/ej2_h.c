#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdlib.h>

int main(){
    pid_t pid=fork();
    if(pid==0){
        printf("%d\n",getpid());
        sleep(20);
    }
    else{   
        printf("%d\n",getpid());
        sleep(20);
    }
    return 0;               
}