---
name: scheme-dev
description: Conventions, allowed built-ins, run/test commands, a self-review checklist and known AI failure modes for writing Racket 8.x code in #lang racket/base for CS F301 Assignment 2 (files code/17_q3.rkt and code/17_q4.rkt). Use for any Scheme function, Scheme test file or Scheme code review in this repository.
---

# scheme-dev

You are helping a student group (group ID `17`) write Scheme code for a graded
assignment. Follow every rule below. When a rule here conflicts with a general habit
of yours, this file wins.

## 1. Language and environment

- **Racket 8.x**, language **`#lang racket/base`**. The first line of every solution
  file is exactly `#lang racket/base`.
- Solution files: `code/17_q3.rkt` (S1, tree traversals) and `code/17_q4.rkt`
  (S2, conditional insert). Test files: `tests/test_s1.rkt`, `tests/test_s2.rkt`.
- The grader runs `racket 17_q3.rkt` / `racket 17_q4.rkt` after **appending its own
  calls to the end of the file**. So top-level names must be exactly the ones the task
  specifies, and the file must not need `provide` or `require` to work.

## 2. Allowed built-ins (the complete list)

Only these may appear in a solution file:

| Kind | Allowed |
|---|---|
| Definitions / binding | `define`, `lambda`, `let`, `let*`, `letrec`, named `let` |
| Control | `if`, `cond` (with `else`), `and`, `or`, `not`, `begin` |
| Data | `quote` (written `'`), `cons`, `car`, `cdr`, `list` |
| `c[ad]r` compositions | every composition up to four levels: `cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, `caar`, `cdar`, ... |
| Predicates | `null?`, `pair?`, `eq?` |
| Association lists | `assq`, `assoc` |
| Arithmetic / comparison | `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max` |
| I/O | `display`, `newline`; **S2 only:** `read` |

**Everything else from `racket/base` is forbidden.** In particular, never use:

- `set!`, `set-car!`, `set-cdr!` or any mutation; `define-values`, `let-values`
- vectors, hash tables, strings, characters, `string-append`, `format`, `printf`,
  `write`, `print`, `displayln`
- loops: `do`, `for`, `for/list`, `for-each`, `when`, `unless`, `case`
- list library: `length`, `append`, `reverse`, `map`, `filter`, `foldl`, `foldr`,
  `apply`, `member`, `memq`, `memv`, `list-ref`, `list-tail`, `last`, `remove`, `sort`
- predicates not in the list: `equal?`, `eqv?`, `list?`, `number?`, `symbol?`,
  `atom?`, `zero?`, `empty?`, `first`, `rest`, `empty`
- `quasiquote`/`` ` ``/`,`, `error`, `raise`, `void`, `require`, `provide`, `module`

If you need such a function, **write your own helper** with a `my-` prefix
(`my-reverse`, `my-length`, `my-map`, `my-append`) using only allowed built-ins.

Distinguishing atoms from lists: an element `e` is a list when `(or (null? e) (pair? e))`;
otherwise it is an atom. Do not use `list?`, `number?` or `symbol?`.

## 3. File content rules

1. **Only definitions.** No top-level calls of your own functions, no top-level
   `display`, nothing printed when the file is loaded.
2. **One definition per name.** In S2 the final file contains a single
   `insert-if-short` — the version built with `make-inserter`.
3. **All state through function arguments.** No global mutable state.
4. Every printing function ends its output with `(newline)`.

## 4. Coding conventions

- **Naming:** `kebab-case`; predicates end in `?` (`len-ok?`, `leaf?`); own versions of
  library functions start with `my-`. Use the exact required names:
  `print-inorder`, `print-all-traversals`, `print-height-and-leaves`,
  `print-insert-result`, `insert-if-short`, `my-length`, `my-map`, `make-inserter`.
- **Comment header for every function**, in this shape:

  ```racket
  ;; (my-length lst) -> number
  ;; Recursive reading: the length of '() is 0; the length of a pair is
  ;; 1 plus the length of its cdr.
  ;; Uses an accumulator, so it is tail recursive.
  (define (my-length lst)
    (let loop ((l lst) (acc 0))
      (if (null? l)
          acc
          (loop (cdr l) (+ acc 1)))))
  ```

  Give the **recursive reading** (base case + recursive case in words), the argument
  types and the return value or what is printed.
- **Separate computing from printing:** write a pure function that returns the list
  (e.g. `inorder-list`), and a thin `print-...` function that calls `display` on it and
  then `newline`.
- **Prefer tail recursion where it is natural**: accumulator + named `let`, then
  `my-reverse` at the end if order matters. Tree recursion over two subtrees cannot be
  fully tail recursive; use an accumulator so each node is consed once (e.g. build the
  inorder list right-to-left: traverse right subtree first into `acc`).
- Avoid quadratic `my-append` inside recursion when an accumulator does the job.
- Use `cond` with `else` for multi-way branches; use `let` to name repeated
  `car`/`cadr`/`caddr` accesses (`value`, `left`, `right` of a tree node).
- Indent in standard Racket style; closing parentheses gathered on the last line.
- **One function per unit of work.** The assignment's decomposition rule says one
  prompt = one function / one test file / one review. When asked for a function,
  produce *that* function (plus any tiny helper it strictly needs) — never a whole
  problem in one answer.

## 5. Problem-specific facts to respect

- **S1 trees:** `'()` or `(value left right)`. Height of `'()` is 0; a single node has
  height 1. A leaf has both subtrees `'()`; the empty tree has 0 leaves. Visit left
  before right. `(display '())` prints `()`, which is the required output for empty
  traversals; `print-height-and-leaves` prints `(0 0)` for the empty tree.
