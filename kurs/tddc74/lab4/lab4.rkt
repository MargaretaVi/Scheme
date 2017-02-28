#lang racket
(require racket/trace)
;; Task 1
(define (foo bar)
  bar)

(define (bar foo)
  (display foo))

;; Task 2
;; Function which applies a procedure to each element in list
;; and returns them as a new list
(define for-each-element
  (lambda (proc lst)
    (if (null? (cdr lst))
        (proc (car lst))
        (for-each-element proc (cdr lst)))))

;; Task 5
;;Fucntion which count how many times it has been called, can be reseted

(define count-calls
  (let ((count 0))
    (lambda ...
       (cond
        ((null? ...)
         (set! count (+ count 1)))
        ((equal? (car ...) 'how-many-calls) count)
        ((equal? (car ...) 'reset)
         (set! count 0))))))


;; Task 6