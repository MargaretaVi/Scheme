#lang racket
(provide character%)

(define character%
  (class object%
    (init-field
     description
     name
     talk-line
     place
     [living #t]
     [_inventory (make-hash)]
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
      (send place delete-character! (send this get-name))
      (send new-place add-character! this)
      (set! place new-place))
          
    (define/public (get-inventory)
      (hash-values _inventory))
    
    (define/public (get-item item-name)
      (hash-ref _inventory item-name))

    (define/public (add-item! item)
      (hash-set! _inventory (send item get-name) item))
    
    (define/public (receive item-name giver)
      (add-item! (send giver get-item item-name))
      (send giver remove-item! item-name))
       
    (define/public (give item recipient)
      (send recipient add-item! item)
      (send this remove-item! (send item get-name)))

    (define/public (drop item)
      (send place add-item! item)
      (hash-remove! _inventory item))
    
    (define/public (remove-item! item-name)
      (hash-remove! _inventory item-name))
    
    (define/public (has-item? item-name)
      (hash-has-key? _inventory item-name))

    (define/public (alive?)
      living)
    
    (super-new)))
