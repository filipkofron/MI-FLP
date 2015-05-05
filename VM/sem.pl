sum_op(['+']).
mul_op(['*']).
open_op(['(']).
close_op([')']).

encloses_right([Right], [Right]).
encloses_right([Right | RightRest], [Right | ListRest]) :- encloses_right(RightRest, ListRest).

encloses_center([Center], Right, [Center | ListRest]) :- encloses_right(Right, ListRest).
encloses_center([Center | CenterRest], Right, [Center | ListRest]) :- encloses_center(CenterRest, Right, ListRest).

encloses([L], [V], [R], List) :- List = [L, V, R].
encloses([Left], Center, Right, [Left | ListRest]) :- encloses_center(Center, Right, ListRest).
encloses([Left | LeftRest], Center, Right, [Left | ListRest]) :- encloses(LeftRest, Center, Right, ListRest).

op(OP) :- mul_op(OP).
op(OP) :- sum_op(OP).

bin_op(L, OP, R, List) :- encloses(L, OP, R, List), op(OP).
par(P, E) :- encloses(L, E, R, P), open_op(L), close_op(R).

expression(E, Res) :- bin_op(L, OP, R, E), sum_op(OP), component(L, Res1), expression(R, Res2), Res is Res1 + Res2.
expression(E, Res) :- component(E, Res).

component(C, Res) :- bin_op(L, OP, R, C), mul_op(OP), factor(L, Res1), component(R, Res2), Res is Res1 * Res2.
component(C, Res) :- factor(C, Res).

factor([Res], Res) :- integer(Res).
factor([F|Rest], Res) :- open_op([F]), length(Rest, Len1), Len1 > 1, par([F | Rest], E), expression(E, Res).

read_line(InStream,Line) :- get_code(InStream,Char), check_char(Char,Chars,InStream), atom_codes(Line,Chars).
check_char(10,[],_):- !.
check_char(-1,[],_):- !.
check_char(end_of_file,[],_):- !.
check_char(Char, [Char|Chars], InStream) :- get_code(InStream, NextChar), check_char(NextChar, Chars, InStream).

ne_str(Str) :- string_length(Str, Len), Len > 0.
any_ch_str(String, CharStr) :- name(String, CharList), member(FirstChar, CharList), atom_codes(CharStr, [FirstChar]).
positive_integer(String) :- member(String, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).
positive_integer(String) :- atom_concat(Start, End, String), string_length(Start, Len), Len = 1, ne_str(End), positive_integer(Start), !, positive_integer(End).

is_wrong(String) :- any_ch_str(String, Str), \+ member(Str, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '(', ')', '+', '*']).

read_expr(String, [_]) :- is_wrong(String), !, fail.
read_expr(String, [Expr]) :- String = '(', Expr = String.
read_expr(String, [Expr]) :- String = ')', Expr = String.
read_expr(String, [Expr]) :- String = '*', Expr = String.
read_expr(String, [Expr]) :- String = '+', Expr = String.
read_expr(String, [Expr]) :- ne_str(String), read_num_expr(String, '', [Expr]).
read_expr(String, [Expr | RestExpr]) :- atom_concat(Token, RestString, String), ne_str(Token), ne_str(RestString), read_num_expr(Token, RestString, [Expr]), read_expr(RestString, RestExpr).
read_expr(String, [Expr | RestExpr]) :- atom_concat(Token, RestString, String), ne_str(Token), ne_str(RestString), read_expr(Token, [Expr]), read_expr(RestString, RestExpr).

rest_number(Str) :- atom_concat(Pre, '', Str), string_length(Pre, Len), Len = 1, positive_integer(Pre).
rest_number(Str) :- atom_concat(Pre, Some, Str), string_length(Pre, Len), Len = 1, ne_str(Some), positive_integer(Pre).
read_num_expr(String, Rest, [Expr]) :- ne_str(String), positive_integer(String), \+ rest_number(Rest), atom_number(String, Expr).

eval(E, Res) :- expression(E, Res).
eval(_, Res) :- Res = 'ERROR'.

eval_line_rest(Line, Res) :- read_expr(Line, Expr), eval(Expr, Res).
eval_line_rest(_, 'ERROR').

eval_line(Stream, Res) :- read_line(Stream, Line), !,
  eval_line_rest(Line, Res).

eval_line(_, Res) :- Res = 'ERROR'.

eval_n_times(_, 0) :- true.
eval_n_times(Stream, N) :- N1 is N - 1, eval_line(Stream, Res), format(Res), nl, eval_n_times(Stream, N1).

% open('input.txt', read, File, [alias(my_input)]), eval_line(N), !, eval_n_times(N),

main :-
  open('input.txt', read, File), eval_line(File, N),
  !, eval_n_times(File, N),
  close(File),
  halt(0).
