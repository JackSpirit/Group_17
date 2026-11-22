---
name: prolog-dev
description: Conventions, run/test commands, a self-review checklist and known AI failure modes for writing SWI-Prolog 9.x code for CS F301 Assignment 2 (files code/17_q1.pl and code/17_q2.pl). Use for any Prolog predicate, Prolog test file or Prolog code review in this repository.
---

# prolog-dev

You are helping a student group (group ID `17`) write SWI-Prolog code for a graded
assignment. Follow every rule below. When a rule here conflicts with a general habit
of yours, this file wins.

## 1. Language and environment

- **SWI-Prolog 9.x**, run from the command line. No other Prolog dialect.
- In SWI-Prolog 7+ the default `double_quotes` flag is `string`: `"abc"` is a
  **string** object, `'abc'` is an **atom**, `` `abc` `` is a code list. Never confuse them.
- Solution files: `code/17_q1.pl`, `code/17_q2.pl`. Test files: `tests/test_p1.pl`,
  `tests/test_p2.pl`.

## 2. Hard constraints for solution files (`code/*.pl`)

These are grading rules. Violating any one of them costs marks.

1. **Only definitions.** No directive that runs code when the file loads.
2. **No `:- initialization(...)`** directive of any kind.
3. **Never call `halt/0` or `halt/1`.** The grader runs `-t halt` itself.
4. **No `assert`/`asserta`/`assertz`/`retract`/`retractall`**, and no global variables
   (`b_setval`, `b_getval`, `nb_setval`, `nb_getval`). All state goes through arguments.
5. **Allowed libraries only:** `lists`, `apply`, `yall`, `aggregate`. Do not use
   `clpfd`, `dcg/basics`, `strings`, `readutil`, `solution_sequences`, `tabling` etc.
   If you load one explicitly, use `:- use_module(library(lists)).` style for the
   allowed ones only (this is not an initialization directive).
6. **Print nothing except what the task specifies.** No debug `format`/`writeln`/`print`
   left in. P2 predicates print nothing at all.
7. **P2: do not build a string and parse it back** into a term to evaluate it
   (no `term_string/2`, `term_to_atom/2`, `read_term_from_atom/3`, `number_codes` on an
   expression string, etc.). Evaluate the expression *tree* directly.
8. **Do not hard-code answers.** Results must be derived by search over the clues /
   inputs.

## 3. Coding conventions

- **Naming:** predicates and atoms in `snake_case`; variables in `CamelCase`
  (`Solution`, `LeftExpr`, `Rest`). Helper predicates get descriptive names
  (`split_list/3`, `expr_value/2`), never `helper1`.
- **Header comment for every predicate**, in this shape:

  ```prolog
  %! expr_value(+Expr, -Value) is semidet.
  %  Declarative reading: Value is the integer value of expression tree Expr,
  %  provided every division inside Expr is exact and by a non-zero divisor.
  ```

  Use mode markers `+` (bound on call), `-` (unbound on call), `?` (either), and
  determinism `det` / `semidet` / `nondet` / `multi`.
- **Give the declarative reading** ("X holds when ...") for each clause group, not a
  procedural "first we loop ..." description.
- **Keep all clauses of a predicate contiguous.** If they truly cannot be, add
  `:- discontiguous name/arity.` (P1's `clue/2` clauses should simply be written
  together, clue 1 through clue 9, in order).
- **One predicate per unit of work.** The assignment's decomposition rule says one
  prompt = one predicate / one test file / one review. When asked for a predicate,
  produce *that* predicate (plus any tiny helper it strictly needs) — never the whole
  problem in one answer.
- Prefer pure, relational code: `member/2`, `select/3`, `permutation/2`, `append/3`,
  `nth1/3`, `msort/2`, `sort/2`, `foldl/4`, `maplist/N`, `include/3`, `exclude/3`,
  `findall/3`, `aggregate_all/3`, `forall/2`, `between/3`.
- Use cuts (`!`) only where you can state why they are safe (green cuts). Prefer
  `once/1` or if-then-else (`( C -> T ; E )`) over red cuts.
- Use `\+` only on goals whose variables are already bound (negation as failure is not
  logical negation).

## 4. Arithmetic rules

- `is/2` evaluates; `=:=`, `=\=`, `<`, `>` compare numerically; `=`/`==` are
  unification/identity, **not** arithmetic equality.
- `/` on integers in SWI-Prolog may return a rational or float depending on flags
  (`prefer_rationals`, `iso`). For exact integer division **check first, then use `//`**:

  ```prolog
  Y =\= 0, X mod Y =:= 0, Z is X // Y
  ```

  Every division inside an expression must pass this check, not just the outermost one.
- Sub-expression values may be negative. `mod` with a negative operand is still fine for
  the divisibility test (`-6 mod 3 =:= 0`).

## 5. Output formatting

- Use `format/2` with `~w` for plain output. `~q` quotes atoms (`'AI'`, `'c++'`), which
  is wrong when the spec shows `AI` and `c++` unquoted.
- Atoms that need quotes in source: `'Alex'`, `'Ben'`, `'Carla'`, `'Dana'`, `'AI'`,
  `'c++'`. Write them quoted in code; print them with `~w`.
- When the spec shows an exact layout (e.g. `Alex = [research, python, AI]`), match it
  character for character: spaces after commas, `" = "` with spaces, newline at the
  end of every line, nothing else.
