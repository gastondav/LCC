#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <pthread.h> 
#include <semaphore.h>

#define N 20
#define W 5
#define ITERS 100

float arr1[N], arr2[N]; 

// ------------------- BARRERA -------------------
struct barrier {
    pthread_mutex_t mutex;
    pthread_cond_t cond;
    int count; // cuántos llegaron
    int n;     // cuántos se esperan
};

void barrier_init(struct barrier *b, int n) {
    pthread_mutex_init(&b->mutex, NULL);
    pthread_cond_init(&b->cond, NULL);
    b->count = 0;
    b->n = n;
}

void barrier_wait(struct barrier *b) {
    pthread_mutex_lock(&b->mutex);
    b->count++;
    if (b->count < b->n) {
        pthread_cond_wait(&b->cond, &b->mutex);
    } else {
        b->count = 0; // reiniciar barrera para la próxima iteración
        pthread_cond_broadcast(&b->cond);
    }
    pthread_mutex_unlock(&b->mutex);
}
// ------------------------------------------------

void mostrar_barra(float *arr, const char *etiqueta) {
    printf("%s: ", etiqueta);
    for (int i = 0; i < N; i++)
        printf("%0.1f ", arr[i]);
    printf("\n");
}

void calor(float *arr, int lo, int hi, float *arr2) { 
    for (int i = lo; i < hi; i++) { 
        int m = arr[i]; 
        int l = i > 0 ? arr[i-1] : m; 
        int r = i < N-1 ? arr[i+1] : m; 
        arr2[i] = m + (l - m)/1000.0 + (r - m)/1000.0; 
    } 
}

int min(int a, int b) {
    return (a < b) ? a : b;
}

static inline int cut(int n, int i, int m) { 
    return i * (n/m) + min(i, n%m); 
} 

struct barrier b;

void *thr(void *arg) { 
    int id = (long)arg; // cast seguro si usás (void*)(long)i en create
    int lo = cut(N, id, W);
    int hi = cut(N, id + 1, W);

    for (int i = 0; i < ITERS; i++) {
        if (id == 0) mostrar_barra(arr1, "arr1");
        calor(arr1, lo, hi, arr2);
        barrier_wait(&b);
        
        if (id == 0) mostrar_barra(arr2, "arr2");
        calor(arr2, lo, hi, arr1);
        barrier_wait(&b); 
    }
    return NULL;
}

int main() {
    pthread_t hilos[W];

    for (int i = 0; i < N; i++){
        arr1[i] = random() % 100; 
    }

    barrier_init(&b, W);

    for (long i = 0; i < W; i++)
        pthread_create(&hilos[i], NULL, thr, (void*)i);

    for (int i = 0; i < W; i++)
        pthread_join(hilos[i], NULL);

    return 0;
}
