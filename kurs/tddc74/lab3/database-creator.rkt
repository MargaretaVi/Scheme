#lang racket
(require racket/serialize)
(require "flight_representation.rkt")


(provide database-creator write-and-create)

;; Creates databases for testing
;; Ex: (database-creator 100) creates a database with 100 flights

;; Ex: (write-and-create 100 "small-db.rkt") generates a database with
;; 100 flights, and writes code in small-db.rkt that binds the variable flights 
;; to that database, when you run (require "small-db.rkt").

;; NOTE: This uses the ADTs defined externally. So if you've 
;; changed something there, the databases generated will conform to the new standard.

;; Actual IATA-standard data.
(define airlines '(SK D8 TK DL UA KN FR SU BA J2 PK KL))
(define locationlocationlocation   
  '(GOT ARN LAX NYC TLV DEL LHR STN NYO MEX ICN BML SXF SVO HEM HEL PEK ALA TSE SYD CDG CPH HND FNJ)) 

(define num-airlines (length airlines))
(define num-locations (length locationlocationlocation))

(define (random-clock)  
  
  (+ (* 100 (random-from-to 0 23)) (random-from-to 0 59)))

(define (randomlocation nr db)
  (if (= 1 nr)
      (car db)
      (randomlocation (- nr 1) (cdr db))))

(define (database-creator nr)
  (let ((db (create-empty-database)))
    (define (loop n)
      (if (= n 0)
          db
          (begin (set! db (add-to-db
                  (make-flight 
                   (randomlocation (random-from-to 1 num-airlines) airlines) 
                   (randomlocation (random-from-to 1 num-locations) locationlocationlocation) 
                   (randomlocation (random-from-to 1 num-locations) locationlocationlocation) 
                   (random-from-to 0 10000) 
                   (random-clock) 
                   (random-clock))
                  db))
                 (loop (- n 1)))))
    (loop nr)))


;;Example call (write-and-create 100 "small-db.db")
;;This will OVERWRITE the file with filename (if it exists), so make sure that it isn't something you want to keep.
;;Take a look at this again when working on the IO assignments in lab 4.
(define (write-and-create nr filename)
  (define outport (open-output-file filename #:mode 'binary #:exists 'replace))
  (write (serialize (database-creator nr)) outport)
  (close-output-port outport))

(define (random-from-to from to)
  (+ from (random (+ 1 (- to from)))))