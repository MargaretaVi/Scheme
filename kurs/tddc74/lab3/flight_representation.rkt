#lang racket
;(require "flight_class.rkt")
(provide  
 make-flight flight-origin flight-destination flight-departure flight-arrival
 flight-airline flight-number 
 create-empty-database add-to-db first-flight rest-of-flights empty-database?)

;; Do not change the provide line!

;; It enables other files where you write (require "flight_representation.rkt")
;; to access the values behind the names below. That is, in that separate
;; module, you can use make-flight, flight-origin... even if they are defined
;; here, or exported from flight_class.rkt.

;; A side note: This is why we write (provide (all-defined-out)) before running
;; autotests. This exports all the local names, so the autotest module can access
;; them.

;; You don't need to know how the Racket module system works in detail in this lab
;; series (possibly project). 


;; ---------------- Your implementation goes here
;; Uncomment this, and remove/comment out the require line above, so you use
;; your definitions rather than the ones in flight_class.rkt.

(define-serializable-class flight% object%
    (init-field company
                origin
                destination
                flight-number
                departure
                arrival)
    (define/public (get-airline)
      company)
    (define/public (get-origin)
      origin)
    (define/public (get-destination)
      destination)
    (define/public (get-flight-number)
      flight-number)
    (define/public (get-departure)
      departure)
    (define/public (get-arrival)
      arrival)
    (super-new))

(define-serializable-class database% object%
  (init-field [database'()])
  (define/public (empty?)
    (null? database))
  (define/public (add-flight item)
    (new database% [database (cons item database)]))
  (define/public (get-first-flight)
    (car database))
  (define/public (get-rest-database)
    (new database% [database (cdr database)]))
  
  (super-new))

;Problem 3
(define (make-flight company from to flight-number departure arrival)
  (new flight%
       [company company]
       [origin from]
       [destination to]
       [flight-number flight-number]
       [departure departure]
       [arrival arrival]))

;Problem 4
(define (flight-airline flight)
  (send flight get-airline))

(define (flight-origin flight)
  (send flight get-origin))

(define (flight-destination flight)
  (send flight get-destination ))

(define (flight-number flight)
  (send flight get-flight-number ))

(define (flight-departure flight)
  (send flight get-departure ))

(define (flight-arrival flight)
  (send flight get-arrival ) )

;Problem 5
(define (add-to-db item database)
  (send database add-flight item))

(define (create-empty-database)
  (new database%))

(define (empty-database? database)
  (send database empty?))

(define (first-flight database)
  (send database get-first-flight))

(define (rest-of-flights database)
  (send database get-rest-database))
