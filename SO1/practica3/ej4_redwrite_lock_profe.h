#ifndef READWRITE_LOCK_H
#define READWRITE_LOCK_H

#include <stdlib.h>
#include <pthread.h>

int lock_write();

int unlock_write();

int lock_read();

int unlock_read();

#endif