#include<pthread.h>
#include <stdio.h>
#include<stdlib.h>
#include<semaphore.h>

pthread_mutex_t mutex=PTHREAD_MUTEX_INITIALIZER;
//pthread_cond_t hay_lugar=PTHREAD_COND_INITIALIZER;
//pthread_cond_t hay_algo=PTHREAD_COND_INITIALIZER;
sem_t lugares_libres_sem,lugares_ocupados_sem;

/* Producer/consumer program illustrating conditional variables */

/* Size of shared buffer */
#define BUF_SIZE 20

int buffer[BUF_SIZE];					/* shared buffer */
int add=0;										/* place to add next element */
int rem=0;										/* place to remove next element */
int num=0;										/* number elements in buffer */

/* Produce value(s) */
void *producer(void *param)
{
	int i;
	for (i=1; i<=2000; i++) {

        sem_wait(&lugares_libres_sem);

		pthread_mutex_lock(&mutex);

		/* Insert into buffer */
		if (num > BUF_SIZE){
			printf("Overflow\n"); fflush(stdout);
			exit(1);}	/* overflow */

		/* if executing here, buffer not full so add element */
		buffer[add] = i;
		add = (add+1) % BUF_SIZE;
		num++;
    printf ("producer: inserted %d\n", i);  fflush (stdout);
	
	pthread_mutex_unlock(&mutex);
    sem_post(&lugares_ocupados_sem);
	}
	printf ("producer quiting\n");  fflush (stdout);
}

/* Consume value(s); Note the consumer never terminates */
void *consumer(void *param)
{
	int i;
	while (1) {
		sem_wait(&lugares_ocupados_sem);
        pthread_mutex_lock(&mutex);
		
		if (num < 0){
			printf("Underflow\n"); fflush(stdout);
			exit(1); 
		}   /* underflow */

		/* if executing here, buffer not empty so remove element */
		i = buffer[rem];
		rem = (rem+1) % BUF_SIZE;
		num--;
    printf ("Consume value %d\n", i);  fflush(stdout);
	
	pthread_mutex_unlock(&mutex);
    sem_post(&lugares_libres_sem);
	}
}

int main (int argc, char *argv[])
{
	pthread_t tid1, tid2;		/* thread identifiers */
	int i;
    sem_init(&lugares_libres_sem,0,BUF_SIZE);
    sem_init(&lugares_ocupados_sem,0,0);
	/* create the threads; may be any number, in general */
	if (pthread_create(&tid1,NULL,producer,NULL) != 0) {
		fprintf (stderr, "Unable to create producer thread\n");
		exit (1);
	}
	if (pthread_create(&tid2,NULL,consumer,NULL) != 0) {
		fprintf (stderr, "Unable to create consumer thread\n");
		exit (1);
	}
	/* wait for created thread to exit */
	pthread_join(tid1,NULL);
	pthread_join(tid2,NULL);
	printf ("Parent quiting\n");
	return 0;
}