#lang racket
(require "flight_class.rkt")
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


#|

;; ---------------- Your implementation goes here
;; Uncomment this, and remove/comment out the require line above, so you use
;; your definitions rather than the ones in flight_class.rkt.

;Problem 3
(define (make-flight airline origin destination flight# departure arrival)
  'your-code-goes-here)

;Problem 4
(define (flight-airline flight)
  'to-implement)

(define (flight-origin flight)
  'to-implement)

(define (flight-destination flight)
  'to-implement)

(define (flight-number flight)
  'to-implement)

(define (flight-departure flight)
  'to-implement)

(define (flight-arrival flight)
  'to-implement)

;Problem 5
(define (add-to-db item database)
  'to-implement)

(define (create-empty-database)
  'to-implement)

(define (empty-database? database)
  'to-implement)

(define (first-flight database)
  'to-implement)

(define (rest-of-flights database)
  'to-implement)
|#