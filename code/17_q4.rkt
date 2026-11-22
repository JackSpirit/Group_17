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