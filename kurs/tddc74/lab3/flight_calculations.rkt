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
           (connecting-flights-db (create-empty-database))
           (list-connecting-flights '()))
      (create-databases from to flight-db direct-flights-db
                     connecting-flights-db list-connecting-flights))))


(define create-databases
  (lambda (from to flight-db direct-flights-db connecting-flights-db
                list-connecting-flights)
    (if (empty-database? flight-db)
        (list (list 'direct-flights direct-flights-db)
              (cons 'connecting list-connecting-flights))
        (let ((top-flight (first-flight flight-db)))
          (if (eqv? from (flight-origin top-flight))
              ;flight goes from the correct airport
              (if (eqv? to (flight-destination top-flight))
                  (create-databases from to (rest-of-flights flight-db)
                                    (add-to-db top-flight direct-flights-db)
                                    connecting-flights-db list-connecting-flights)
                  ;possible connecting airport
                  (check-connecting-flights
                   from to flight-db direct-flights-db connecting-flights-db
                   list-connecting-flights))
              (create-databases from to (rest-of-flights flight-db)
                                    direct-flights-db connecting-flights-db
                                    list-connecting-flights))))))


;This function check if there are any connecting flights for any legit flights
;if so then it will create that list ((flight + db) (flight + db)...)
(define check-connecting-flights
  (lambda (from to flight-db direct-flights-db connecting-flights-db
                list-connecting-flights)
    (let* ((top-flight (first-flight flight-db))
            (conn-tmp-db (connecting top-flight
                                      (flight-destination top-flight)
                                      to flight-db (create-empty-database)))
            (rest-of-db (rest-of-flights flight-db)))
      (if (not (empty-database? conn-tmp-db))
          ;connecting flights
          (create-databases from to rest-of-db direct-flights-db
                            connecting-flights-db
                            (cons (list top-flight conn-tmp-db)
                               list-connecting-flights))
          (create-databases from to rest-of-db
                         direct-flights-db connecting-flights-db
                         list-connecting-flights)))))   
     
;Function which creates a connecting database for a particular flight, if existing
(define connecting
  (lambda (flight from to flight-db connecting-flights-db)
    (let* ((rest-of-db (rest-of-flights flight-db)))
      (if (empty-database? rest-of-db)
          (if (direct? flight from to)
              (add-to-db flight connecting-flights-db)
              connecting-flights-db)
          (if (direct? flight from to)
              (connecting (first-flight rest-of-db) from to
                          rest-of-db (add-to-db flight connecting-flights-db))
              (connecting (first-flight rest-of-db) from to
                          rest-of-db connecting-flights-db))))))

;; predicate, is the flight is a direct flight?
(define direct?
  (lambda (flight from to)
    (and (eqv? from (flight-origin flight))
         (eqv? to (flight-destination flight)))))