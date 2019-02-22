
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



typedef struct {
    char buf[1];
    int bufSize;
    int input;
    int output;
    pthread_mutex_t mutex;
    pthread_cond_t condP;
    pthread_cond_t condC;
} buffer_t;

buffer_t buffer; // global buffer


int (*pred)(int); // predicate indicating number to be consumed

int produceT(buffer_t *b) {
    pthread_mutex_lock(&b->mutex);

    while (b->bufSize >= 1){
        pthread_cond_wait(&b->condC, &b->mutex); //Wait for 'condC' signal, WAIT if b->bufSize is greater than what is avaible. i.e. wait until it is decreased by consumer.
    }
    //---CRITICAL SECTION 
    scanf("%d",&pnum); //scan from file 
    assert(b->bufSize < 1); //if the value in b->bufSize condP than 1 throw an error  
    b->buf[b->input++] = pnum; //place the value in the buffer, provided there have been no errors 

    b->input = b->input % 1; //wrap back around. 
    b->bufSize++; //increment buffer array 
    //---END CRITICAL SECTION 
    pthread_cond_signal(&b->condP);
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
    while(b->bufSize <= 0){
        pthread_cond_wait(&b->condP, &b->mutex);
    }
    //---CRITICAL SECTION 
    if ( pred(pnum) ) { 
      csum += pnum; 
      }

    assert(b->bufSize > 0);
    pnum = b->buf[b->output++]; //Make pnum = to buffer value corresponding to output 
    b->output %= 1;
    b->bufSize--;
    //---END CRITICAL SECTION
    pthread_cond_signal(&b->condC);
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
  //INITIALISE all values of struct buffer
  buffer.bufSize = 0;
  buffer.input = 0;
  buffer.output = 0;
  pthread_mutex_init(&buffer.mutex, NULL);
  pthread_cond_init(&buffer.condP,NULL);
  pthread_cond_init(&buffer.condC,NULL);


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

  pthread_mutex_destroy(&buffer.mutex);
  pthread_cond_destroy(&buffer.condP);
  pthread_cond_destroy(&buffer.condC);
  return 0;
}
