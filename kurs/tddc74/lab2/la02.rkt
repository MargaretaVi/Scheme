#lang racket
;; laboration 2
;; Task 1
(require racket/trace)
(provide (all-defined-out))

(define foo (cons 2 3))
(define bar (list 2 3))
(define forex (cons 2 (cons 3 4)))
(define tesco (list 2 bar))

;; se inlämnat papper

;; uppgift 2
;; Predicate, check if the input is an atom
(define atom?
  (lambda (input)
    (and (not (pair? input)) (not (null? input)))))

;; uppgift 3
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
        0
        (+ 1 (count-elements (cdr lst) count)))))

;; Check if count-list returns the same value as length
(define count-list-correct?
  (lambda (lst)
    (= (count-list lst) (length lst))))

;; LÄGG TILL EXEMPLAR!

;; Task 3
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

;; help function for keep-if-correct,
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
(define first-n
  (lambda (n lst)
    (if (> n (count-list lst))
        lst
        (extract-from-list n lst (count-list lst)))))

;; help function to first-n
(define extract-from-list
  (lambda (n lst num-elem)
    (if (> n 0)   
        (cons (car lst) (extract-from-list (- n 1) (cdr lst) num-elem))
        '())))

;; Check if first-n and take returns the same list,
;; uses the comp-elem written before
(define first-n-correct?
  (lambda (n lst)
    (comp-elem (first-n n lst) (take lst n))))

;; TEZTEXEMPLES!!!

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
        (append-elem (car lst) (reverse-order-rek (cdr lst))))))

(define append-elem
  (lambda (elem lst)
    (if (null? lst)
        (cons elem lst)
        (cons (car lst) (append-elem elem (cdr lst) )))))

;; EJ KLAR!!!
;iterative version of reverse-order
(define reverse-order-iter
  (lambda (lst)
    (if (null? lst)
        lst
        (help-iter lst))))

(define help-iter
  (lambda (lst)
    (+ 0)))

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
        (help-insert-sort (insert-at-asc-place (car unsorted-lst) sorted-lst) (cdr unsorted-lst)))))

;; Task 10
;; Count ALL elements in list, even though in sublists
(define count-all
  (lambda (lst)
    (if (pair? lst)
        (+ (count-all (car lst)) (count-all (cdr lst)))
        ;; atom? then add 1
        1)))

;; Special cases are for example is list is null

;; Task 11
;; Predicat that checks if an element exist in a list
(define occurs?
  (lambda (elem lst)
    (if (pair? lst)
        (if (occurs? elem (car lst))
            #t
            (occurs? elem (cdr lst)))
        ;; atom? compare elem with list
        (eq? elem lst))))

;; The difference between count-all and occurs? are what is done in the if-cases
;; othervise the skeleton looks the same

;; Task 12
;; Go through list and seek for elem in list and substitute it with subst

(define subst-all
  (lambda (elem subst lst)
    (cond
      ((null? lst) '())
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
            
(define (not-num? o)
  (not (number? o)))

;; Task 14
;; Predicate,  compares two lists
(define list-equal?
  (lambda (lst1 lst2)
    (cond
      ((if(null? lst1)
          (null? lst2)
          #f))
      ((if(null? lst2)
          (null? lst1)
          #f))
      ((if (and (pair? lst1) (pair? lst2))
           (if (list-equal? (car lst1) (car lst2))
               (list-equal? (cdr lst1) (cdr lst2))
               #f)
           (eqv? lst1 lst2))))))

             
(trace list-equal?)


(provide (all-defined-out))