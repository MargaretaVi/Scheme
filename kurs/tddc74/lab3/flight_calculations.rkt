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
    (let ((direct-db (make-direct-db from to flight-db (create-empty-database)))
          (connect-lst (make-connect-lst from to flight-db '())))
      (list (list 'direct-flights direct-db) (cons 'connecting connect-lst)))))
              
; Creates the direct-flight-db
(define make-direct-db
  (lambda (from to flight-db direct-flights-db)
    (cond
      ((empty-database? flight-db) direct-flights-db)
      ; flight has BOTH the same destination and origin?
      ((and (eqv? from (flight-origin (first-flight flight-db)))
            (eqv? to (flight-destination (first-flight flight-db))))
       (make-direct-db from to (rest-of-flights flight-db)
                       (add-to-db (first-flight flight-db) direct-flights-db)))
      ((make-direct-db from to (rest-of-flights flight-db)
                       direct-flights-db)))))

; Creates the connecting flights LIST
(define make-connect-lst
  (lambda (from to flight-db list-connecting-flights)
    (if (empty-database? flight-db)
        list-connecting-flights
        (let* ((top-flight (first-flight flight-db))
               (rest-db (rest-of-flights flight-db))
              (conn-tmp-db (connecting top-flight (flight-destination top-flight)
                                       to flight-db (create-empty-database))))
          (if (and (eqv? from (flight-origin top-flight))
                   (not (empty-database? conn-tmp-db)))
              (make-connect-lst from to rest-db
                                (cons (list top-flight conn-tmp-db)
                                      list-connecting-flights))
              (make-connect-lst from to rest-db
                                list-connecting-flights))))))
               
  
;; Function which creates a connecting database for a particular flight, if existing
(define connecting
  (lambda (flight from to flight-db connecting-flights-db)
    (let ((rest-of-db (rest-of-flights flight-db)))
      (if (empty-database? rest-of-db)
          (if (direct? flight from to)
              (add-to-db flight connecting-flights-db)
              connecting-flights-db)
          (if (direct? flight from to)
              (connecting (first-flight rest-of-db) from to
                          rest-of-db (add-to-db flight connecting-flights-db))
              (connecting (first-flight rest-of-db) from to
                          rest-of-db connecting-flights-db))))))

;; Predicate, is the flight is a direct flight?
(define direct?
  (lambda (flight from to)
    (and (eqv? from (flight-origin flight))
         (eqv? to (flight-destination flight)))))