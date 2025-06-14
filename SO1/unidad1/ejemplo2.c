#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<fcntl.h>
#include<sys/stat.h>

int main(){
    char buff[1024];
    char path[]="./example.txt";
    int file = open(path, O_RDONLY);
    int num_read = read(file, buff, 1024);
    printf("%s\n",buff);
    return 0;   
}