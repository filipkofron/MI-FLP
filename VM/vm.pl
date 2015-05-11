eval(E, Res) :- Res = E, write('eval: '), format(E), nl.
eval(_, Res) :- Res = 'ERROR'.

read_line(InStream,Chars) :- get_code(InStream,Char), check_char(Char,CharCodes,InStream), atom_codes(String, CharCodes), atom_chars(String, Chars).
check_char(10,[],_):- !.
check_char(-1,[],_):- !.
check_char(end_of_file,[],_):- !.
check_char(Char, [Char|Chars], InStream) :- get_code(InStream, NextChar), check_char(NextChar, Chars, InStream).

is_num([N]) :- member(N, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).
is_num([N | Rest]) :- is_number([N]), is_num(Rest).

read_expr([C], [E]) :- !, member(C, ['+', '*', '(', ')', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']), E = C.
read_expr([Char | Chars], [ExprElem | ExprRest]) :- !, read_expr([Char], [ExprElem]), read_expr(Chars, ExprRest).

conc_number([N], [N]).
conc_number([N1, N2], [N3]) :- is_num(N1), is_num(N2), atom_concat(N1, N2, N3).
conc_number([N1, N2], [N1, N2]).
conc_number([N1, N2 | Rest], ResRest) :- conc_number([N1, N2], [N3]), conc_number([N3 | Rest], ResRest).
conc_number([N1, N2 | Rest], ResRest) :- conc_number([N1, N2], [N3, N4]), conc_number([N4 | Rest], RecRest), ResRest = [N3 | RecRest].

conv_numbers([S], [N]) :- atom_number(S, N).
conv_numbers([S], [S]).
conv_numbers([S | SRest], Nums) :- conv_numbers([S], [N]), conv_numbers(SRest, RecNums), Nums = [N | RecNums].

eval_line_rest(Chars, Res) :- read_expr(Chars, TempExpr), conc_number(TempExpr, RawExpr), conv_numbers(RawExpr, Expr), eval(Expr, Res).
eval_line_rest(_, 'ERROR').

eval_line(Stream, Res) :- read_line(Stream, Chars), !, eval_line_rest(Chars, Res).
eval_line(_, Res) :- Res = 'ERROR'.

eval_n_times(_, 0) :- true.
eval_n_times(Stream, N) :- N1 is N - 1, eval(Stream, Res), format(Res), nl, eval_n_times(Stream, N1).

main :-
  open('input.txt', read, File), eval_line(File, N),
  !, eval_n_times(File, N),
  close(File),
  halt(0).
