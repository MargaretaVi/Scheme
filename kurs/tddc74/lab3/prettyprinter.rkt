#lang racket
(require "flight_representation.rkt")


(provide
 pretty-print print-flight print-db)


;; pretty-print :: list -> 
;; Takes a result-structure from the flight_connection task
;; and prints the content.

;; The format of the input should be
;; ( <database of direct flights> 
;;   (<flight1> <connecting to flight1>)
;;   (<flight2> <connecting to flight2>)
;;     ...)
(define (pretty-print result-structure)
  (let 
      ([direct-flights (cadar result-structure)]
       [connections (cdadr result-structure)])
    (printf "----- Direct flights:~n")
    (print-db direct-flights)
    (printf "~n----- Indirect flights:~n")
    (for-each print-two-leg connections)
    (printf "****~n")))



;; print-flight : flight -> 
;; Takes a flight, and prints the information contained on the screen.
;; Note that we don't have any knowledge of how the flight is represented.
(define (print-flight flight)
  (printf "~a-~a, flight ~a~a. Time ~a-~a~n"           
          (flight-origin flight)
          (flight-destination flight)
          (flight-airline flight)
          (flight-number flight)
          (reformat-time (flight-departure flight))
          (reformat-time (flight-arrival flight))))




;; Time is stored as integers, not HH:MM. This returns the string.
(define (reformat-time t)
  (let*
     ((hh (quotient t 100))
      (mm (remainder t 100))
      (mstr 
       (cond
         [(< mm 10) (string-append "0" (number->string mm))]
         [else (number->string mm)]))
      (hstr 
       (cond 
         [(< hh 10) (string-append "0" (number->string hh))]
         [else (number->string hh)])))
    (string-append hstr ":" mstr)))

;; print-connection flight
;; Prints a connecting flight.
(define (print-connection flight)
  (printf "-> ")
  (print-flight flight))

;; for-each-flight : (flight -> X) x database -> 
;; Applies f to every flight in the database, without
;; collecting the results.
(define (for-each-flight f db)
  (cond
    [(empty-database? db) (void)]
    [else
     (f (first-flight db))
     (for-each-flight f (rest-of-flights db))]))

;; print-db : database -> 
;; Prints every flight in a database.
(define (print-db db)
  (for-each-flight print-flight db))

;; print-two-leg flight-list
;; Takes a list (<flight> <database>)
;; and prints it.
(define (print-two-leg flight-list)
  (let
      ([first-leg (car flight-list)]
       [db-of-connecting (cadr flight-list)])
    (print-flight first-leg)
    (for-each-flight print-connection db-of-connecting)
    (printf "~n")))


