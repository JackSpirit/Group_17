# P1 Report: Department Assignment Puzzle, Reloaded

Group 17. Code: `code/17_q1.pl`. Tests: `tests/test_p1.pl`.

## P1.b: number of solutions for clues 1 to 8

```powershell
swipl -q -f code/17_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt
```

Result: **N = 3**

`count_solutions/2` generates every candidate with `candidate/1` (each attribute is a
permutation of its four values, so 24 × 24 × 24 = 13,824 candidates), keeps the ones for
which `satisfies_clues/2` holds for every clue number in `Active`, removes duplicates with
`sort/2` and counts what is left. As a check, `count_solutions([], N)` gives N = 13,824.

### All three solutions of clues 1 to 8

| # | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

With clues 1 to 8 only, `main/0` would print solution 1, simply because it is the first
one the search finds. After clue 9 was added (P1.c below), `main/0` prints solution 2,
the only one left.

## What N = 3 tells us: clues 1 to 8 are under-constrained

A well-formed logic puzzle has exactly one solution. N = 3 means clues 1 to 8 do not
contain enough information to decide the answer: the puzzle is **under-constrained**, and
the answer printed by `main/0` depends only on search order.

### What the clues do fix

Every solution agrees on these facts, which can be derived from the clues:

1. **Ben = development, javascript, web.** Ben prefers web (clue 4) and is not in testing
   (clue 4). He is not in research, because the research friend prefers data (clue 8).
   If Ben were in design, Alex, Carla and Dana would share research, development and
   testing; Alex and Carla cannot be in development (clues 2, 6), so Dana would be, which
   clue 7 forbids. So Ben is in development. Java goes with design (clue 5) and Python with
   testing (clue 3); the research friend cannot use JavaScript (clue 8), so research uses
   C++ and Ben is left with JavaScript.
2. **The other three friends get three fixed "profiles":** design + java,
   testing + python, and research + c++ + data.
3. **AI and embedded go to the design and testing friends**, because data goes with
   research and web with Ben.

### What the clues leave open

The clues tie attributes to each other strongly, but tie them to Alex, Carla and Dana only
through negative ("is not") or either/or statements:

- Alex: not development, not C++ (so not research) → design or testing.
- Carla: not development, not embedded.
- Dana: research or testing (clue 7), and not the AI friend (clue 1).

These allow three ways of handing out the profiles and the AI/embedded projects:

- Alex design, Carla research, Dana testing → AI must be Alex's (Dana cannot have AI). Solution 1.
- Alex design, Carla testing, Dana research → AI must be Carla's (Carla cannot have embedded). Solution 2.
- Alex testing, Dana research (clue 7), Carla design → AI must be Carla's. Solution 3.

No clue separates these three cases, so the puzzle needs one more clue.

### Every clue is needed

Dropping any single clue from 1 to 8 increases the count, so no clue is redundant:

| Clue dropped | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| N with the other seven | 4 | 6 | 13 | 12 | 9 | 7 | 5 | 16 |

## P1.c: ninth clue

```prolog
% CLUE 9: The friend whose favorite language is Python prefers the AI project.
clue(9, Solution) :-
    memberchk(p(_, _, python, Project), Solution),
    Project == 'AI'.
```

```powershell
swipl -q -f code/17_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), print(N), nl" -t halt
```

Result: **N = 1**. `solve/1` now checks clues 1 to 9, and `main/0` prints:

```
Alex = [design, java, embedded]
Ben = [development, javascript, web]
Carla = [testing, python, AI]
Dana = [research, c++, data]
```

### Why clue 9 has to keep solution 2

Clue 9 may not name a friend; it can only relate attribute values, as clue 5 does. So
look at the three solutions with the names removed, as sets of (department, language,
project) triples:

| # | design + java | testing + python | research + c++ | development + javascript |
|---|---|---|---|---|
| 1 | AI | embedded | data | web |
| 2 | **embedded** | **AI** | data | web |
| 3 | AI | embedded | data | web |

Solutions 1 and 3 contain exactly the same triples; they differ only in *who* holds
which triple (in solution 1 Alex is the design friend and Dana the testing friend; in
solution 3 Alex is the testing friend and Carla the design friend). Any clue that talks
only about attribute values is therefore either true in both or false in both, so no
allowed clue can keep one and drop the other. Solution 2 is the only one that can be made
unique.

### How clue 9 removes the other two

Solution 2 is the only solution in which the AI project goes to the testing/python friend
(and embedded to the design/java friend). Clue 9 states exactly that difference:

| # | Python friend's project | Clue 9 |
|---|---|---|
| 1 | embedded (Dana) | false → removed |
| 2 | AI (Carla) | **true → kept** |
| 3 | embedded (Alex) | false → removed |

So clue 9 is true in the solution we keep and false in every other solution of clues 1
to 8, as P1.c requires. Equivalent wordings would be "the friend who works in testing
prefers the AI project" or "the friend who likes Java prefers the embedded project".

On its own, clue 9 is weak: `count_solutions([9], N)` gives N = 3,456 (a quarter of all
13,824 candidates). It only singles out one answer in combination with clues 1 to 8,
which had already narrowed the puzzle down to a choice between "AI with design" and
"AI with testing".

### Tests

`tests/test_p1.pl` checks that:

- `count_solutions/2` gives 3 for clues 1 to 8, 1 for clues 1 to 9 and 13,824 for no
  clues, and that the order or repetition of clue numbers in `Active` does not matter;
- clue 9 holds in solution 2 and fails in solutions 1 and 3, holds in no other solution
  of clues 1 to 8, still holds when the names are replaced, and has its `% CLUE 9:`
  comment directly above it with no friend's name;
- `solve/1` has exactly one solution and `main/0` prints it in the required format.
