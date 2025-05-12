// C program for linked list implementation of stack
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "stack_unbound.h"

pthread_mutex_t mutex_stack = PTHREAD_MUTEX_INITIALIZER;

// source: https://www.geeksforgeeks.org/stack-data-structure-introduction-program/
 
concurent_stack* newNode(int data)
{
    concurent_stack* pila=malloc(sizeof(concurent_stack));
    pila->mutex=mutex_stack;
    struct StackNode* stackNode = (struct StackNode*) malloc(sizeof(struct StackNode));
    stackNode = data;
    stackNode->next = NULL;
    pila->stack=stackNode;
    return pila;
}
 
int isEmpty(concurent_stack* root)
{
    return !(root->stack);
}
 
void push(concurent_stack** root, int data)
{
    pthread_mutex_lock(&(*root)->mutex);    
    struct StackNode* stackNode = newNode(data);

    stackNode->next = (*root)->stack;
    
    (*root)->stack = stackNode;
    pthread_mutex_unlock(&(*root)->mutex);
}
 
int pop(concurent_stack** root)
{
    if (isEmpty((*root)))
        return INT_MIN;
    struct StackNode* temp = (*root)->stack;
    (*root)->stack = (*root)->stack->next;
    int popped = temp->data;
    free(temp);
 
    return popped;
}
 
int top(struct StackNode* root)
{
    if (isEmpty(root))
        return INT_MIN;
    return root->data;
}

void stackFree(struct StackNode* root)
{
  // we free the stack just popping all the elements
  while(!isEmpty(root))
  {
	  pop(&root);
  }
}
