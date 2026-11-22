
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


;; insert-if-short
(display (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)) (newline)  ; expect ((42 1 2) (3 4 5) (42 6) (42))
(display (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)) (newline) ; expect ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(display (insert-if-short 7 '() 3)) (newline)                        ; expect (7)
(display (insert-if-short 7 '() 0)) (newline)                        ; expect ()
(display (insert-if-short 7 '((())) 2)) (newline)                    ; expect (7 (7 (7)))

;; print-insert-result
;;(needs stdin; run by appending (print-insert-result)
;; to a copy of the solution and piping the input in):
;;   42 ((1 2) (3 4 5) (6) ()) 3  -> ((42 1 2) (3 4 5) (42 6) (42))
;;   0 (((1) 2) (3) ((4 5 6) ())) 3    -> ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
;;   7 () 3                            -> (7)
;;   7 () 0                            -> ()
;; ran the following test cases using 
;;cat 17_q4.rkt > /tmp/g.rkt
;;echo "(print-insert-result)" >> /tmp/g.rkt
;;echo "42 ((1 2) (3 4 5) (6) ()) 3" | "/c/Program Files/Racket/Racket.exe" /tmp/g.rkt