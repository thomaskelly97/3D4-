	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC phil */

	case 3: // STATE 3
		;
		((P0 *)this)->rfork = trpt->bup.ovals[2];
		((P0 *)this)->lfork = trpt->bup.ovals[1];
		((P0 *)this)->p = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;
;
		;
		;
		;
		
	case 6: // STATE 6
		;
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		;
		
	case 9: // STATE 15
		;
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		;
		;
		;
		;
		;
		
	case 14: // STATE 26
		;
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->lfork), 25) ] = trpt->bup.oval;
		;
		goto R999;

	case 15: // STATE 27
		;
		now.Fork[ Index(((5*((P0 *)this)->p)+((P0 *)this)->rfork), 25) ] = trpt->bup.oval;
		;
		goto R999;
	}

