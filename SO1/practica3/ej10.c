#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>


#define M 5
#define N 6

struct channel canal;

struct channel {
    sem_t lector,escritor,mutex; 
    int value;
};

void channel_init(struct channel *c){
    sem_init(&c->lector,0,0);
    sem_init(&c->escritor,0,1);
    sem_init(&c->mutex,0,0);
}

void chan_write(struct channel *c, int v){
    sem_wait(&c->escritor);
    c->value = v; 
    sem_post(&c->lector);

    sem_wait(&c->mutex);
    sem_post(&c->escritor);
}

int chan_read(struct channel *c){
    int v;

    sem_wait(&c->lector);
    v = c->value;
    sem_post(&c->mutex);

    return v;
}

void * prod_f(void *arg)
{
	int id = arg - (void*)0;
	int enviar;
    while (1) {
		sleep(random() % 3);

        enviar = random() % 100;
		chan_write(&canal,enviar);
		printf("Productor %d: produje %d\n", id, enviar);
	}
	return NULL;
}

void * cons_f(void *arg)
{
	int id = arg - (void*)0;
    int recibido;
	while (1) {
		sleep(random() % 3);

		recibido = chan_read(&canal);
		printf("Consumidor %d: obtuve %d\n", id, recibido);
	}
	return NULL;
}

int main()
{
	pthread_t productores[M], consumidores[N];
	int i;

    channel_init(&canal);   
    canal.value = -10000;

	for (i = 0; i < M; i++)
		pthread_create(&productores[i], NULL, prod_f, i + (void*)0);

	for (i = 0; i < N; i++)
		pthread_create(&consumidores[i], NULL, cons_f, i + (void*)0);

	pthread_join(productores[0], NULL); /* Espera para siempre */
	return 0;
}

/* 
 Como ventaja podemos mencionar que hay un sincronia entre consumidor y productor
 la desventaja es que solo puedo compartir un dato y baja concurrencia ya que ninguno hilo puede avanzar
 solo
*/