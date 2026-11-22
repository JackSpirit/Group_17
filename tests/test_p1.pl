% CS F301 Assignment 2 - tests for P1 (code/17_q1.pl)
% Group 17
%
% Run from the repository root:
%   swipl -q -g run_tests -t halt tests/test_p1.pl
%
% plunit is used only here, in the test file; the solution file itself
% uses no library outside lists, apply, yall and aggregate.

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).
:- consult('../code/17_q1.pl').

% ---------------------------------------------------------------------
% Fixtures
% ---------------------------------------------------------------------

%! pdf_layout_example(-Solution) is det.
%  Declarative reading: Solution is the layout example printed in the
%  assignment PDF (Alex = [research, python, AI], ...). The PDF says it
%  only shows the layout and is NOT the answer, so it must break clues.
pdf_layout_example([ p('Alex',  research,    python,     'AI'),
                     p('Ben',   development, java,       web),
                     p('Carla', design,      'c++',      embedded),
                     p('Dana',  testing,     javascript, data) ]).

%! valid_solution(-Solution) is det.
%  Declarative reading: Solution is a complete assignment, checked by hand
%  against clues 1 to 8, in which every clue holds (solution 1 of 3 in
%  P1_REPORT.md). Clue 9 is false in it.
valid_solution([ p('Alex',  design,      java,       'AI'),
                 p('Ben',   development, javascript, web),
                 p('Carla', research,    'c++',      data),
                 p('Dana',  testing,     python,     embedded) ]).

%! unique_solution(-Solution) is det.
%  Declarative reading: Solution is the only assignment in which clues 1
%  to 9 all hold (solution 2 of 3 in P1_REPORT.md).
unique_solution([ p('Alex',  design,      java,       embedded),
                  p('Ben',   development, javascript, web),
                  p('Carla', testing,     python,     'AI'),
                  p('Dana',  research,    'c++',      data) ]).

%! third_solution(-Solution) is det.
%  Declarative reading: Solution satisfies clues 1 to 8 but not clue 9
%  (solution 3 of 3 in P1_REPORT.md).
third_solution([ p('Alex',  testing,     python,     embedded),
                 p('Ben',   development, javascript, web),
                 p('Carla', design,      java,       'AI'),
                 p('Dana',  research,    'c++',      data) ]).

%! clues_1_to_8(-Active) is det.
%  Declarative reading: Active is the list of clue numbers 1 to 8.
clues_1_to_8([1, 2, 3, 4, 5, 6, 7, 8]).

%! clues_1_to_9(-Active) is det.
%  Declarative reading: Active is the list of clue numbers 1 to 9.
clues_1_to_9([1, 2, 3, 4, 5, 6, 7, 8, 9]).

%! breaks_2_4_7(-Solution) is det.
%  Declarative reading: Solution is a complete assignment in which
%  Alex works in development (breaks clue 2), Ben prefers AI (breaks
%  clue 4) and Dana works in design (breaks clue 7).
breaks_2_4_7([ p('Alex',  development, python,     web),
               p('Ben',   research,    java,       'AI'),
               p('Carla', testing,     'c++',      data),
               p('Dana',  design,      javascript, embedded) ]).

%! alex_cpp(-Solution) is det.
%  Declarative reading: Solution is a complete assignment in which Alex
%  prefers C++ although his department is allowed (breaks only the
%  language half of clue 2).
alex_cpp([ p('Alex',  research,    'c++',      web),
           p('Ben',   development, java,       'AI'),
           p('Carla', design,      python,     data),
           p('Dana',  testing,     javascript, embedded) ]).

%! dana_java(-Solution) is det.
%  Declarative reading: Solution is a complete assignment in which Dana
%  works in research but likes Java (breaks only the language half of
%  clue 7).
dana_java([ p('Alex',  design,      python,     web),
            p('Ben',   development, 'c++',      'AI'),
            p('Carla', testing,     javascript, data),
            p('Dana',  research,    java,       embedded) ]).

%! main_output(-Output) is det.
%  Declarative reading: Output is the string that main/0 prints.
main_output(Output) :-
    with_output_to(string(Output), main).

