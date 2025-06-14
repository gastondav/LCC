#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define N_SILLAS 3
#define N_CLIENTES 10

int sillas_libres = N_SILLAS;

sem_t clientes;
sem_t barbero;
sem_t mutex_sillas;

sem_t sincroniza_cliente;
sem_t sincroniza_barbero;

void me_cortan(){
    printf("Cliente: me están cortando el pelo.\n"); 
}

void cortando(){ 
    printf("Barbero: cortando el pelo...\n"); 
    sleep(1); 
}

void pagando(){ 
    printf("Barbero: cobrando al cliente.\n"); 
}

void me_pagan() { 
    printf("Cliente: estoy pagando.\n"); 
}

void* cliente(void* arg) {
    int id = *(int*)arg;
    sleep(rand() % 3);  // Llega en un momento aleatorio

    printf("Cliente %d llega.\n", id);
    
    sem_wait(&mutex_sillas);

    if (sillas_libres > 0) {
        sillas_libres--;
        printf("Cliente %d se sienta. Sillas libres: %d\n", id, sillas_libres);
        sem_post(&clientes);  // avisa que hay un cliente
        sem_post(&mutex_sillas);

        sem_wait(&barbero);  // espera a ser llamado

        me_cortan(id);
        sem_wait(&sincroniza_barbero);
        sem_post(&sincroniza_cliente);
        me_pagan(id);
    }
    else {
        printf("Cliente %d se va. No hay sillas.\n", id);
        sem_post(&mutex_sillas);
    }

    return NULL;
}

void* barbero_f(void* arg) {
    while (1) {
        printf("Barbero: atendiendo a un cliente.\n");
        sem_wait(&clientes);  // duerme si no hay clientes
        sem_wait(&mutex_sillas);
        
        sillas_libres++;
        
        sem_post(&barbero);   // llama al cliente
        sem_post(&mutex_sillas);

        cortando();
        sem_post(&sincroniza_barbero);
        sem_wait(&sincroniza_cliente);
        pagando();
    }
    return NULL;
}

int main() {
    pthread_t clientes_t[N_CLIENTES], barbero_t;
    int ids[N_CLIENTES];

    srand(time(NULL));
    
    sem_init(&mutex_sillas, 0, 1);
    sem_init(&clientes, 0, 0);
    sem_init(&barbero, 0, 0);

    sem_init(&sincroniza_cliente, 0, 0);
    sem_init(&sincroniza_barbero, 0, 0);

    pthread_create(&barbero_t, NULL, barbero_f, NULL);

    for (int i = 0; i < N_CLIENTES; i++) {
        ids[i] = i + 1;
        pthread_create(&clientes_t[i], NULL, cliente, &ids[i]);
    }

    for (int i = 0; i < N_CLIENTES; i++) {
        pthread_join(clientes_t[i], NULL);
    }

    return 0;
}


/* 
Ayuda: semaforo inicializado en 0


2 semaforos en 0

llegoA,

llegoB,

Thread a

a1;
llegoA.post();
llegaB.wait();
a2;

Thread b

b1;
llegaA.wait();
llegoB.post();
b2;

a1 pase antes que b2 y que b1 pase antes que a2

*/

/* 
EXPLICACION:


*/


