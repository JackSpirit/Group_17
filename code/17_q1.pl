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