%! main_lines(-Lines) is det.
%  Declarative reading: Lines are the lines printed by main/0, without
%  the empty string that follows the final newline.
main_lines(Lines) :-
    main_output(Output),
    split_string(Output, "\n", "", Parts),
    once(append(Lines, [""], Parts)).

%! parse_line(+Line, -Person) is semidet.
%  Declarative reading: Person is p(Name, Dept, Lang, Proj) when Line has
%  exactly the form "Name = [Dept, Lang, Proj]".
parse_line(Line, p(Name, Dept, Lang, Proj)) :-
    once(sub_string(Line, Before, 4, After, " = [")),
    sub_string(Line, 0, Before, _, NameS),
    sub_string(Line, _, After, 0, Rest),
    string_concat(Inner, "]", Rest),
    split_string(Inner, ",", " ", [DeptS, LangS, ProjS]),
    maplist(atom_string, [Name, Dept, Lang, Proj],
            [NameS, DeptS, LangS, ProjS]).

%! all_distinct_values(+Solution) is semidet.
%  Declarative reading: no two friends in Solution share a department, a
%  language or a project.
all_distinct_values(Solution) :-
    findall(D, member(p(_, D, _, _), Solution), Ds),
    findall(L, member(p(_, _, L, _), Solution), Ls),
    findall(P, member(p(_, _, _, P), Solution), Ps),
    maplist([Xs]>>(sort(Xs, S), length(S, 4)), [Ds, Ls, Ps]).

% ---------------------------------------------------------------------
% main/0 output (P1.a)
% ---------------------------------------------------------------------

:- begin_tests(p1_main).

test(main_succeeds) :-
    main_output(_).

test(exactly_four_lines_and_trailing_newline) :-
    main_lines(Lines),
    length(Lines, 4).

test(names_in_order) :-
    main_lines(Lines),
    maplist(parse_line, Lines, People),
    findall(N, member(p(N, _, _, _), People), Names),
    assertion(Names == ['Alex', 'Ben', 'Carla', 'Dana']).

test(every_line_has_exact_layout) :-
    main_lines(Lines),
    forall(member(Line, Lines),
           ( parse_line(Line, P),
             P = p(N, D, L, J),
             format(string(Rebuilt), "~w = [~w, ~w, ~w]", [N, D, L, J]),
             assertion(Rebuilt == Line) )).

test(no_quotes_in_output) :-
    main_output(Output),
    assertion(\+ sub_string(Output, _, _, _, "'")).

test(printed_solution_satisfies_clues_1_to_9) :-
    main_lines(Lines),
    maplist(parse_line, Lines, Solution),
    forall(between(1, 9, N), assertion(clue(N, Solution))).

test(printed_solution_is_the_unique_solution) :-
    main_lines(Lines),
    maplist(parse_line, Lines, Solution),
    unique_solution(Expected),
    assertion(Solution == Expected).

test(main_prints_exact_unique_solution) :-
    main_output(Output),
    assertion(Output == "Alex = [design, java, embedded]\nBen = [development, javascript, web]\nCarla = [testing, python, AI]\nDana = [research, c++, data]\n").

test(printed_solution_is_a_full_assignment) :-
    main_lines(Lines),
    maplist(parse_line, Lines, Solution),
    assertion(candidate(Solution)),
    assertion(all_distinct_values(Solution)).

test(printed_solution_is_not_pdf_layout_example) :-
    main_lines(Lines),
    maplist(parse_line, Lines, Solution),
    pdf_layout_example(Example),
    assertion(Solution \== Example).

test(main_is_repeatable) :-
    main_output(First),
    main_output(Second),
    assertion(First == Second).

:- end_tests(p1_main).

% ---------------------------------------------------------------------
% PDF layout example: right shape, but not a solution
% ---------------------------------------------------------------------

:- begin_tests(p1_pdf_example).

test(layout_example_is_a_candidate) :-
    pdf_layout_example(S),
    assertion(candidate(S)).

test(layout_example_prints_like_pdf) :-
    pdf_layout_example(S),
    with_output_to(string(Out), print_solution(S)),
    assertion(Out == "Alex = [research, python, AI]\nBen = [development, java, web]\nCarla = [design, c++, embedded]\nDana = [testing, javascript, data]\n").

