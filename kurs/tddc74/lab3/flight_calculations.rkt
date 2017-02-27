#lang racket
(require racket/serialize)
(require racket/trace)
(require "database-creator.rkt")
(require "prettyprinter.rkt")
(require "flight_representation.rkt")

(write-and-create 1000 "test-1000.db")
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
           (connecting-flights-db (create-empty-database))
           (list-connecting-flights '()))
      (go-through-db from to flight-db direct-flights-db
                     connecting-flights-db list-connecting-flights))))


(define go-through-db
  (lambda (from to flight-db direct-flights-db connecting-flights-db
                list-connecting-flights)
    (if (empty-database? flight-db)
        (list (list 'direct-flights direct-flights-db)
              (add-to-list 'connecting list-connecting-flights))
        ;list-connecting-flights
        (let ((top-flight (first-flight flight-db)))
          (if (equal? from (flight-origin top-flight))
              ;flight goes from the correct airport
              (if (equal? to (flight-destination top-flight))
                  (go-through-db from to (rest-of-flights flight-db)
                                 (add-to-db top-flight direct-flights-db)
                                 connecting-flights-db list-connecting-flights)
                  ;possible connecting airport
                  (if (not (empty-database? (connecting top-flight
                                             (flight-destination top-flight)
                                             to flight-db
                                             (create-empty-database))))
                      (go-through-db from to (rest-of-flights flight-db)
                                     direct-flights-db connecting-flights-db
                                     (add-to-list (list top-flight 
                                                   (connecting top-flight 
                                                    (flight-destination top-flight)
                                                    to flight-db
                                                    (create-empty-database))) 
                                                  list-connecting-flights))
                      (go-through-db from to (rest-of-flights flight-db)
                                     direct-flights-db connecting-flights-db
                                     list-connecting-flights)))   
              (go-through-db from to (rest-of-flights flight-db)
                             direct-flights-db connecting-flights-db
                             list-connecting-flights))))))

;Function returns a new listw with new_entry appended to the old list             
(define add-to-list
  (lambda (lst new_entry)
    (cons lst new_entry)))

;; predicate, is the flight is a direct flight?
(define direct?
  (lambda (flight from to)
    (and (equal? from (flight-origin flight))
         (equal? to (flight-destination flight)))))

;Function which creates a connecting database for a particular flight, if existing
(define connecting
  (lambda (flight from to flight-db connecting-flights-db)
    ;(flight-destination flight) = orign of flight2
    (if (empty-database? (rest-of-flights flight-db))
        (if (direct? flight from to)
            (add-to-db flight connecting-flights-db)
            connecting-flights-db)
        (if (direct? flight from to)
            (connecting (first-flight (rest-of-flights flight-db)) from to
                        (rest-of-flights flight-db)
                        (add-to-db flight connecting-flights-db))
            (connecting (first-flight (rest-of-flights flight-db)) from to
                        (rest-of-flights flight-db)
                        connecting-flights-db)))))

