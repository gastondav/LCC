#include<stdio.h>
#include<unistd.h>

int main(){
    printf("pid: %d\n",getpid());
    const char* prog="./ejemplo";
    execl(prog,prog,NULL);
    return 0;
}
