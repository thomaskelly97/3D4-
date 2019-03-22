#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC phil */
	case 3: // STATE 1 - dphil.pml:21 - [p = _pid] (0:4:3 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P0 *)this)->p;
		((P0 *)this)->p = ((int)((P0 *)this)->_pid);
#ifdef VAR_RANGES
		logval("phil:p", ((P0 *)this)->p);
#endif
		;
		/* merge: lfork = (p%5)(4, 2, 4) */
		reached[0][2] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)this)->lfork;
		((P0 *)this)->lfork = (((P0 *)this)->p%5);
#ifdef VAR_RANGES
		logval("phil:lfork", ((P0 *)this)->lfork);
#endif
		;
		/* merge: rfork = ((p+1)%5)(4, 3, 4) */
		reached[0][3] = 1;
		(trpt+1)->bup.ovals[2] = ((P0 *)this)->rfork;
		((P0 *)this)->rfork = ((((P0 *)this)->p+1)%5);
#ifdef VAR_RANGES
		logval("phil:rfork", ((P0 *)this)->rfork);
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 4: // STATE 4 - dphil.pml:25 - [printf('P%d thinks..\\n',_pid)] (0:0:0 - 3)
		IfNotBlocked
		reached[0][4] = 1;
		Printf("P%d thinks..\n", ((int)((P0 *)this)->_pid));
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 5 - dphil.pml:29 - [((Fork[((5*p)+lfork)]==0))] (16:0:1 - 1)
		IfNotBlocked
		reached[0][5] = 1;
		if (!((((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ])==0)))
			continue;
		/* merge: Fork[((5*p)+lfork)] = 1(16, 6, 16) */
		reached[0][6] = 1;
		(trpt+1)->bup.oval = ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ]);
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ] = 1;
#ifdef VAR_RANGES
		logval("Fork[((5*phil:p)+phil:lfork)]", ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ]));
#endif
		;
		/* merge: printf('P%d picked up F%d\\n',p,lfork)(16, 7, 16) */
		reached[0][7] = 1;
		Printf("P%d picked up F%d\n", ((P0 *)this)->p, ((P0 *)this)->lfork);
		/* merge: .(goto)(16, 9, 16) */
		reached[0][9] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 6: // STATE 11 - dphil.pml:36 - [((Fork[((5*p)+lfork)]==0))] (17:0:1 - 1)
		IfNotBlocked
		reached[0][11] = 1;
		if (!((((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ])==0)))
			continue;
		/* merge: Fork[((5*p)+rfork)] = 1(17, 12, 17) */
		reached[0][12] = 1;
		(trpt+1)->bup.oval = ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ]);
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ] = 1;
#ifdef VAR_RANGES
		logval("Fork[((5*phil:p)+phil:rfork)]", ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ]));
#endif
		;
		/* merge: printf('P%d picked up F%d\\n',p,rfork)(17, 13, 17) */
		reached[0][13] = 1;
		Printf("P%d picked up F%d\n", ((P0 *)this)->p, ((P0 *)this)->rfork);
		/* merge: .(goto)(17, 15, 17) */
		reached[0][15] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 7: // STATE 17 - dphil.pml:40 - [assert(!((((Fork[((5*((p+1)%5))+lfork)]||Fork[((5*((p+2)%5))+lfork)])||Fork[((5*((p+3)%5))+lfork)])||Fork[((5*((p+4)%5))+lfork)])))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][17] = 1;
		spin_assert( !((((((int)now.Fork[ Index(((5*((((P0 *)this)->p+1)%5))+((P0 *)this)->lfork), 25) ])||((int)now.Fork[ Index(((5*((((P0 *)this)->p+2)%5))+((P0 *)this)->lfork), 25) ]))||((int)now.Fork[ Index(((5*((((P0 *)this)->p+3)%5))+((P0 *)this)->lfork), 25) ]))||((int)now.Fork[ Index(((5*((((P0 *)this)->p+4)%5))+((P0 *)this)->lfork), 25) ]))), " !((((Fork[((5*((p+1)%5))+lfork)]||Fork[((5*((p+2)%5))+lfork)])||Fork[((5*((p+3)%5))+lfork)])||Fork[((5*((p+4)%5))+lfork)]))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 18 - dphil.pml:41 - [assert(!((((Fork[((5*((p+1)%5))+rfork)]||Fork[((5*((p+2)%5))+rfork)])||Fork[((5*((p+3)%5))+rfork)])||Fork[((5*((p+4)%5))+rfork)])))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][18] = 1;
		spin_assert( !((((((int)now.Fork[ Index(((5*((((P0 *)this)->p+1)%5))+((P0 *)this)->rfork), 25) ])||((int)now.Fork[ Index(((5*((((P0 *)this)->p+2)%5))+((P0 *)this)->rfork), 25) ]))||((int)now.Fork[ Index(((5*((((P0 *)this)->p+3)%5))+((P0 *)this)->rfork), 25) ]))||((int)now.Fork[ Index(((5*((((P0 *)this)->p+4)%5))+((P0 *)this)->rfork), 25) ]))), " !((((Fork[((5*((p+1)%5))+rfork)]||Fork[((5*((p+2)%5))+rfork)])||Fork[((5*((p+3)%5))+rfork)])||Fork[((5*((p+4)%5))+rfork)]))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 19 - dphil.pml:42 - [printf('P%d eats!\\n',_pid)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][19] = 1;
		Printf("P%d eats!\n", ((int)((P0 *)this)->_pid));
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 20 - dphil.pml:45 - [Fork[((5*p)+lfork)] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][20] = 1;
		(trpt+1)->bup.oval = ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ]);
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ] = 0;
#ifdef VAR_RANGES
		logval("Fork[((5*phil:p)+phil:lfork)]", ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 21 - dphil.pml:46 - [printf('P%d DROPS F%d\\n',p,Fork[((5*p)+lfork)])] (0:0:0 - 1)
		IfNotBlocked
		reached[0][21] = 1;
		Printf("P%d DROPS F%d\n", ((P0 *)this)->p, ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ]));
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 22 - dphil.pml:47 - [Fork[((5*p)+rfork)] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][22] = 1;
		(trpt+1)->bup.oval = ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ]);
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ] = 0;
#ifdef VAR_RANGES
		logval("Fork[((5*phil:p)+phil:rfork)]", ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 23 - dphil.pml:48 - [printf('P%d DROPS F%d\\n',p,Fork[((5*p)+rfork)])] (0:0:0 - 1)
		IfNotBlocked
		reached[0][23] = 1;
		Printf("P%d DROPS F%d\n", ((P0 *)this)->p, ((int)now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ]));
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

