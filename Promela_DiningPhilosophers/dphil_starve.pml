
#define NUM 5 /* Number of philosophers, and forks! */

/* We want to record which philosopher is holding which fork */
/*  fork[NUM][NUM] where fork[p][f] is true if 'p' holds 'f' */

bool Fork[NUM*NUM] = {0}; /* 2-d arrays not supported, so ... */
int i = 0; 

#define FORK(p,f) Fork[NUM*p+f]
#define leftFork(p) (p%NUM)
#define rightFork(p) ((p+1)%NUM)
#define myForkOnly(p,f) !(    FORK(((p+1)%NUM),f) \
                           || FORK(((p+2)%NUM),f) \
                           || FORK(((p+3)%NUM),f) \
                           || FORK(((p+4)%NUM),f) )



active [NUM] proctype phil()
{ int p, lfork, rfork ;
  p = _pid;
  lfork = leftFork(p);
  rfork = rightFork(p);

  think: printf("P%d thinks..\n",_pid);
  firstfork:  
    atomic {
      if
      :: (FORK(p,lfork) == 0) -> FORK(p,lfork) = true; printf("P%d picked up F%d\n", p, lfork); 
      fi 
    }

  secondfork: 
    atomic {
      if
      ::(FORK(p,lfork) == 0) -> FORK(p,rfork) = true; printf("P%d picked up F%d\n", p, rfork);
      fi 
    } 

  assert(myForkOnly(p,lfork));
  assert(myForkOnly(p,rfork));
  progress_eat: printf("P%d eats!\n",_pid);


  dropfork1: FORK(p,lfork) = false;
  printf("P%d DROPS F%d\n", p, FORK(p,lfork));
  dropfork2: FORK(p,rfork) = false;
  printf("P%d DROPS F%d\n", p, FORK(p,rfork));
  goto think
}