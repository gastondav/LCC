#ifndef READWRITE_LOCK_H
#define READWRITE_LOCK_H

#include <stdlib.h>
#include <pthread.h>

int lock_write(pthread_mutex_t *mutexl,pthread_mutex_t *mutexw);

int unlock_write(pthread_mutex_t *mutexl,pthread_mutex_t *mutexw);

int lock_read(pthread_mutex_t *mutexl,pthread_mutex_t *mutexw);

int unlock_read(pthread_mutex_t *mutexl);

#endif