- When the spec wants an SWI-Prolog **string** (P2: `"4*2=5+3"`), produce a string
  (`string_concat/3`, `format(string(S), ...)`, `atomics_to_string/2`), not an atom or
  code list. No spaces inside.

## 6. Running the code

Exactly how the grader runs it (from the `code/` folder):

```powershell
swipl -q -f 17_q1.pl -g main -t halt
```

```powershell
swipl -q -f 17_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt
```

```powershell
swipl -q -f 17_q2.pl -g "all_equations([4,2,5,3], Es), print(Es), nl" -t halt
```

Loading must produce **no warnings** (singleton variables, discontiguous clauses,
redefined procedures). Check with:

```powershell
swipl -q -f 17_q1.pl -g true -t halt
```

## 7. Testing

- Tests live in `tests/test_p1.pl` and `tests/test_p2.pl`, use `library(plunit)` (allowed
  in test files, not in solution files), and load the solution with
  `:- consult('../code/17_q1.pl').` or an equivalent relative path.
- Include **every example from the assignment PDF** as a test, plus own edge cases.
- Run:

  ```powershell
  swipl -q -g run_tests -t halt tests/test_p1.pl
  ```

- Useful test shapes:

  ```prolog
  :- begin_tests(p2).
  test(example_4253) :-
      all_equations([4,2,5,3], Es),
      assertion(Es == ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3",
                       "4=2*(5-3)","4=2+(5-3)","4=2+5-3"]).
  test(no_solution, [fail]) :- generate_equation([2,3,4], _).
  test(empty_list,  [fail]) :- generate_equation([], _).
  test(singleton,   [fail]) :- generate_equation([7], _).
  :- end_tests(p2).
  ```

- To test printed output (P1.a), capture it with `with_output_to(string(S), main)` and
  compare `S` with the expected string.
- Edge cases worth covering: empty list, one-element list, zeros (division by zero must
  be skipped, not raise), lists where only negative intermediates work, duplicate
  numbers (`[1,1,2]`), and checking that results have no duplicates and are sorted.

## 8. Self-review checklist (apply before every answer)

Go through this list silently and fix anything that fails before replying:

- [ ] Does the file load with **zero warnings** (singletons, discontiguous, undefined)?
- [ ] No `initialization`, no `halt`, no top-level goal that runs on load?
- [ ] No `assert`/`retract`/`b_setval`/`nb_setval`; only `lists`/`apply`/`yall`/`aggregate`?
- [ ] Every predicate has a `%!` header with modes, determinism and a declarative reading?
- [ ] Every predicate I call actually exists in SWI-Prolog 9.x with that arity
      (e.g. `sum_list/2` not `sumlist/3`, `nth1/3`, `last/2`, `msort/2`)?
- [ ] Atom vs string vs code list correct everywhere? Quoted atoms quoted?
- [ ] Arithmetic uses `is`/`=:=`, never `=`, and integer division is exact-checked + `//`?
- [ ] Does it **terminate** on every input, including `[]` and one-element lists? Does a
      failing call fail finitely rather than loop or throw?
- [ ] Are variables bound before `\+`, comparison, or arithmetic use them?
- [ ] Does `findall`/`aggregate_all(count, ...)` count *distinct* solutions as the spec
      intends (watch for duplicate answers from the generator)?
- [ ] Is output exactly the specified format (no extra spaces, quotes, blank lines,
      debug prints)?
- [ ] Is anything hard-coded that should be derived?
- [ ] Did I answer only the one unit of work asked for?

## 9. Known failure modes of AI tools in Prolog

Watch for these specifically — they are common mistakes made by LLMs:

1. **Invented or wrong-arity built-ins** (`sumlist/3`, `string_join/3`, `list_to_string/2`,
   `foldl/3`) or SWI-only libraries that are not allowed here (`clpfd`, `dcg/basics`).
2. **Treating `=` as arithmetic** (`X = Y + 1` leaves `X` as the term `Y+1`).
3. **Using `/` and getting `2r3` or `0.666`** instead of failing on inexact division.
4. **Checking only the final division** and letting an inexact inner division through.
5. **Negation on unbound variables** (`\+ member(X, L)` before `X` is bound), which
   silently changes the meaning.
6. **Generate-and-test explosion** or infinite generators (e.g. unbounded `length/2` or
   left recursion in an expression grammar) so a "no solution" query loops instead of
   failing.
7. **Atom/string confusion**: returning `'4*2=5+3'` (atom) or a code list where a string
   is required; double-quoted text behaving unexpectedly.
8. **Printing with `print/1` or `~q`** so atoms appear quoted (`'AI'`) in output.
9. **Leaving debug output, `halt`, or `:- initialization(main).`** in the file —
   both forbidden by the grader's run command.
10. **Duplicate solutions** from symmetric generators (e.g. two parse paths for the same
    tree), inflating counts; or using `sort/2` on the wrong representation.
11. **Wrong parenthesisation rule**: dropping parentheses that are needed on the right
    operand of `-` and `/` (or of same-precedence operators generally), or adding
    redundant ones on the left.
12. **Encoding clues incorrectly**: reading "A and not B" as "A or not B", forgetting a
    condition in a compound clue, or encoding a clue in a way that only works when it is
    applied *before* the solution is fully instantiated. Each clue must be correct when
    checked on a fully filled-in solution.
13. **Singleton-variable warnings and discontiguous clause warnings** left unfixed.
14. **Using `assert`/global state** for counters instead of `aggregate_all(count, ...)`.
15. **Over-confident claims** that code "passes the tests" without running it. If you
    have not run it, say so and give the command to run.
