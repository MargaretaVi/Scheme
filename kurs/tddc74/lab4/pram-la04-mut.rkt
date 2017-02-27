#lang racket
; This line sets the Racket printer in an altered mode, printing mutable
; pairs in a more readable way
(print-as-expression #f)

; 1a
(printf "1a~n")

(define start
  (let 
      ([p (mcons 'a (mcons 'b '()))])    
    (mcons p
           (mcons p 
                  (mcons 
                   (mcons 'a (mcons 'b '())) 
                   '())))))

(printf "start=~a~n" start)

(eq? (mcar start) (mcar (mcdr start)))
(eq? (mcar start) (mcar (mcdr (mcdr start))))

(newline)

; 1b
(printf "1b~n")
(set-mcar! (mcar start) 'x)
(printf "start=~a~n" start)


; 1c
(printf "1c~n")
(set-mcdr! start (mcdr (mcar (mcdr start))))
(printf "start=~a~n" start)

(newline)
; 1d

(printf "1d~n") (newline)
(set-mcar! (mcdr (mcar start)) 'y)
(printf "start=~a~n" start)
