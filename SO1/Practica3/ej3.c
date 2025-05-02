#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define M 5
#define N 5
#define SZ 8

/*
 * El buffer guarda punteros a enteros, los
 * productores los consiguen con malloc() y los
 * consumidores los liberan con free()
 */
int *buffer[SZ];

sem_t semaforo;

void inicial_buffer(){
    for(int i=0; i < SZ;i++)
        buffer[i] = NULL;
}

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void enviar(int *p)
{
    pthread_mutex_lock(&mutex);
    for(int i=0; i < SZ; i++){
        if(buffer[i] == NULL){
            buffer[i] = p;
            i = SZ;
            free(p);
        }
    }
	pthread_mutex_unlock(&mutex);
    return;
}

int * recibir()
{
    int* valor;
	pthread_mutex_lock(&mutex);
    for(int i=0; i < SZ; i++){
        if(buffer[i] != NULL){
            valor = buffer[i];
            buffer[i] = NULL;
        }
    }
	pthread_mutex_unlock(&mutex);
	return valor;
}

void * prod_f(void *arg)
{
	int id = arg - (void*)0;
	while (1) {
		sleep(random() % 3);
        sem_post(&semaforo);
		int *p = malloc(sizeof *p);
		*p = random() % 100;
		printf("Productor %d: produje %p->%d\n", id, p, *p);
		enviar(p);
	}
	return NULL;
}

void * cons_f(void *arg)
{
	int id = arg - (void*)0;
	while (1) {
		sleep(random() % 3);
        sem_wait(&semaforo);

		int *p = recibir();
		printf("Consumidor %d: obtuve %p->%d\n", id, p, *p);
		free(p);
        
	}
	return NULL;
}

int main()
{
	pthread_t productores[M], consumidores[N];
	int i;

    inicial_buffer();

    sem_init(&semaforo, 0, SZ-1);

	for (i = 0; i < M; i++)
		pthread_create(&productores[i], NULL, prod_f, i + (void*)0);

	for (i = 0; i < N; i++)
		pthread_create(&consumidores[i], NULL, cons_f, i + (void*)0);

	pthread_join(productores[0], NULL); /* Espera para siempre */
	return 0;
}