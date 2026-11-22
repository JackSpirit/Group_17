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

`main/0` prints solution 1, because it is the first one the search finds.

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

To be added.
