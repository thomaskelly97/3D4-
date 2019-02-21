
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

//Create mutex variable 
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; 
pthread_cond_t condc, condp; 

int (*pred)(int); // predicate indicating number to be consumed

int produceT() {

  scanf("%d",&pnum);
  return pnum;
  
}

void *Produce(void *a) {
  int p;
  p=1;
  pthread_mutex_lock(&mutex);
  while (p) {
    //pthread_mutex_lock(&mutex);
    //pthread_cond_wait(&condc,&mutex);
    printf("producer thinking...\n");
    sleep(1);
    printf("..done!\n");
    p = produceT();
    printf("PRODUCED %d\n",p);
    pthread_cond_signal(&condc);
    //pthread_mutex_unlock(&mutex);
    //pthread_cond_signal(&condc);
  }
  printf("EXIT-P\n");
  pthread_mutex_unlock(&mutex);
  pthread_cond_signal(&condc);
}


int consumeT() {
  pthread_mutex_lock(&mutex);
  if ( pred(pnum) ) { 
      csum += pnum; 
    }
  return pnum;
}

void *Consume(void *a) {
  int p;
  p=1;
  while (p) {
   //pthread_mutex_lock(&mutex);
    pthread_cond_wait(&condc,&mutex);

    printf("consumer thinking...\n");
    sleep(rand()%3);
    printf("..done!\n");
    p = consumeT();
    printf("CONSUMED %d\n",csum);

    pthread_cond_signal(&condp);
    sleep(1);
    //pthread_cond_signal(&condp);
    //pthread_mutex_unlock(&mutex);
  }
  printf("EXIT-C\n");
  pthread_mutex_unlock(&mutex);
}


int main (int argc, const char * argv[]) {
  // the current number predicate
  static pthread_t prod,cons;

  pthread_mutex_init (&mutex, 0); //initialise the mutex variable
	long rc;

  //This just checks which 'cond' you want to use 
  pred = &cond1;
  if (argc>1) {
    if      (!strncmp(argv[1],"2",10)) { pred = &cond2; }
    else if (!strncmp(argv[1],"3",10)) { pred = &cond3; }
  }


  pnum = 999;
  csum=0;
  srand(time(0));


  //CREATE THREADS 
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

  //JOIN THREADS 
	pthread_join( prod, NULL);
	pthread_join( cons, NULL);

  //
  printf("csum=%d.\n",csum);

  return 0;
}
