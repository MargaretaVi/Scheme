#lang racket
(provide character%)

(define character%
  (class object%
    (init-field
     description
     name
     talk-line
     [living #t]
     [*inventory* (make-hash)]
     [place #f]
     )
    
    (define/public (get-place)
      place) 
    (define/public (get-description)
      description) 
    (define/public (get-name)
      name) 
    (define/public (get-talk-line)
      talk-line) 
    (define/public (killed)
      (set! living #f)) 
    (define/public (move-to new-place)
      (if (eqv? place new-place)
          #f
          (begin
            (set! place new-place)          
            #t))) 
    (define/public (get-inventory)
      (hash-values *inventory*))

    (define/public (get-inventory2)
      *inventory*)
    
    (define/public (get-item item-name)
      (if (has-item? item-name)
          (hash-ref *inventory* item-name)
          #f))
    
    (define/public (receive item giver)
      (if (eqv? place (send giver get-room))
          (begin
            (hash-set! *inventory* item item)
            (send giver drop item))
          (display "Reciever and giver is not in the same room")))
    
    (define/public (give item-name recipient)
      (begin
        (if (has-item? item-name)
            (begin
              (send recipient pick-up item-name)
              (hash-remove! *inventory* item-name))
            #f)))

    (define/public (add-item! item)
      (if (has-item? (send item get-name))
          #f
          (begin
            (hash-set! *inventory* (send item get-name) item)
            #t)))

    (define/public (remove-item! item-name)
      (if (has-item? item-name)
          (hash-remove! *inventory* item-name)
          #f))
    
    (define/public (has-item? item-name)
      (hash-has-key? *inventory* item-name))

    (define/public (alive?)
      (eqv? living #t))
    
    (super-new)))
