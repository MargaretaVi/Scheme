;; quicksort-skel.scm

;; Place this file in your ~/TDDC74/lab02 folder and load it in your 
;; pram-la02.scm file by inserting the following expression at the top
;; of pram-la02.scm:
;; (load "quicksort-skel.scm")

;; singleton?: list -> boolean
;; Returns true if list contains exactly one element.
(define (singleton? list)
  (and (list? list)
       (not (null? list))
       (null? (cdr list))))


;; quicksort: list -> list
;; Takes a list of numbers as argument and returns a list of numbers 
;; sorted in ascending order.
(define (my-quicksort lon)
  (cond
    ((null? lon) '())
    ((singleton? lon) lon)
    (else (let ((parts (partition (car lon) (cdr lon))))
            (append (my-quicksort (car parts))
                    (list (car lon))
                    (my-quicksort (cdr parts)))))))

;; partition: number x list -> (list . list)
;; Takes two arguments, pivot (a number) and lon (list of numbers) and
;; returs a pair of the lists. The first list in the pair contains all
;; elements smaller than or equal to the pivot element and the second
;; list contains all elements greater than the pivot element

(define (partition pivot lon)
  ;; your code here (complete it in pram-la02.scm)
  #f) 


(define (random-list low high n)
  (if (= n 0)
      '()
      (cons (+ low (random (+ (- high low) 1)))
	    (random-list low high (- n 1)))))