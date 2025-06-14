int ben = 0;

void * helper(void* arg){

    ben+=1;

    pthread_exit(NULL);
}

void main(){
    pthread_t thread;
    pthread_creat(&thread, NULL, &helper, NULL)
    sched_yield();

    if (ben == 1)
        printf("Hola Mundo\n");
    else
        printf("Hasta luego\n");
}   