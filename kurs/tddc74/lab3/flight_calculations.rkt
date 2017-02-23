#lang racket
(require racket/serialize)
(require racket/trace)
(require "database-creator.rkt")
(require "prettyprinter.rkt")
(require "flight_representation.rkt")

;(write-and-create 1000 "test-1000.db")
(define flights
  ;; The database imported is called "test-1000.db".
  ;; If you have another database file to import, change this here!
  (let*
      ([port (open-input-file "test-1000.db")]
       [serialized-object (read port)])
    (close-input-port port)
    (deserialize serialized-object)))

;; To pretty-print a flight (human-readable), try (print-flight <flight>)
;; To pretty-print a flight database, try (print-db <flight database>).
;; Eg (print-db flights)

(define flights-from-to
  (lambda (from to flight-db)
    (let* ((direct-flights-db (create-empty-database))
           (connecting-flights-db (create-empty-database)))
      (go-through-db from to flight-db
                     direct-flights-db connecting-flights-db '()))))

(define go-through-db
  (lambda (from to flight-db direct-flights-db connecting-flights-db list-connecting-flights)
    (if (empty-database? flight-db)
        (list (list 'direct-flights direct-flights-db ) (list 'connecting list-connecting-flights))
        ;(print-db list-connecting-flights)
        (let ((top-flight (first-flight flight-db)))
          (if (direct? top-flight from to)
              (go-through-db from to (rest-of-flights flight-db) (add-to-db top-flight direct-flights-db) connecting-flights-db list-connecting-flights)
              (connecting top-flight from to flight-db
                          direct-flights-db connecting-flights-db list-connecting-flights))))))

;; predicate, is the flight is a direct flight?
(define direct?
  (lambda (flight from to)
    (and (equal? from (flight-origin flight))
         (equal? to (flight-destination flight)))))

;; if there is a connecting airport then add to the database else go to next flight
(define connecting
  (lambda (flight from to flight-db direct-flights-db connecting-flights-db list-connecting-flights )
    ;;origin2 is the connecting airport
    (if (direct? flight (flight-destination flight) to)
        (make-connecting-database flight from to flight-db flight-db direct-flights-db connecting-flights-db list-connecting-flights)
        (go-through-db from to (rest-of-flights flight-db)
                       direct-flights-db connecting-flights-db list-connecting-flights))))
          
(define make-connecting-database
  (lambda (flight from to flight-db flight-db2 direct-flights-db connecting-flights-db list-connecting-flights)
    (if (not (empty-database? flight-db2))
        ; connecting airport
        (if (direct? flight (flight-destination flight) to)
            ;loop untill database is empty, to find connecting flights
            (make-connecting-database flight from to flight-db (rest-of-flights flight-db2)
                           direct-flights-db (add-to-db flight connecting-flights-db) list-connecting-flights)
            ;there is no connecting flights 
            (go-through-db from to (rest-of-flights flight-db)
                           direct-flights-db (create-empty-database) list-connecting-flights))
        (go-through-db from to (rest-of-flights flight-db)
                       direct-flights-db (create-empty-database) (list flight connecting-flights-db)))))

