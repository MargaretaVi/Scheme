#lang racket
;; laboration 2
;; uppgift 1


(define foo (cons 2 3))
(define bar (list 2 3))
(define forex (cons 2 (cons 3 4)))
(define tesco (list 2 bar))

;; se inlämnat papper

;; uppgift 2

;; kollar om ett invärde är ett atomiskt värde
(define atom?
  (lambda (input)
    (if (or (pair? input) (null? input))
         #f
         #t)))

;; uppgift 3

(define count-list
  (lambda (lst)
    (if (atom? lst)
        1
        (count-elements lst 0))))

(define count-elements
  (lambda (lst count)
    (if (null? lst)
        0
        (+ 1 (count-elements (cdr lst) count)))))
        

(define count-list-correct?
  (lambda (lst)
    (if (= (count-list lst) (length lst))
        #t
        #f)))