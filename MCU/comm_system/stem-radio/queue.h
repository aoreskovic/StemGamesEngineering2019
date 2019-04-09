#ifndef _QUEUE_H_
#define _QUEUE_H_

#include <stdlib.h>
#include <stdio.h>

typedef struct _queue_t queue_t;

typedef char q_type;

struct _queue_t {
    int size;
    int front;
    int rear;
    char *data;
};

queue_t *queue_init ( int size );
void queue_enqueue ( queue_t *q, char ch );
char queue_dequeue ( queue_t *q );
queue_t *queue_resize ( queue_t *q_old, size_t new_size );
int queue_isfull ( queue_t *q );
int queue_isempty ( queue_t *q );
void print_queue (queue_t *q );


#endif /* end of include guard: _QUEUE_H_  */
