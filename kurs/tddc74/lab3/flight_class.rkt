#lang racket
(require racket/serialize)

(provide  
 make-flight flight-origin flight-destination flight-departure flight-arrival
 flight-airline flight-number 
 create-empty-database add-to-db first-flight rest-of-flights empty-database?)

;; Initial representation of the flight database.

;; This file will not be used once you have tried out your flight_calculations,
;; and started working on your own representation.

;; We'll learn more about proper object orientation in lab 5! Here we mostly
;; use the object system to create 


(define-serializable-class flight% object%
  (init-field [airline ""]
              [origin ""]
              [desination ""]
              [flight-number 0]
              [departure 0]
              [arrival 0])
  
  (define/public (get-airline) airline)
  (define/public (get-origin) origin)
  (define/public (get-desination) desination)
  (define/public (get-flight-number) flight-number)
  (define/public (get-deparute) departure)
  (define/public (get-arrival) arrival)
  
  (super-new))


(define-serializable-class database% object%
  
  (init-field [db '()])
  
  (define/public (add-item item)
    ;; Eftersom syftet här är att returnera en ny databas,
    ;; snarare än att ändra hur ett visst objekt har för innehåll,
    ;; returneras en ny databas. I labb 5 ser vi mer på objekt
    ;; med tillstånd.
    (new database% [db (cons item db)]))
  (define/public (get-first) (car db))
  (define/public (get-rest) (new database% [db (cdr db)]))
  (define/public (empty?) (null? db))
  
  (super-new))

;Problem 14
(define (make-flight airline_ origin_ destination_ flight# departure_ arrival_)
  (new flight% 
       [airline airline_]
       [origin origin_]
       [desination  destination_]
       [flight-number flight#]
       [departure departure_]
       [arrival arrival_]))

;Problem 16
(define (flight-airline flight)
  (send flight get-airline))

(define (flight-origin flight)
  (send flight get-origin))

(define (flight-destination flight)
  (send flight get-desination))

(define (flight-number flight)
  (send flight get-flight-number))

(define (flight-departure flight)
  (send flight get-deparute))

(define (flight-arrival flight)
  (send flight get-arrival))

;Problem 15
(define (add-to-db item database)
  (send database add-item item))

(define (create-empty-database)
  (new database%))

(define (empty-database? database)
  (send database empty?))

(define (first-flight database)  
  (send database get-first))

(define (rest-of-flights database)
  (send database get-rest))

