% test_p2.pl -- plunit tests for code/17_q2.pl (P2: arithmetic equations)
%
% Run (from the tests/ folder or the repo root):
%   swipl -q -g run_tests -t halt tests/test_p2.pl

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- consult('../code/17_q2.pl').

% The seven equations the PDF gives for [4,2,5,3].
pdf_4253(["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
          "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).

:- begin_tests(p2_pdf_examples).

test(generate_4253, [true(memberchk(E, Expected))]) :-
    pdf_4253(Expected),
    generate_equation([4,2,5,3], E).

test(all_4253, [true(Es == Expected)]) :-
    pdf_4253(Expected),
    all_equations([4,2,5,3], Es).

test(generate_234_fails, [fail]) :-
    generate_equation([2,3,4], _).

test(all_234_empty, [true(Es == [])]) :-
    all_equations([2,3,4], Es).

test(all_248, [true(Es == ["2*4=8"])]) :-
    all_equations([2,4,8], Es).

:- end_tests(p2_pdf_examples).

:- begin_tests(p2_short_lists).

test(generate_empty_fails, [fail]) :-
    generate_equation([], _).

test(generate_single_fails, [fail]) :-
    generate_equation([7], _).

test(all_empty, [true(Es == [])]) :-
    all_equations([], Es).

test(all_single, [true(Es == [])]) :-
    all_equations([7], Es).

test(count_empty, [true(N == 0)]) :-
    count_equations([], N).

test(all_two_equal, [true(Es == ["5=5"])]) :-
    all_equations([5,5], Es).

test(all_zero_zero, [true(Es == ["0=0"])]) :-
    all_equations([0,0], Es).

:- end_tests(p2_short_lists).

:- begin_tests(p2_division).

% 6/0 and 0/0 must be skipped (no error); only 6*0=0 is left.
test(divide_by_zero_skipped, [true(Es == ["6*0=0"])]) :-
    all_equations([6,0,0], Es).

% 0 may be divided (0/5 = 0), but nothing may be divided by 0 (5/0).
test(zero_dividend_ok, [true(Es == ["0*5=0", "0/5=0", "0=5*0"])]) :-
    all_equations([0,5,0], Es).

% 7/2 is inexact; truncating it to 3 would wrongly accept "7/2=3".
test(inexact_division_rejected, [true(Es == [])]) :-
    all_equations([7,2,3], Es).

test(inexact_division_generate_fails, [fail]) :-
    generate_equation([7,2,3], _).

% Inner division 7/2 is inexact; with rationals 7/2*2 would equal 7.
test(inner_inexact_division_rejected, [true(\+ memberchk("7/2*2=7", Es))]) :-
    all_equations([7,2,2,7], Es).

:- end_tests(p2_division).

:- begin_tests(p2_negative_values).

% 2-3 = -1 in the middle, then -1+4 = 3.
test(negative_intermediate, [true(memberchk("2-3+4=3", Es))]) :-
    all_equations([2,3,4,3], Es).

% (2-4)/2 = -1: exact division with a negative dividend.
test(negative_division, [true(memberchk("(2-4)/2+1=0", Es))]) :-
    all_equations([2,4,2,1,0], Es).

:- end_tests(p2_negative_values).

:- begin_tests(p2_brackets).

% 1+2+3 is (1+2)+3 and 1+(2+3) is a different tree: both must appear.
test(plus_left_and_right, [true((memberchk("1+2+3=6", Es),
                                 memberchk("1+(2+3)=6", Es)))]) :-
    all_equations([1,2,3,6], Es).

test(times_left_and_right, [true((memberchk("1*2*3=6", Es),
                                  memberchk("1*(2*3)=6", Es)))]) :-
    all_equations([1,2,3,6], Es).

% 1-(2-3) = 2 but 1-2-3 = -4.
test(minus_right_bracket, [true((memberchk("1-(2-3)=2", Es),
                                 \+ memberchk("1-2-3=2", Es)))]) :-
    all_equations([1,2,3,2], Es).

% 8/4*2 is (8/4)*2 = 4; 8/(4*2) = 1.
test(divide_left_assoc, [true((memberchk("8/4*2=4", Es),
                               \+ memberchk("8/(4*2)=4", Es)))]) :-
    all_equations([8,4,2,4], Es).

test(divide_right_bracket, [true((memberchk("8/(4*2)=1", Es),
                                  \+ memberchk("8/4*2=1", Es)))]) :-
    all_equations([8,4,2,1], Es).

% Lower-precedence left operand gets brackets: (4+2)*3.
test(low_prec_left_bracket, [true(memberchk("(4+2)*3=18", Es))]) :-
    all_equations([4,2,3,18], Es).

test(tree_string_examples, [true(Ss == ["(4+2)*3", "4+2*3", "8/4*2", "8/(4*2)",
                                        "1-2-3", "1-(2-3)", "1+(2+3)", "1+2+3"])]) :-
    Trees = [ op(*, op(+, num(4), num(2)), num(3)),
              op(+, num(4), op(*, num(2), num(3))),
              op(*, op(/, num(8), num(4)), num(2)),
              op(/, num(8), op(*, num(4), num(2))),
              op(-, op(-, num(1), num(2)), num(3)),
              op(-, num(1), op(-, num(2), num(3))),
              op(+, num(1), op(+, num(2), num(3))),
              op(+, op(+, num(1), num(2)), num(3)) ],
    maplist(tree_string, Trees, Ss).

:- end_tests(p2_brackets).

:- begin_tests(p2_output_form).

test(generate_gives_string, [true(string(E))]) :-
    generate_equation([2,4,8], E).

test(all_are_strings_without_spaces) :-
    all_equations([4,2,5,3], Es),
    forall(member(E, Es),
           ( string(E),
             \+ sub_string(E, _, _, _, " ") )).

test(generate_checks_given_equation) :-
    generate_equation([4,2,5,3], "4=2+5-3").

test(generate_rejects_wrong_equation, [fail]) :-
    generate_equation([4,2,5,3], "4=2+5+3").

% Repeated numbers: result must be sorted and duplicate-free.
test(sorted_no_duplicates) :-
    all_equations([1,1,1,1], Es),
    Es \== [],
    sort(Es, Sorted),
    Es == Sorted.

% The generator itself should not produce the same equation twice.
test(generator_no_duplicates) :-
    findall(E, equation([1,1,1,1,1], E), Raw),
    sort(Raw, Unique),
    length(Raw, N),
    length(Unique, N).

:- end_tests(p2_output_form).

:- begin_tests(p2_count).

test(count_4253, [true(N == 7)]) :-
    count_equations([4,2,5,3], N).

test(count_234, [true(N == 0)]) :-
    count_equations([2,3,4], N).

test(count_matches_length) :-
    forall(member(L, [[], [7], [0,0], [2,4,8], [2,3,4], [4,2,5,3],
                      [1,1,1,1], [6,0,0], [1,2,3,6]]),
           ( all_equations(L, Es),
             length(Es, Len),
             count_equations(L, N),
             N == Len )).

:- end_tests(p2_count).
