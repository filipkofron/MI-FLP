sum_op(["+"]).
mul_op(["*"]).
open_op(["("]).
close_op([")"]).

nempty(L) :- length(L, LenL), LenL > 0.
prefix(P, C, L) :- length(L, LenL), LenL > 1, nempty(P), nempty(C), nempty(L), append(P, C, L).
suffix(S, C, L) :- length(L, LenL), LenL > 1, nempty(S), nempty(C), nempty(L), append(C, S, L).

encloses([L], [V], [R], List) :- List = [L, V, R].
encloses(L, V, R, List) :- length(List, LenList), LenList > 2, nempty(L), nempty(V), nempty(R), length(L, LenL), LenL < LenList, prefix(L, V, C), length(C, LenC), LenC < LenList, length(R, LenR), LenR < LenList, suffix(R, C, L).

op(OP) :- mul_op(OP).
op(OP) :- sum_op(OP).

bin_op(L, OP, R, List) :- encloses(L, OP, R, List), op(OP).
par(P, E) :- encloses(L, E, R, P), open_op(L), close_op(R).

expression(E, Res) :- bin_op(L, OP, R, E), sum_op(OP), !, component(L, Res1), expression(R, Res2), Res is Res1 + Res2.
expression(E, Res) :- component(E, Res).

component(C, Res) :- bin_op(L, OP, R, C), mul_op(OP), factor(L, Res1), component(R, Res2), Res is Res1 * Res2.
component(C, Res) :- factor(C, Res).

factor([Res], Res) :- integer(Res).
factor([F|Rest], Res) :- open_op([F]), length(Rest, Len1), Len1 > 1, par([F | Rest], E), expression(E, Res).
