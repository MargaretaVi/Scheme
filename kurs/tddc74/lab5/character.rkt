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
      (set! place new-place))
    
    (define/public (get-inventory)
      (hash-values *inventory*))
    
    (define/public (get-item item-name)
      (hash-ref *inventory* item-name))

    (define/public (receive item giver)
      (hash-set! *inventory* item item)
      (send giver drop item))
    
    (define/public (give item-name recipient)
      (send recipient pick-up item-name)
      (hash-remove! *inventory* item-name))

    (define/public (add-item! item)
      (hash-set! *inventory* (send item get-name) item))
    
    (define/public (remove-item! item-name)
          (hash-remove! *inventory* item-name))
    
    (define/public (has-item? item-name)
      (hash-has-key? *inventory* item-name))

    (define/public (alive?)
      living)
    
    (super-new)))
