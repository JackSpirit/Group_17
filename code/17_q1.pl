% CS F301 Assignment 2 - P1: Department Assignment Puzzle, Reloaded
% Group 17
%
% A Solution is a list of four terms p(Name, Dept, Lang, Project), in the
% order 'Alex', 'Ben', 'Carla', 'Dana', for example
%   [p('Alex',design,java,web), p('Ben',testing,python,data), ...]
% Values:
%   Dept    : research, development, design, testing
%   Lang    : python, java, 'c++', javascript
%   Project : 'AI', web, embedded, data
% Each value of each attribute is used by exactly one friend.

%! clue(+N, +Solution) is semidet.
%  Declarative reading: clue(N, Solution) holds exactly when clue number N
%  is true in the fully filled-in Solution.
%  Because every attribute value occurs exactly once in a complete
%  Solution, memberchk/2 finds "the friend who ..." uniquely; the tests
%  after it compare already-bound values only (==, \==, memberchk/2),
%  so no clause binds anything in Solution.

% Clue 1: the friend who prefers the AI project does not work in research
% and is not Dana.
clue(1, Solution) :-
    memberchk(p(Name, Dept, _, 'AI'), Solution),
    Dept \== research,
    Name \== 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    memberchk(p('Alex', Dept, Lang, _), Solution),
    Dept \== development,
    Lang \== 'c++'.

% Clue 3: the friend working in the testing department likes Python.
clue(3, Solution) :-
    memberchk(p(_, testing, Lang, _), Solution),
    Lang == python.

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    memberchk(p('Ben', Dept, _, Project), Solution),
    Project == web,
    Dept \== testing.

% Clue 5: the friend whose favorite language is Java works in design.
clue(5, Solution) :-
    memberchk(p(_, Dept, java, _), Solution),
    Dept == design.

% Clue 6: Carla's project preference is not embedded, and her department
% is not development.
clue(6, Solution) :-
    memberchk(p('Carla', Dept, _, Project), Solution),
    Project \== embedded,
    Dept \== development.

% Clue 7: Dana's favorite language is not Java, and she works in research
% or testing.
clue(7, Solution) :-
    memberchk(p('Dana', Dept, Lang, _), Solution),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% Clue 8: the friend who prefers data projects works in research and does
% not use JavaScript.
clue(8, Solution) :-
    memberchk(p(_, Dept, Lang, data), Solution),
    Dept == research,
    Lang \== javascript.

%! candidate(-Solution) is nondet.
%  Declarative reading: Solution is a candidate answer when it lists Alex,
%  Ben, Carla and Dana in that order and their departments, languages and
%  projects are each a permutation of the four possible values, so every
%  value is used by exactly one friend. Clues are not checked here.
candidate([ p('Alex',  Dept1, Lang1, Proj1),
            p('Ben',   Dept2, Lang2, Proj2),
            p('Carla', Dept3, Lang3, Proj3),
            p('Dana',  Dept4, Lang4, Proj4) ]) :-
    permutation([research, development, design, testing],
                [Dept1, Dept2, Dept3, Dept4]),
    permutation([python, java, 'c++', javascript],
                [Lang1, Lang2, Lang3, Lang4]),
    permutation(['AI', web, embedded, data],
                [Proj1, Proj2, Proj3, Proj4]).

%! satisfies_clues(+Active, +Solution) is semidet.
%  Declarative reading: Solution satisfies Active when clue(N, Solution)
%  holds for every clue number N in the list Active.
satisfies_clues(Active, Solution) :-
    forall(member(N, Active), clue(N, Solution)).

%! solve(-Solution) is nondet.
%  Declarative reading: Solution is a solution of the puzzle when it is a
%  candidate and clues 1 to 8 all hold in it.
solve(Solution) :-
    candidate(Solution),
    satisfies_clues([1, 2, 3, 4, 5, 6, 7, 8], Solution).

%! print_solution(+Solution) is det.
%  Declarative reading: prints one line "Name = [Dept, Lang, Project]" for
%  each friend in Solution, in list order, with atoms printed unquoted.
print_solution(Solution) :-
    forall(member(p(Name, Dept, Lang, Proj), Solution),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj])).

%! main is semidet.
%  Declarative reading: main succeeds after printing the first solution of
%  clues 1 to 8 as four lines in the order Alex, Ben, Carla, Dana; it fails
%  without printing if no solution exists.
main :-
    once(solve(Solution)),
    print_solution(Solution).
