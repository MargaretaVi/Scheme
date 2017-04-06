#lang racket
(provide place% connect-places!)

(define place%
  (class object%
    (init-field name
                description
                [fire #f]
                [pit #f]
                [walkable #t]
                [*neighbours* (make-hash)]
                [*characters* (make-hash)]
                [*exits* (make-hash)]
                [*items* (make-hash)])
    
    (define/public (get-name)
      name)
    
    (define/public (get-description)
      description)

     (define/public (get-neighbour exit-name)
      (if (exit-exist? exit-name)
          (hash-ref *neighbours* exit-name)
          #f))
    
    (define/public (neighbour-exist? direction)
      (hash-has-key? *neighbours* direction))
    
    (define/public (add-neighbour! exit-name place)
      (hash-set! *neighbours* exit-name place))
  
    (define/public (remove-neighbour! exit-name)
      (if (neighbour-exist? exit-name)
          (hash-remove! *neighbours* exit-name)
          #f))

    (define/public (exit-exist? direction)
      (hash-has-key? *exits* direction))
    
    (define/public (exits)
      (hash-keys *exits*))

    (define/public (add-exit! direction neighbour)
      (hash-set! *exits* direction neighbour))
                             
    (define/public (neighbours)
      (hash-keys *neighbours*))

    (define/public (walkable?)
      (eqv? walkable #t))
    
    (define/private (get-fire)
      fire)

    (define/public (fire?)
      (eqv? fire #t))
    
    (define/public (get-pit)
      pit)
    
    (define/public (set-fire)
      (begin
        (set! fire #t)
        (set! walkable #f)))
    
    (define/public (extinguish-fire)
      (if (eqv? fire #f)
          #f
          (begin
            (set! fire #f)
            (set! walkable #t))))

    (define/public (pit?)
      (eqv? pit #t))
    
    (define/public (set-pit)
      (begin
        (set! pit #t)
        (set! walkable #f)))
    

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
      (if (character-exists? character-name)
          (begin
            (hash-remove! *characters* character-name)
            #t)
          #f))

    (define/public (character-exists? character-name)
      (hash-has-key? *characters* character-name))
    
    (define/public (characters)
      (hash-values *characters*))

    (define/public (add-item! item)
      (if (item-exist? (send item get-name))
          #f
          (begin
            (hash-set! *items* (send item get-name) item)
            #t)))

    (define/public (remove-item! item-name)
        (if (item-exist? item-name)
          (hash-remove! *items* item-name)
          #f))
         
    (define/public (get-item item-name)
      (if (item-exist? item-name)
          (hash-ref *items* item-name)
          #f))

    (define/public (item-exist? item-name)
      (hash-has-key? *items* item-name))
    
    (define/public (items)
      (hash-keys *items*))
    
    (super-new)))


; ---------- public functions
(define (connect-places! place1 exit1 place2 exit2)
  (send place1 add-neighbour! exit1 place2)
  (send place2 add-neighbour! exit2 place1)
  (send place1 add-exit! exit1 place2)
  (send place2 add-exit! exit2 place1))