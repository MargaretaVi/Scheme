#lang racket
(require racket/trace)
;; Task 1
(define (foo bar)
  bar)

(define (bar foo)
  (display foo))

;; Task 2
;; Taskes a function and a list as inparameters and returns nothing but applies
;; the function on each element in the list

(define for-each-element
  (lambda (proc lst)
    (if (null? (cdr lst))
        (void (proc (car lst)))
        (begin
          (void (proc (car lst)))
          (for-each-element proc (cdr lst))))))
              
;; Task 3 & 4
;; Pratat med Anders

;; Task 5
;; Function which count how many times it has been called, can be reseted

(define count-calls
  (let ((count 0))
    (lambda ...
       (cond
        ((null? ...)
         (set! count (+ count 1)))
        ((equal? (car ...) 'how-many-calls) count)
        (else (equal? (car ...) 'reset)
         (set! count 0))))))

#|
; This version of count-calls is so that I can easier see how the let converts to a lambda
(define count-calls2
  ((lambda (count)
     (lambda ...
       (cond
         ((null? ...) (set! count (+ count 1)))
         ((equal? (car ...) 'how-many-calls) count)
         (else (equal? (car ...) 'reset) (set! count 0)))))
     0))
|#
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

#| Just for easiter to draw the environment diagram
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
|#
;; Task 8
;; Enviroment diagram

;; Task 9
;; Iterative function that reverses a list

(define (rev lst)
  ;local variable 
  (let ((res '()))
    (define loop
      (lambda ()
        (cond
          [(null? lst) res]
          [else (begin
                  (set! res (cons (car lst) res))
                  (set! lst (cdr lst)))   
                (loop)])))
    (loop)))

; Task 10
(define writer
  (lambda (line filename [op -])
  (if (file-exists? filename)
       (if (equal? op +)
           (append-file line filename)
           (create-file line filename))
       (create-file line filename))))

;Function creates/overwrite an existing file                                  
(define create-file
  (lambda (line file)
    (let ((tmp-file (open-output-file file #:exists 'replace)))
      (write line tmp-file)
      (newline tmp-file)
      (close-output-port tmp-file))))
    
; Function appends information to the end of an existing file                
(define append-file
  (lambda (line file)
    (let ((tmp-file (open-output-file file #:exists 'append)))
      (write line tmp-file)
      (newline tmp-file)
      (close-output-port tmp-file))))

