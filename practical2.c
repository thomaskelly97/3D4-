
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include "cond.c"

int pnum;  // number updated when producer runs.
int csum;  // sum computed using pnum when consumer runs.


#define BSIZE 6

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


int (*pred)(int); // predicate indicating number to be consumed

int produceT(buffer_t *b) {
    pthread_mutex_lock(&b->mutex);

    while (b->occupied >= BSIZE)
        pthread_cond_wait(&b->less, &b->mutex);

    scanf("%d",&pnum);
    assert(b->occupied < BSIZE);

    b->buf[b->nextin++] = pnum;

    b->nextin %= BSIZE;
    b->occupied++;

    pthread_cond_signal(&b->more);

    pthread_mutex_unlock(&b->mutex);

    return pnum;
}

void *Produce(void *a) {
  int p;

  p=1;
  while (p) {
    printf("producer thinking...\n");
    sleep(1);
    printf("..done!\n");
    p = produceT(&buffer);
    printf("PRODUCED %d\n",p);
  }
  printf("EXIT-P\n");
}


int consumeT(buffer_t *b) {
  pthread_mutex_lock(&b->mutex);
    while(b->occupied <= 0)
        pthread_cond_wait(&b->more, &b->mutex);

    if ( pred(pnum) ) { csum += pnum; }
    assert(b->occupied > 0);

    pnum = b->buf[b->nextout++];
    b->nextout %= BSIZE;
    b->occupied--;
    pthread_cond_signal(&b->less);
    pthread_mutex_unlock(&b->mutex);
  return pnum;
}

void *Consume(void *a) {
  int p;
  p=1;
  while (p) {
    printf("consumer thinking...\n");
    sleep(rand()%3);
    printf("..done!\n");
    p = consumeT(&buffer);
    printf("CONSUMED %d\n",csum);
  }
  printf("EXIT-C\n");
}


int main (int argc, const char * argv[]) {
  // the current number predicate
  static pthread_t prod,cons;
	long rc;
  buffer.occupied = 0;
  buffer.nextin = 0;
  buffer.nextout = 0;
  pthread_mutex_init(&buffer.mutex, NULL);
  pthread_cond_init(&buffer.more,NULL);
  pthread_cond_init(&buffer.less,NULL);


  pred = &cond1;
  if (argc>1) {
    if      (!strncmp(argv[1],"2",10)) { pred = &cond2; }
    else if (!strncmp(argv[1],"3",10)) { pred = &cond3; }
  }

  pnum = 999;
  csum=0;
  srand(time(0));

  printf("Creating Producer:\n");
 	rc = pthread_create(&prod,NULL,Produce,(void *)0);
	if (rc) {
			printf("ERROR return code from pthread_create(prod): %ld\n",rc);
			exit(-1);
		}
  printf("Creating Consumer:\n");
 	rc = pthread_create(&cons,NULL,Consume,(void *)0);
	if (rc) {
			printf("ERROR return code from pthread_create(cons): %ld\n",rc);
			exit(-1);
		}

	pthread_join( prod, NULL);
	pthread_join( cons, NULL);

  printf("csum=%d.\n",csum);

  return 0;
}
