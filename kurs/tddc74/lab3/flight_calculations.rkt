#lang racket
(require racket/serialize)
(require "database-creator.rkt")
(require "prettyprinter.rkt")
(require "flight_representation.rkt")


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