test(layout_example_breaks_clues_1_3_5_6_8) :-
    pdf_layout_example(S),
    forall(member(N, [1, 3, 5, 6, 8]), assertion(\+ clue(N, S))).

test(layout_example_keeps_clues_2_4_7) :-
    pdf_layout_example(S),
    forall(member(N, [2, 4, 7]), assertion(clue(N, S))).

test(layout_example_is_not_solved, [fail]) :-
    pdf_layout_example(S),
    satisfies_clues([1, 2, 3, 4, 5, 6, 7, 8], S).

:- end_tests(p1_pdf_example).

% ---------------------------------------------------------------------
% clue/2 edge cases: each clue fails when, and only when, it is broken
% ---------------------------------------------------------------------

:- begin_tests(p1_clues).

test(valid_solution_satisfies_every_clue) :-
    valid_solution(S),
    forall(between(1, 8, N), assertion(clue(N, S))).

test(clue2_fails_alex_in_development, [fail]) :-
    breaks_2_4_7(S), clue(2, S).

test(clue2_fails_alex_likes_cpp, [fail]) :-
    alex_cpp(S), clue(2, S).

test(clue4_fails_ben_not_web, [fail]) :-
    breaks_2_4_7(S), clue(4, S).

test(clue7_fails_dana_in_design, [fail]) :-
    breaks_2_4_7(S), clue(7, S).

test(clue7_fails_dana_likes_java, [fail]) :-
    dana_java(S), clue(7, S).

test(clue1_fails_ai_in_research, [fail]) :-
    pdf_layout_example(S), clue(1, S).

test(clue1_fails_dana_prefers_ai, [fail]) :-
    clue(1, [ p('Alex',  design,      java,       web),
              p('Ben',   development, javascript, data),
              p('Carla', research,    'c++',      embedded),
              p('Dana',  testing,     python,     'AI') ]).

test(clue3_fails_tester_not_python, [fail]) :-
    pdf_layout_example(S), clue(3, S).

test(clue5_fails_java_not_design, [fail]) :-
    pdf_layout_example(S), clue(5, S).

test(clue6_fails_carla_embedded, [fail]) :-
    pdf_layout_example(S), clue(6, S).

test(clue8_fails_data_not_research, [fail]) :-
    pdf_layout_example(S), clue(8, S).

test(clue8_fails_data_uses_javascript, [fail]) :-
    clue(8, [ p('Alex',  design,      java,       'AI'),
              p('Ben',   development, python,     web),
              p('Carla', research,    javascript, data),
              p('Dana',  testing,     'c++',      embedded) ]).

test(clues_do_not_bind_solution) :-
    valid_solution(S),
    copy_term(S, Before),
    forall(between(1, 8, N), clue(N, S)),
    assertion(S == Before).

test(unknown_clue_number_fails, [fail]) :-
    valid_solution(S), clue(0, S).

:- end_tests(p1_clues).

% ---------------------------------------------------------------------
% Solver: candidates, solve/1, no hard-coding
% ---------------------------------------------------------------------

:- begin_tests(p1_solver).

test(candidate_count_is_24_cubed) :-
    aggregate_all(count, candidate(_), N),
    assertion(N =:= 24 * 24 * 24).

test(every_candidate_uses_each_value_once) :-
    forall(candidate(S), all_distinct_values(S)).

test(candidate_rejects_repeated_value, [fail]) :-
    candidate([ p('Alex',  research, python,     'AI'),
                p('Ben',   research, java,       web),
                p('Carla', design,   'c++',      embedded),
                p('Dana',  testing,  javascript, data) ]).

test(candidate_rejects_wrong_name_order, [fail]) :-
    candidate([ p('Ben',   research,    python,     'AI'),
                p('Alex',  development, java,       web),
                p('Carla', design,      'c++',      embedded),
                p('Dana',  testing,     javascript, data) ]).

test(solve_has_a_solution) :-
    once(solve(_)).

