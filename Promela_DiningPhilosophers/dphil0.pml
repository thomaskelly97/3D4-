
#define NUM 5 /* Number of philosophers, and forks! */

/* We want to record which philosopher is holding which fork */
/*  fork[NUM][NUM] where fork[p][f] is true if 'p' holds 'f' */

bool Fork[NUM*NUM]; /* 2-d arrays not supported, so ... */

#define FORK(p,f) Fork[NUM*p+f] //
#define leftFork(p) (p%NUM)
#define rightFork(p) ((p+1)%NUM)
#define myForkOnly(p,f) !(    FORK(((p+1)%NUM),f) \
                           || FORK(((p+2)%NUM),f) \
                           || FORK(((p+3)%NUM),f) \
                           || FORK(((p+4)%NUM),f) )

init {
  atomic {
    int i=0; 
    do
    ::if 
      ::(i==24) ->
        break; 
      fi 
    printf("-%d-", Fork[i]);
    Fork[i] = 0; 
    od;  
  }
}

active [NUM] proctype phil()
{ int p, lfork, rfork,i ;
  p = _pid;
  lfork = leftFork(p);
  rfork = rightFork(p);

  
  think: printf("P%d thinks..\n",_pid); 

  firstfork:
    atomic{
      printf("P%d, F%d => %d\n", _pid, lfork, FORK(p,lfork));
        if
        ::(FORK(p%NUM,lfork) == 0 && FORK((p-1)%NUM,lfork) == 0) -> //if the fork is not picked up 
          ::FORK(p,lfork) = 1; //pick up the fork 
          ::printf("P%d picks up fork F%d\n", _pid, lfork); 
        fi    
        else -> 
          printf("P%d:F%d already in use\n", _pid, lfork);   
      } 
       
  secondfork:
    atomic {
      printf("P%d, F%d => %d\n", _pid, rfork, FORK(p,rfork));
        if
        ::(FORK(p%NUM,rfork) == 0 || FORK((p+1)%NUM,rfork) == 0) -> //if the fork is not picked up 
          ::FORK(p,rfork) = 1; //pick up the fork 
          ::printf("P%d picks up fork F%d\n", _pid, rfork);
        fi
        else -> 
          printf("P%d:F%d already in use\n", _pid, rfork);
    }  
      
    assert(myForkOnly(p,lfork));
    assert(myForkOnly(p,rfork));
    progress_eat: printf("P%d eats!\n",_pid);
    
    dropfork1: FORK(p,lfork) = false;
    printf("P%d DROPS fork F%d\n", _pid, lfork);
    dropfork2: FORK(p,rfork) = false;
    printf("P%d DROPS fork F%d\n", _pid, rfork);  
 
  goto think
}

