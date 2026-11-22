
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

;; ---- S2 stress tests: append to a COPY of the solution file and run ----
;; No #lang line and no require. Uses my-length and insert-if-short from the
;; solution; the helpers below are test-only and must not be copied into code/.

;; (make-flat-list count) -> list
;; Builds (1 2 ... count) by counting down and consing onto an accumulator.
(define (make-flat-list count)
  (let loop ((i count) (acc '()))
    (if (< i 1)
        acc
        (loop (- i 1) (cons i acc)))))

;; (make-nested-list depth) -> list
;; Builds `depth` levels, each a list with one element (the next level),
;; around an innermost '(). Depth 3 gives (((()))).
(define (make-nested-list depth)
  (let loop ((i 0) (acc '()))
    (if (= i depth)
        acc
        (loop (+ i 1) (list acc)))))

;; (make-sublist-list count) -> list
;; Builds ((1 2) (2 4) ... (count 2*count)): count elements, each a short
;; two-element sublist.
(define (make-sublist-list count)
  (let loop ((i count) (acc '()))
    (if (< i 1)
        acc
        (loop (- i 1) (cons (list i (* 2 i)) acc)))))

;; (last-element-of lst) -> any
;; Last element of a non-empty list.
(define (last-element-of lst)
  (let loop ((l lst))
    (if (null? (cdr l))
        (car l)
        (loop (cdr l)))))

;; ---- Test 1: flat list of 10,000 integers ----
;; Original length 10000 < n = 10001, so x is inserted once at the front.
(define flat-result (insert-if-short 'x (make-flat-list 10000) 10001))
;; expected: 10001   (top-level length)
(display (my-length flat-result))
(newline)

;; ---- Test 2: nesting depth 100, one element per level ----
;; Every level has length 1 < n = 2, so every level (and the innermost
;; '()) gets x at the front.
(define nested-result (insert-if-short 'x (make-nested-list 100) 2))
;; expected: #t   (outermost list starts with x)
(display (eq? (car nested-result) 'x))
(newline)

;; ---- Test 3: 10,000 elements, each a short sublist ----
;; Top level has length 10000, not < n = 3, so it is unchanged; each
;; two-element sublist has length 2 < 3, so each gets x at the front.
(define sublist-result (insert-if-short 'x (make-sublist-list 10000) 3))
;; expected: (x 1 2)   (first element)
(display (car sublist-result))
(newline)
;; expected: (x 10000 20000)   (last element)
(display (last-element-of sublist-result))
(newline)

;;make-inserter

(display ((make-inserter 'x (lambda (len) (< len 2))) '((1) (2 3) ()))) (newline) ; expect ((x 1) (2 3) (x))
(display ((make-inserter 'x (lambda (len) (= len 0))) '((1) ()))) (newline)       ; expect ((1) (x))