#lang racket/base

;; empty -> acc; else inorder(left, node :: inorder(right, acc))
(define (inorder-acc t acc)
  (if (null? t)
      acc
      (inorder-acc (cadr t) (cons (car t) (inorder-acc (caddr t) acc)))))

(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))

;; empty -> acc; else node :: preorder(left, preorder(right, acc))
(define (preorder-acc t acc)
  (if (null? t)
      acc
      (cons (car t) (preorder-acc (cadr t) (preorder-acc (caddr t) acc)))))