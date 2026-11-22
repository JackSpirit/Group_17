
;; S2 tests: appended to a copy of code/id_q4.rkt (see run command)

;; my-length
(display (my-length '())) (newline)            ; expect 0
(display (my-length '(a b c))) (newline)       ; expect 3
(display (my-length '((1 2) 3 ()))) (newline)  ; expect 3 (top level only)

;;my-map and my-reverse
(display (my-map (lambda (x) (+ x 1)) '())) (newline)         ; expect ()
(display (my-map (lambda (x) (+ x 1)) '(1 2 3))) (newline)    ; expect (2 3 4)
(display (my-map (lambda (x) x) '(a (b) ()))) (newline)       ; expect (a (b) ())
(display (my-reverse '(1 2 3))) (newline)                     ; expect (3 2 1)