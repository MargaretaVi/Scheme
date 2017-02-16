#lang racket
;; laboration 2
;; Task 1
(require racket/trace)
(provide (all-defined-out))

(define foo (cons 2 3))
(define bar (list 2 3))
(define forex (cons 2 (cons 3 4)))
(define tesco (list 2 bar))

;; Pratat med Andres, se webreg

;; Task 2
;; Predicate, check if the input is an atom
(define atom?
  (lambda (input)
    (and (not (pair? input)) (not (null? input)))))

;; Task 3
;; Counts the number of elements in a list, (not sublists)
(define count-list
  (lambda (lst)
    (if (atom? lst)
        1
        (count-elements lst 0))))

;; Help function for count-list
(define count-elements
  (lambda (lst count)
    (if (null? lst)
        count
        (count-elements (cdr lst) (+ count 1)))))

;; Check if count-list returns the same value as length
(define count-list-correct?
  (lambda (lst)
    (= (count-list lst) (length lst))))

;; EXAMPLES

;(count-list-correct? '(1 4 (3 7))) -> #t
;(count-list-correct? '(two zero one seven feb first)) -> #t
;(count-list-correct? '()) -> #t


;; Task 4
;; Return a list with elements that fullfills the predicate
(define keep-if
  (lambda (pred lst)
    (if (null? lst)
        '()
        (if (pred (car lst))
            (cons (car lst) (keep-if pred (cdr lst)))
            (keep-if pred (cdr lst))))))

;; Check if the output from keep-if is the same as filter    
(define keep-if-correct?
  (lambda (pred lst)
    (comp-elem (keep-if pred lst) (filter pred lst))))

;; Help function for keep-if-correct,
;; compare each element in two list and see if they are equal

(define comp-elem
  (lambda (lst1 lst2)
    (if (and (null? lst1) (null? lst2))
        #t
        (if (equal? (car lst1) (car lst2))
            (comp-elem (cdr lst1) (cdr lst2))
            #f))))

;; Task 5
;; Extracts the n first elements from a list
#|
(define first-n
  (lambda (n lst)
    (cond
      ((null? lst) lst)
      ((> n 0)
       (cons (car lst) (first-n (- n 1) (cdr lst))))
      (else '()))))
|#
(define first-n
  (lambda (n lst)
    (if (or (= n 0) (null? lst))
        '()
        (cons (car lst) (first-n (- n 1) (cdr lst))))))

;; Check if first-n and take returns the same list,
;; uses the comp-elem written before

;;OBS! 'Take' cannot take n higher than the length of the input list
(define first-n-correct?
  (lambda (n lst)
    (let* [(first-lst (first-n n lst))
           (len-small (count-list first-lst))]
      (if (> n len-small)  
          (comp-elem first-lst (take lst len-small))
          (comp-elem first-lst (take lst n))))))

;; EXAMPLES
;(first-n-correct? 2 '(1 (4 6 one 9) 76 0)) -> #t
;(first-n-correct? 8  '(two (zero (one seven)) fourteen twentynine)) ->#t
;(first-n-correct? 0 '(1 (4 6 one 9) 76 0)) -> #t


;; Task 6
;; Returns a list with elements from a specific interval and steps
(define enumerate
  (lambda (from to step)
    (if (> from to)
        '()
        (cons from (enumerate (+ from step) to step)))))

;; Task 7
;; Returns a list in reverse order, recursive process
(define reverse-order-rek
  (lambda (lst)
    (if (null? lst)
        lst
        (add-to-back (car lst) (reverse-order-rek (cdr lst))))))

;;Creates a new list
;;in which elements are added to the back, like append
(define add-to-back
  (lambda (elem lst)
    (if (null? lst)
        (cons elem lst)
        (cons (car lst) (add-to-back elem (cdr lst))))))

;iterative version of reverse-order
(define reverse-order-iter
  (lambda (lst)
    (help-iter lst '())))

(define help-iter
  (lambda (lst1 lst2)
    (if (null? lst1)
        lst2
        (help-iter (cdr lst1) (cons (car lst1) lst2)))))

;; Task 8
;; Maps each element in list to a function and returns a new list with each
;; function applied to the elements

(define map-to-each
  (lambda (fn lst)
    (if (null? lst)
        lst
        (cons (fn (car lst)) (map-to-each fn (cdr lst))))))

;; Task 9
;; Inserts element at correct position in a sorted list
(define insert-at-asc-place
  (lambda (num lst)
    (cond
      ((or (null? lst) (<= num (car lst))) (cons num lst))
      (else (cons (car lst) (insert-at-asc-place num (cdr lst)))))))

;; Sort a list in accending order
(define insert-sort
  (lambda (lst)
    (help-insert-sort '() lst )))

(define help-insert-sort
  (lambda (sorted-lst unsorted-lst)
    (if (null? unsorted-lst)
        sorted-lst
        (help-insert-sort
         (insert-at-asc-place (car unsorted-lst) sorted-lst)
         (cdr unsorted-lst)))))

;; Task 10
;; Count ALL elements in list, including sublists
(define count-all
  (lambda (lst)
    (cond
      ((null? lst) 0)
      ((atom? lst) 1)
      ((pair? (car lst)) (+ (count-all (car lst)) (count-all (cdr lst))))
      (else (+ 1 (count-all (cdr lst)))))))

;; Special cases are for example is list is null or if list is an atom

;; Task 11
;; Predicat that checks if an element exist in a list
(define occurs?
  (lambda (elem lst)
    (if (pair? lst)
        (if (occurs? elem (car lst))
            #t
            (occurs? elem (cdr lst)))
        (eq? elem lst))))
;; There are not so much similarity between my count-all and occurs?
;; both are recursive

;; Task 12
;; Go through list and seek for elem in list and changes it to another value
(define subst-all
  (lambda (elem subst lst)
    (cond
      ((null? lst) '())
      ((atom? lst) (if (eq? lst elem)
                       subst
                       lst))
      ((pair? (car lst))
       (cons (subst-all elem subst (car lst)) (subst-all elem subst (cdr lst))))
      ((eq? (car lst) elem)
       (cons subst (subst-all elem subst (cdr lst))))
      (else
       (cons (car lst) (subst-all elem subst (cdr lst)))))))

;; Task 13
;; Returns a list with elements fullfilling the predicate
(define keep-if-all
  (lambda (pred lst)
    (cond
      ((null? lst) '())
      ((atom? lst) (if (pred lst)
                       lst
                       '()))
      ((pair? (car lst))
       (cons (keep-if-all pred (car lst)) (keep-if-all pred (cdr lst))))
      ((pred (car lst))
       (cons (car lst) (keep-if-all pred (cdr lst))))
      (else (keep-if-all pred (cdr lst))))))

;; Task 14
;; Predicate, compares two lists
(define list-equal?
  (lambda (lst1 lst2)
    (if (and (pair? lst1) (pair? lst2)) 
        (and (list-equal? (car lst1) (car lst2))
             (list-equal? (cdr lst1) (cdr lst2)))
        (eqv? lst1 lst2))))

(provide (all-defined-out))