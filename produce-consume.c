// Producer-Consumer, based on  Oracle
// https://docs.oracle.com/cd/E19455-01/806-5257/6je9h032r/index.html

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "cond.c"

#define BSIZE 1

typedef struct {
    char buf[BSIZE];
    int occupied;
    int nextin;
    int nextout;
    pthread_mutex_t mutex;
    pthread_cond_t more;
    pthread_cond_t less;
} buffer_t;

buffer_t buffer; // global buffer

int (*pred)(int);

#define ITEM_COUNT 21
#define ITEM_START 0

// Producer core concurrent update behaviour
void produce(buffer_t *b, char item)
{
    pthread_mutex_lock(&b->mutex);

    while (b->occupied >= BSIZE)
        pthread_cond_wait(&b->less, &b->mutex);

    assert(b->occupied < BSIZE);

    b->buf[b->nextin++] = item;

    b->nextin %= BSIZE;
    b->occupied++;

    /* now: either b->occupied < BSIZE and b->nextin is the index
       of the next empty slot in the buffer, or
       b->occupied == BSIZE and b->nextin is the index of the
       next (occupied) slot that will be emptied by a consumer
       (such as b->nextin == b->nextout) */

    pthread_cond_signal(&b->more);

    pthread_mutex_unlock(&b->mutex);
}


// Consumer core concurrent update behaviour
char consume(buffer_t *b)
{
    char item;
    pthread_mutex_lock(&b->mutex);
    while(b->occupied <= 0)
        pthread_cond_wait(&b->more, &b->mutex);

    assert(b->occupied > 0);

    item = b->buf[b->nextout++];
    b->nextout %= BSIZE;
    b->occupied--;

    /* now: either b->occupied > 0 and b->nextout is the index
       of the next occupied slot in the buffer, or
       b->occupied == 0 and b->nextout is the index of the next
       (empty) slot that will be filled by a producer (such as
       b->nextout == b->nextin) */

    pthread_cond_signal(&b->less);
    pthread_mutex_unlock(&b->mutex);

    return(item);
}


// Produce Thread
// Produces a fixed number of items for the buffer.
void *Produce(void *a) {
  int c = ITEM_START;
  int i;

  for(i=0;i<ITEM_COUNT;i++) {
    produce(&buffer,c);
    printf("produced '%d'\n",c++);
  }
	pthread_exit(NULL);
}

//Consume Thread
//Consumes a fixed number of items from the buffer
void *Consume(void *a) {
  int c;
  int i;

  for(i=0;i<ITEM_COUNT;i++) {
    c = consume(&buffer);
    printf("consumed '%d'\n",c++);
  }
	pthread_exit(NULL);
}


int main (int argc, const char * argv[]) {
	static pthread_t prod,cons ;
	long rc;

  buffer.occupied = 0;
  buffer.nextin = 0;
  buffer.nextout = 0;
  pthread_mutex_init(&buffer.mutex, NULL);
  pthread_cond_init(&buffer.more,NULL);
  pthread_cond_init(&buffer.less,NULL);

  printf("Creating Producer:\n");
 	rc = pthread_create(&prod,NULL,Produce,(void *)0);
	if (rc) {
			printf("ERROR return code from pthread_create(prod): %ld\n",rc);
			exit(-1);
		}
  printf("Creating Consumer:\n");
 	rc = pthread_create(&cons,NULL,Consume,(void *)0);
	if (rc) {
			printf("ERROR return code from pthread_create(prod): %ld\n",rc);
			exit(-1);
		}

	pthread_join( prod, NULL);
	pthread_join( cons, NULL);

  printf("All Done!\n");

	return 0;
}
