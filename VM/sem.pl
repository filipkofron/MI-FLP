op_sum(OP) :- OP = "+".
op_mul(OP) :- OP = "*".

op(OP) :- op_mul(OP), !.
op(OP) :- op_sum(OP).

bin_e(L, OP, R, E) :- expr(E), op(OP), expr(L), expr(R).

expr(E) :- integer(E).

par_e(E, IE) :-
	expr(E),
	expr(IE).

eval_e(E, RES) :-
	integer(E),
	RES is E.

eval_e(E, RES) :-
	par_e(E, IE),
	eval_e(IE, RES).

eval_e(E, RES) :- 
	bin_e(L, OP, R, E),
	eval_e(L, RES1),
	eval_e(R, RES2),
	op_sum(OP),
	RES is RES1 + RES2.

eval_e(E, RES) :-
	bin_e(L, OP, R, E),
	eval_e(L, RES1),
	eval_e(R, RES2),
	op_mul(OP),
	RES is RES1 * RES2.
