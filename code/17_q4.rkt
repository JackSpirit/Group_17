#lang racket/base

;; (my-length lst) -> number
;; Recursive reading: the length of '() is 0; the length of a pair is
;; 1 plus the length of its cdr.
;; Uses an accumulator, so it is tail recursive.
(define (my-length lst)
  (let loop ((l lst) (acc 0))
    (if (null? l)
        acc
        (loop (cdr l) (+ acc 1)))))

;; (my-reverse lst) -> list
;; Recursive reading: the reverse of '() is '(); otherwise move the car of
;; the list onto the front of an accumulator and continue with the cdr.
;; Uses an accumulator, so it is tail recursive.
(define (my-reverse lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        acc
        (loop (cdr l) (cons (car l) acc)))))

;; (my-map f lst) -> list
;; f is a one-argument function, lst is a list; returns a new list holding
;; (f e) for each element e of lst, in the same order.
;; Recursive reading: mapping over '() gives '(); mapping over a pair gives
;; (f (car lst)) followed by the map of f over the cdr.
;; Uses an accumulator (built in reverse, then flipped with my-reverse),
;; so it is tail recursive and never appends.
(define (my-map f lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        (my-reverse acc)
        (loop (cdr l) (cons (f (car l)) acc)))))

;; (insert-if-short x lst n) -> any
;; x is any value, lst is any datum (list or atom), n is a number.
;; Recursive reading: an atom is returned unchanged. A list (null or pair)
;; has insert-if-short applied to each of its elements; then x is consed on
;; the front of the result if the ORIGINAL length of the list is < n.
;; x itself is never recursed into, since it is added after the mapping.
(define (insert-if-short x lst n)
  (cond ((not (or (null? lst) (pair? lst))) lst)
        (else
         (let ((processed
                (my-map (lambda (e) (insert-if-short x e n)) lst)))
           (if (< (my-length lst) n)
               (cons x processed)
               processed)))))


;; (print-insert-result) -> prints one line
;; Takes no arguments. Reads x, then lst, then n from standard input with
;; read (in that order), then displays (insert-if-short x lst n) followed
;; by a newline. Prints nothing else (no prompt).
;; let* guarantees the three reads happen in the order x, lst, n.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

