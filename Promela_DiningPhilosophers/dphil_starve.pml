//Thomas Kelly 
//16323455
#define NUM 5 /* Number of philosophers, and forks! */

/* We want to record which philosopher is holding which fork */
/*  fork[NUM][NUM] where fork[p][f] is true if 'p' holds 'f' */

bool Fork[NUM*NUM] = {0}; /* 2-d arrays not supported, so ... */

#define s (![](hungry -> <>eats));
#define FORK(p,f) Fork[NUM*p+f]
#define leftFork(p) (p%NUM)
#define rightFork(p) ((p+1)%NUM)
#define myForkOnly(p,f) !(    FORK(((p+1)%NUM),f) \
                           || FORK(((p+2)%NUM),f) \
                           || FORK(((p+3)%NUM),f) \
                           || FORK(((p+4)%NUM),f) )

bool eats = false, hungry = false;  //flags for hungry/eats 
active [NUM] proctype phil()
{ int p, lfork, rfork, i = 0; 

  
  p = _pid;
  lfork = leftFork(p);
  rfork = rightFork(p);

  think: printf("P%d thinks..\n",_pid); hungry = true;
  

  firstfork:  
    atomic {
      if
      :: (myForkOnly(p,lfork) == 1) -> FORK(p,lfork) = 1; printf("P%d picked up F%d\n", p, lfork);  
      fi 
    }

  secondfork: 
    atomic {
      if
      ::(myForkOnly(p,rfork) == 1) -> FORK(p,rfork) = 1; printf("P%d picked up F%d\n", p, rfork); 
      fi 
    } 
  
  assert(myForkOnly(p,lfork));
  assert(myForkOnly(p,rfork));
  progress_eat: printf("P%d eats!\n",_pid); eats = true; 

  hungry = false; 

 
  dropfork1: FORK(p,lfork) = false;
  printf("P%d DROPS F%d\n", p, FORK(p,lfork));
  dropfork2: FORK(p,rfork) = false;
  printf("P%d DROPS F%d\n", p, FORK(p,rfork));
 
  goto think
}

//the never claim below is generated using the command spin -f '!([](hungry -> <>eats))'
never  {    /* !([](hungry -> <>eats)) */
T0_init:
        do
        :: (! ((eats)) && (hungry)) -> goto accept_S4
        :: (1) -> goto T0_init
        od;
accept_S4:
        do
        :: (! ((eats))) -> goto accept_S4
        od;
}