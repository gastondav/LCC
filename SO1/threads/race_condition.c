#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <fcntl.h>

// void characterAtTime(char* str) {
//     setbuf(stdout, NULL);
//     char *ptr;
//     int c;
//     for (ptr = str;(c = *ptr++) != 0;)
//     {
//         putc(c, stdout);
//     }
    
// }

char seek_read(off_t pos, int fd){
    
    char resC;
    //SECCION CRITICA 
    lseek(fd, pos, SEEK_SET);
    int res = read(fd, &resC, 1);
    //SECCION CRITICA
    return resC;
}


void seek_write(off_t pos, int fd, const char c){
    
    
    lseek(fd, pos, SEEK_SET);

    int res = write(fd, &c, 1);


    return;
}

int main(){


    int fd = open("./file.txt", O_RDWR);


    pid_t pid;

    pid = fork();

    if (pid == 0) {
        char c = seek_read(fd, 13);
        
        printf("child leyo: %c\n", c);
        seek_write(fd, 13, 'a');
    
    }
    else {
        char c = seek_read(fd, 13);
        
        printf("parent leyo: %c\n", c);
        seek_write(fd, 13, 'a');
    }

    close(fd);
    return 0;
}