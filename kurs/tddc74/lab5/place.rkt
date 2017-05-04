#lang racket
(provide place% connect-places!)

(define place%
  (class object%
    (init-field name
                description
                [fire #f]
                [pit #f]
                [walkable #t]
                [_neighbours (make-hash)]
                [_characters (make-hash)]
                [_exits (make-hash)]
                [_items (make-hash)])
    
    (define/public (get-name)
      name)
    
    (define/public (get-description)
      description)

    (define/public (get-pit)
      pit)

    (define/private (get-fire)
      fire)

    (define/public (get-neighbour exit-name)
      (hash-ref _neighbours exit-name))
    
    (define/public (neighbour-exist? direction)
      (hash-has-key? _neighbours direction))
    
    (define/public (add-neighbour! exit-name place)
      (hash-set! _neighbours exit-name place))
  
    (define/public (remove-neighbour! exit-name)
      (hash-remove! _neighbours exit-name))

    (define/public (exit-exist? direction)
      (hash-has-key? _exits direction))
    
    (define/public (exits)
      (hash-keys _exits))

    (define/public (add-exit! direction neighbour)
      (hash-set! _exits direction neighbour))
                             
    (define/public (neighbours)
      (hash-keys _neighbours))

    (define/public (walkable?)
      walkable)
    
    (define/public (make-not-walkable)
      (set! walkable #f))


    ;; same as get-fire but is created for easier code reading 
    (define/public (fire?)
      fire)
    
    (define/public (set-fire)
      (set! fire #t)
      (make-not-walkable))
    
    (define/public (extinguish-fire)
      (set! fire #f)
      (set! walkable #t))
    
    ;; same as get-pit but is created for easier code reading 
    (define/public (pit?)
      pit)
    
    (define/public (set-pit)
      (set! pit #t)
      (make-not-walkable))
    
    (define/public (add-character! character)
      (hash-set! _characters (send character get-name) character))

    (define/public (get-character character-name)
      (hash-ref _characters character-name))

    (define/public (delete-character! character-name)
      (hash-remove! _characters character-name))

    (define/public (character-exists? character-name)
      (hash-has-key? _characters character-name))
    
    (define/public (characters)
      (hash-values _characters))

    (define/public (add-item! item)
      (hash-set! _items (send item get-name) item))
           
    (define/public (remove-item! item-name)
      (hash-remove! _items item-name))

    (define/public (get-item item-name)
      (hash-ref _items item-name))

    (define/public (item-exist? item-name)
      (hash-has-key? _items item-name))
    
    (define/public (items)
      (hash-keys _items))
    
    (super-new)))


; ---------- public functions
(define (connect-places! place1 exit1 place2 exit2)
  (send place1 add-neighbour! exit1 place2)
  (send place2 add-neighbour! exit2 place1)
  (send place1 add-exit! exit1 place2)
  (send place2 add-exit! exit2 place1))