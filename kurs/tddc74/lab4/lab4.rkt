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

;; Task 3 & 4
;; Pratat med Anders

;; Task 5
;;Fucntion which count how many times it has been called, can be reseted

(define count-calls
  (let ((count 0))
    (lambda ...
       (cond
        ((null? ...)
         (set! count (+ count 1)))
        ((equal? (car ...) 'how-many-calls) count)
        (else (equal? (car ...) 'reset)
         (set! count 0))))))

; This version of count-calls is so that I can easier see how the let converts to a lambda
(define count-calls2
  ((lambda (count)
     (lambda ...
       (cond
         ((null? ...) (set! count (+ count 1)))
         ((equal? (car ...) 'how-many-calls) count)
         (else (equal? (car ...) 'reset) (set! count 0)))))
     0))

;; Task 6
; Enviroment diagram for task 5


;; Task 7
;Function created a new function with internal counter
(define make-monitored
  (lambda (fn)
    (let ((count 0))
      (lambda ...
        (cond
          ((equal? (car ...) 'how-many-calls) count)
          ((equal? (car ...) 'reset) (set! count 0))
          (else (begin
                  (set! count (+ count 1))
                  (apply fn ... ))))))))

(define make-monitored2
  (lambda (fn)
    ((lambda (count)
      (lambda ...
        (cond
          ((equal? (car ...) 'how-many-calls) count)
          ((equal? (car ...) 'reset) (set! count 0))
          (else (begin
                  (set! count (+ count 1))
                  (apply fn ...))))))
      0)))

(define monitored-max (make-monitored2 max))
;; Task 8
; Enviroment diagram

; Task 9

(define (rev2 lst)
  (define (rev-iter lst res)
    (if (null? lst)
        res
        (rev-iter (cdr lst) (cons (car lst) res))))
  (rev-iter lst '()))

#|
(define (rev lst)
  ;local variable 
    (let ((res '()))
      (define (loop)
        (cond
          [(null? lst) res]
          [else (begin
             (set! res (cons (car lst) res))
             (set! lst (cdr lst)))   
           (loop)])))
  (loop))

|#

#|
; Task 10

(define writer
  (lambda (line file)
    (if (file-exist? file)
        (let ((tmp-file (open-input-file file)))

        (let ((tmp-file (open-output-file file)))
          
|#      
      