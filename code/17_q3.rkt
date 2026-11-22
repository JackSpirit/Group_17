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

;; empty -> acc; else postorder(left, postorder(right, node :: acc))
(define (postorder-acc t acc)
  (if (null? t)
      acc
      (postorder-acc (cadr t) (postorder-acc (caddr t) (cons (car t) acc)))))

(define (print-all-traversals tree)
  (display (inorder-acc tree '())) (newline)
  (display (preorder-acc tree '())) (newline)
  (display (postorder-acc tree '())) (newline))

(define (tree-height t)
  (if (null? t)
      0
      (+ 1 (max (tree-height (cadr t)) (tree-height (caddr t))))))

(define (leaf-count t)
  (cond ((null? t) 0)
        ((and (null? (cadr t)) (null? (caddr t))) 1)
        (else (+ (leaf-count (cadr t)) (leaf-count (caddr t))))))