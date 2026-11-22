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

%! op_prec(?Op, ?Prec) is nondet.
%  Declarative reading: Prec is the precedence of operator Op; * and / (2)
%  bind tighter than + and - (1).
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

%! needs_parens(+Side, +ChildPrec, +ParentPrec) is semidet.
%  Declarative reading: an operand on Side whose top operator has precedence
%  ChildPrec is parenthesised under a parent of precedence ParentPrec. A left
%  operand needs them only when ChildPrec is lower; a right operand needs
%  them when ChildPrec is the same or lower (operators are left-associative).
needs_parens(left, ChildPrec, ParentPrec) :- ChildPrec < ParentPrec.
needs_parens(right, ChildPrec, ParentPrec) :- ChildPrec =< ParentPrec.

%! tree_string(+Tree, -String) is det.
%  Declarative reading: String is the canonical text of Tree, with no spaces:
%  a number is written in decimal, and op(Op, L, R) is the text of L, then
%  Op, then the text of R, each operand in parentheses exactly when
%  needs_parens/3 says so. Different trees give different strings.
tree_string(num(N), String) :-
    number_string(N, String).
tree_string(op(Op, L, R), String) :-
    op_prec(Op, Prec),
    operand_string(left, L, Prec, LS),
    operand_string(right, R, Prec, RS),
    atomics_to_string([LS, Op, RS], String).

%! operand_string(+Side, +Tree, +ParentPrec, -String) is det.
%  Declarative reading: String is the text of Tree used as the Side operand
%  of a parent with precedence ParentPrec. A single number is never in
%  parentheses; an op/3 tree is wrapped in "(" ")" exactly when
%  needs_parens/3 holds for its top operator.
operand_string(_, num(N), _, String) :-
    tree_string(num(N), String).
operand_string(Side, op(Op, L, R), ParentPrec, String) :-
    op_prec(Op, Prec),
    tree_string(op(Op, L, R), Inner),
    (   needs_parens(Side, Prec, ParentPrec)
    ->  atomics_to_string(['(', Inner, ')'], String)
    ;   String = Inner
    ).

%! equation(+List, -Equation) is nondet.
%  Declarative reading: Equation is the string "L=R" where List splits into
%  two non-empty parts Left and Right, L is the text of an expression tree
%  over Left, R is the text of an expression tree over Right, and both
%  trees have the same integer value. Fails for lists of length 0 or 1,
%  since no split gives two non-empty parts.
equation(List, Equation) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List),
    expr(Left, LTree, Value),
    expr(Right, RTree, RValue),
    Value =:= RValue,
    tree_string(LTree, LS),
    tree_string(RTree, RS),
    atomics_to_string([LS, '=', RS], Equation).

%! generate_equation(+List, ?Equation) is semidet.
%  Declarative reading: Equation is one valid equation for List (the first
%  one equation/2 finds). Fails, without looping or raising an error, when
%  List has no valid equation, including when it has fewer than two numbers.
generate_equation(List, Equation) :-
    once(equation(List, Equation)).
