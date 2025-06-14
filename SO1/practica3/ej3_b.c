#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define SZ 8
#define M 5
#define N 5

/*
 * El buffer guarda punteros a enteros, los
 * productores los consiguen con malloc() y los
 * consumidores los liberan con free()
 */
int *buffer[SZ];

pthread_mutex_t productor = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t consumidor = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

pthread_cond_t cond_prod = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond_libre = PTHREAD_COND_INITIALIZER;

int producidos;
int libres;

void enviar(int *p)
{
    pthread_mutex_lock(&productor);
    libres--;
    while(libres == 0){
        pthread_cond_wait(&cond_libre, &productor);
    }
    //pthread_mutex_lock(&mutex);   CREO QUE NO ES NECESARIO
    for(int i=0; i < SZ; i++){
        if(buffer[i] == NULL){
            buffer[i] = p;
            i = SZ;
        }
    }
    //pthread_mutex_unlock(&mutex);
    producidos++;
    pthread_cond_signal(&cond_prod);
	pthread_mutex_unlock(&productor);
	return;
}

int * recibir()
{
	int* valor;
    pthread_mutex_lock(&consumidor);
    while(producidos == 0){
        pthread_cond_wait(&cond_prod, &consumidor);
    }
    producidos--;
    //pthread_mutex_lock(&mutex);
    for(int i=0; i < SZ; i++){
        if(buffer[i] != NULL){
            valor = buffer[i];
            buffer[i] = NULL;
            i=SZ;
        }
    }
    //pthread_mutex_unlock(&mutex);
    libres++;
    pthread_cond_signal(&cond_libre);
	pthread_mutex_unlock(&consumidor);
    return valor;
}

void * prod_f(void *arg)
{
	int id = arg - (void*)0;
	while (1) {
		sleep(random() % 3);

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
    producidos = 0;
    libres = SZ;

    for(int i=0; i < SZ;i++) 
        buffer[i] = NULL;

	for (i = 0; i < M; i++)
		pthread_create(&productores[i], NULL, prod_f, i + (void*)0);

	for (i = 0; i < N; i++)
		pthread_create(&consumidores[i], NULL, cons_f, i + (void*)0);

	pthread_join(productores[0], NULL); /* Espera para siempre */
	return 0;
}
