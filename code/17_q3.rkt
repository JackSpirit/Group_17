#lang racket/base

;; empty -> acc; else inorder(left, node :: inorder(right, acc))
(define (inorder-acc t acc)
  (if (null? t)
      acc
      (inorder-acc (cadr t) (cons (car t) (inorder-acc (caddr t) acc)))))