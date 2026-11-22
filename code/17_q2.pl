% 17_q2.pl -- P2: Form a Valid Arithmetic Equation (SWI-Prolog 9.x)
%
% Expression trees:
%   num(N)          a single number N from the input list
%   op(Op, L, R)    L Op R, where Op is one of + - * / and L, R are trees

:- use_module(library(lists)).

%! apply_op(+Op, +X, +Y, -Z) is semidet.
%  Declarative reading: Z is the integer result of X Op Y. For / this holds
%  only when Y is not zero and X is an exact multiple of Y (no remainder);
%  otherwise there is no such Z and the goal fails.
apply_op(+, X, Y, Z) :- Z is X + Y.
apply_op(-, X, Y, Z) :- Z is X - Y.
apply_op(*, X, Y, Z) :- Z is X * Y.
apply_op(/, X, Y, Z) :-
    Y =\= 0,
    X mod Y =:= 0,
    Z is X // Y.

%! expr(+Nums, -Tree, -Value) is nondet.
%  Declarative reading: Tree is an expression tree that uses every number of
%  Nums exactly once, in the given order, and Value is its integer value.
%  A one-element list [N] gives the tree num(N). A longer list gives
%  op(Op, L, R) when Nums splits into two non-empty parts Left and Right,
%  L is an expression over Left, R is an expression over Right, and
%  apply_op/4 accepts Op on their values (so every division in the tree,
%  at any depth, is exact and by a non-zero divisor).
%  Fails for []. Terminates because both parts are strictly shorter than
%  Nums. Each distinct tree is produced exactly once.
expr([N], num(N), N).
expr(Nums, op(Op, L, R), Value) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, Nums),
    expr(Left, L, LV),
    expr(Right, R, RV),
    member(Op, [+, -, *, /]),
    apply_op(Op, LV, RV, Value).
