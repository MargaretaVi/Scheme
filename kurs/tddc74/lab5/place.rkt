#lang racket
(provide place% connect-places!)

(define place%
  (class object%
    (init-field name
                description
                [fire #f]
                [pit #f]       
                [*neighbours* (make-hash)]
                [*characters* (make-hash)]
                [*exits* (make-hash)]
                [*items* (make-hash)])
    
    ;speific for the place-class 
    (define/public (get-name)
      name)
    
    (define/public (get-description)
      description)

     (define/public (get-neighbour exit-name)
      (if (hash-has-key? *neighbours* exit-name)
          (hash-ref *neighbours* exit-name)
          #f))
    
    (define/public (add-neighbour! exit-name place)
      (hash-set! *neighbours* place exit-name))
  
    (define/public (remove-neighbour! exit-name)
      (if (hash-has-key? *neighbours* exit-name)
          (hash-remove! *neighbours* exit-name)
          #f))
    
    (define/public (exits)
      (hash-keys *exits*))

    (define/public (set-exit direction place)
      (hash-set! *exits* direction place))
                             
    (define/public (neighbours)
      (hash-keys *neighbours*))

    (define/private (get-fire)
      fire)

    (define/public (fire?)
      (eqv? fire #t))
    
    (define/public (get-pit)
      pit)
    
    (define/private (make-fire)
      (set! fire #t))
    
    (define/public (extinguish-fire)
      (set! fire #f))
    
    (define/private (make-pit)
      (set! pit #t))

    ;characters
    (define/public (add-character! character)
      (if (hash-has-key? *characters* character)
          #f
          (begin
              (hash-set! *characters* (send character get-name) character)
              #t)))
    
    (define/public (get-character character-name)
      (if (hash-has-key? *characters* character-name)
          (hash-ref *characters* character-name)
          #f))
    
    (define/public (delete-character! character-name)
      (if (hash-has-key? *characters* character-name)
          (begin
            (hash-remove! *characters* character-name)
            #t)
          #f))
    
    (define/public (characters)
      (hash-keys *characters*))

    (define/public (add-item! item)
        (if (hash-has-key? *items* item)
          #f
          (begin
              (hash-set! *items* (send item get-name) item)
              #t)))

    (define/public (remove-item! item-name)
        (if (hash-has-key? *items* item-name)
          (hash-remove! *items* item-name)
          #f))
         
    (define/public (get-item item-name)
      (if (hash-has-key? *items* item-name)
          (hash-ref *items* item-name)
          #f))

    (define/public (items)
      (hash-keys *items*))
    
    (super-new)))

(define (connect-places! place1 exit1 place2 exit2)
  (send place1 add-neighbour! exit1 place2)
  (send place2 add-neighbour! exit2 place1))