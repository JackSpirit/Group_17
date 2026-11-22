
;; S2 tests: appended to a copy of code/id_q4.rkt (see run command)

;; my-length
(display (my-length '())) (newline)            ; expect 0
(display (my-length '(a b c))) (newline)       ; expect 3
(display (my-length '((1 2) 3 ()))) (newline)  ; expect 3 (top level only)