test(every_solution_satisfies_clues_1_to_9) :-
    forall(solve(S),
           forall(between(1, 9, N), assertion(clue(N, S)))).

test(solutions_have_no_duplicates) :-
    findall(S, solve(S), Sols),
    sort(Sols, Unique),
    length(Sols, Len),
    length(Unique, Len).

test(hand_checked_solution_is_found) :-
    unique_solution(S),
    assertion(solve(S)).

test(other_clue_1_to_8_solutions_are_not_solved, [fail]) :-
    ( valid_solution(S) ; third_solution(S) ),
    solve(S).

test(satisfies_clues_empty_list_accepts_any_candidate) :-
    pdf_layout_example(S),
    satisfies_clues([], S).

:- end_tests(p1_solver).

% ---------------------------------------------------------------------
% count_solutions/2 (P1.b)
% ---------------------------------------------------------------------

:- begin_tests(p1_count).

test(clues_1_to_8_give_three) :-
    clues_1_to_8(Active),
    count_solutions(Active, N),
    assertion(N == 3).

test(clues_1_to_9_give_one) :-
    clues_1_to_9(Active),
    count_solutions(Active, N),
    assertion(N == 1).

test(spec_query_with_bound_n) :-
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], 1).

test(wrong_bound_n_fails, [fail]) :-
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8], 1).

test(no_clues_counts_every_candidate) :-
    count_solutions([], N),
    assertion(N == 13824).

test(order_of_active_does_not_matter) :-
    count_solutions([8, 7, 6, 5, 4, 3, 2, 1], N),
    assertion(N == 3).

test(repeated_clue_numbers_do_not_change_count) :-
    count_solutions([1, 1, 2, 3, 4, 5, 6, 7, 8, 8], N),
    assertion(N == 3).

test(clue_9_alone) :-
    count_solutions([9], N),
    assertion(N == 3456).

test(dropping_one_clue_never_lowers_count) :-
    clues_1_to_8(All),
    forall(select(_, All, Rest),
           ( count_solutions(Rest, N), assertion(N > 3) )).

test(count_matches_findall_on_solve) :-
    findall(S, solve(S), Sols),
    length(Sols, Len),
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], N),
    assertion(N == Len).

test(count_solutions_is_deterministic) :-
    count_solutions([1, 2, 3], _).

:- end_tests(p1_count).

% ---------------------------------------------------------------------
% clue(9, Solution) (P1.c)
% ---------------------------------------------------------------------

:- begin_tests(p1_clue9).

test(clue9_true_in_unique_solution) :-
    unique_solution(S),
    clue(9, S).

test(clue9_false_in_solution_1, [fail]) :-
    valid_solution(S),
    clue(9, S).

test(clue9_false_in_solution_3, [fail]) :-
    third_solution(S),
    clue(9, S).

test(clue9_true_only_in_kept_clue_1_to_8_solution) :-
    unique_solution(Kept),
    clues_1_to_8(Active),
    forall(( candidate(S), satisfies_clues(Active, S) ),
           ( clue(9, S) -> assertion(S == Kept) ; true )).

test(clue9_does_not_bind_solution) :-
    unique_solution(S),
    copy_term(S, Before),
    clue(9, S),
    assertion(S == Before).

test(clue9_does_not_depend_on_names) :-
    unique_solution(S),
    findall(p(N2, D, L, P),
            ( member(p(_, D, L, P), S), N2 = someone ),
            Renamed),
    assertion(clue(9, Renamed)).

test(clue9_comment_directly_above_and_names_no_friend) :-
    once(source_file(user:clue(_, _), File)),
    setup_call_cleanup(open(File, read, In),
                       read_string(In, _, Text),
                       close(In)),
    split_string(Text, "\n", "\r", Lines),
    once(( append(_, [Comment, Clause | _], Lines),
           sub_string(Comment, 0, _, _, "% CLUE 9:") )),
    assertion(sub_string(Clause, 0, _, _, "clue(9,")),
    forall(member(Name, ["Alex", "Ben", "Carla", "Dana"]),
           assertion(\+ sub_string(Comment, _, _, _, Name))).

:- end_tests(p1_clue9).
