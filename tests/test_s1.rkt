;; Append to code/17_s1.rkt and run. No #lang line.
 
;; ---- T0: trees ----
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define t4 '(5 () ()))
(define t5 '(3 (2 (1 () ()) ()) ()))
(define t6 '(1 (2 () ()) (3 (4 () ()) ())))

;; ---- T1: print-inorder ----
;; expected: (1 2 3 4 5 6 7)
(print-inorder t1)
;; expected: (1 2 3)
(print-inorder t2)
;; expected: (b a c)
(print-inorder t3)
;; expected: ()
(print-inorder '())

;; ---- T2: print-all-traversals ----
;; expected: (1 2 3 4 5 6 7) / (4 2 1 3 6 5 7) / (1 3 2 5 7 6 4)
(print-all-traversals t1)
;; expected: (1 2 3) / (1 2 3) / (3 2 1)
(print-all-traversals t2)
;; expected: (b a c) / (a b c) / (b c a)
(print-all-traversals t3)
;; expected: () / () / ()
(print-all-traversals '())

;; ---- T3: print-height-and-leaves ----
;; expected: (3 4)
(print-height-and-leaves t1)
;; expected: (3 1)
(print-height-and-leaves t2)
;; expected: (2 2)
(print-height-and-leaves t3)
;; expected: (0 0)
(print-height-and-leaves '())

;; ---- T4: edge cases ----
;; expected: (5) / (5) / (5)
(print-all-traversals t4)
;; expected: (1 1)
(print-height-and-leaves t4)
;; expected: (1 2 3) / (3 2 1) / (1 2 3)
(print-all-traversals t5)
;; expected: (3 1)
(print-height-and-leaves t5)
;; expected: (2 1 4 3) / (1 2 3 4) / (2 4 3 1)
(print-all-traversals t6)
;; expected: (3 2)
(print-height-and-leaves t6)