- **S2 insert:** length is the number of top-level elements of the **original** list,
  measured before insertion; the top-level list is treated like any other list;
  `'()` has length 0 so it becomes `(x)` whenever `0 < n`. Recurse into sublists at
  every level. `print-insert-result` reads `x`, then `lst`, then `n` with `read`, in that
  order, prints the result with `display` and a newline, and prints nothing else (no
  prompt).
- **Hidden tests:** nesting depth 100 and lists of 10,000 elements. Code must not be
  quadratic in list length and must not rely on tricks that break at depth.

## 6. Running the code

The grader appends calls to the end of the file. Reproduce that exactly:

```powershell
racket code/17_q3.rkt
```

```powershell
Get-Content code/17_q3.rkt, tests/test_s1.rkt | Set-Content -Encoding utf8 $env:TEMP\q3_run.rkt; racket $env:TEMP\q3_run.rkt
```

The first command must print **nothing**. The second appends the test calls to a
temporary copy of the solution and runs it, the way the grader does. Never write the
combined file into `code/`.

For S2, input arrives on standard input:

```powershell
"42 ((1 2) (3 4 5) (6) ()) 3" | racket $env:TEMP\q4_run.rkt
```

where `q4_run.rkt` is the solution with `(print-insert-result)` appended.

## 7. Testing

- One test file per problem: `tests/test_s1.rkt` and `tests/test_s2.rkt`. Each holds
  **every example from the assignment PDF** plus own edge cases.
- A test file has **no `#lang` line**: it is a sequence of grader-style calls that is
  appended to the solution (section 6). Put the expected output in a comment directly
  above each call, so a run can be compared line by line:

  ```racket
  ;; ---- S1 tests: append to code/17_q3.rkt and run ----
  (define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
  ;; expected: (1 2 3 4 5 6 7)
  (print-inorder t1)
  ;; expected: (3 4)
  (print-height-and-leaves t1)
  ```

- For S2, `print-insert-result` reads stdin, so test `insert-if-short` directly in
  `tests/test_s2.rkt` (e.g. `(display (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))`
  then `(newline)`), and test `print-insert-result` separately by piping input as in
  section 6.
- Test files may use extra Racket features (e.g. building a 10,000-element list with a
  helper) — the built-in restrictions apply to solution files. Never copy test-only
  code into `code/`.
- S1 cases: `t1`, `t2`, `t3` and `'()` from the PDF; a single node; a left-only chain;
  a right-only chain; symbol values.
- S2 cases: the four PDF examples; `n = 0` (nothing changes); `n` larger than every
  length (every list, including the top level, gets `x`); deeply nested `(((...)))` to
  depth 100; a flat list of 10,000 elements; empty sublists at several levels.

## 8. Self-review checklist (apply before every answer)

Go through this list silently and fix anything that fails before replying:

- [ ] First line is `#lang racket/base`?
- [ ] **Every identifier used is in the allowed list in section 2** or defined in this
      file? (Scan for `length`, `append`, `reverse`, `map`, `equal?`, `list?`,
      `number?`, `when`, `for`, `set!`, `` ` ``; every `cond` ends in `else`.)
- [ ] Nothing runs or prints when the file is loaded?
- [ ] Function names and argument order exactly as the task specifies?
- [ ] Every print function ends with `(newline)` and prints exactly the required text?
- [ ] Base cases correct: `'()` tree, `'()` list, `n = 0`, single node / single element?
- [ ] Atoms vs lists distinguished with `null?`/`pair?` only?
- [ ] S2 length measured on the original list, not after inserting `x`?
- [ ] Tail recursive where natural; no quadratic appends; fine at depth 100 and 10,000
      elements?
- [ ] Each function has a comment header with its recursive reading?
- [ ] Only one definition per name (single final `insert-if-short`)?
- [ ] Did I answer only the one unit of work asked for?

## 9. Known failure modes of AI tools in Scheme/Racket

Watch for these specifically — they are common mistakes made by LLMs:

1. **Reaching for forbidden library functions** out of habit: `length`, `append`,
   `reverse`, `map`, `filter`, `foldl`, `apply`, `member`, `list-ref`, `equal?`,
   `list?`, `number?`, `symbol?`, `first`/`rest`, `empty?`, `when`/`unless`, `for`.
2. **Using `#lang racket`** (full Racket) instead of `#lang racket/base`, or adding
   `(require ...)` lines.
3. **Leaving example calls or `(display ...)` at the top level**, so the file prints when
   loaded and the grader's output is wrong.
4. **Using `printf`/`displayln`/`write`/`print`** instead of `display` + `newline`;
   `write` and `print` add quotes (`'a`) that `display` does not.
5. **Treating `'()` specially when the spec says it is not** (S2: an empty sublist with
   `0 < n` must become `(x)`), or mis-handling the top-level list.
6. **Measuring length after insertion**, or recursing into the new `x` element.
7. **Mixing up `atom` detection**: treating `'()` as an atom, or using `pair?` alone and
   missing empty sublists.
8. **Off-by-one in height** (counting edges instead of nodes) or counting `'()` as a leaf.
9. **Wrong traversal order** or visiting right before left; building lists in reverse and
   forgetting `my-reverse`.
10. **Quadratic `my-append`** in traversals or non-tail recursion over 10,000 elements
    where an accumulator was natural.
11. **Redefining `insert-if-short` twice** (old version plus `make-inserter` version)
    in the final file.
12. **`make-inserter` returning the wrong arity** — it must return a function of one
    argument (the list), with `len-ok?` a function of one number.
13. **Using `eq?` to compare numbers** instead of `=`.
14. **`read` order or extra prompts**: reading `n` before `lst`, or printing "Enter..."
    text.
15. **Over-confident claims** that code "passes the tests" without running it. If you
    have not run it, say so and give the command to run.
