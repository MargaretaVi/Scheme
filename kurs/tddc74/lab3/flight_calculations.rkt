#lang racket
(require racket/serialize)
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
    ;; first flight in database, flight destination, flight origin
    (let* ((direct-flight (create-empty-database))
           (connecting (create-empty-database))
           (cond
             ((empty-database? flight-db) flight-db)
               )
                       ;;direct flight
                       (let direct-flight (add-to-db fir-flight direct-flight))
                       (
             )))))
             

             

;; function that creates a db if there is a direct flight between origin and destination
(define check-dir-flight
  (lambda (flight-db from to)
    (let* ((fir-flight (first-flight flight-db)) 
           (flight-dest (flight-destination fir-flight))
           (flight-orig (flight-origin fir-flight))
           (if (and (eq? from flight-orig) (eq? to flight-dest))
              (

           
           