#ifndef STACK_UNBOUND_H
#define STACK_UNBOUND_H

#include <stdlib.h>


struct StackNode {
    int data;
    struct StackNode* next;
};

typedef struct concurent_stack{
    struct StackNode* stack;
    pthread_mutex_t mutex;
}concurent_stack;


void concurrent_stack_init(concurent_stack* pila_concurente);

// A structure to represent a stack
// here we use a linked list to represent the unbound stack


concurent_stack* newNode(int data);
 
int isEmpty(concurent_stack* root);
 
void push(concurent_stack** root, int data);
 
int pop(concurent_stack** root);
 
int top(concurent_stack* root);

void stackFree(concurent_stack* root);

#endif /* CONCURRENT_STACK_H */