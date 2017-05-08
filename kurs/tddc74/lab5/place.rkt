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

    ;Returns the member name
    (define/public (get-name)
      name)

    ;Returns the member description
    (define/public (get-description)
      description)

    ;Returns the member pit
    (define/public (get-pit)
      pit)

    ;Returns the member fire
    (define/public (get-fire)
      fire)

    ;Returns an object
    (define/public (get-neighbour exit-name)
      (hash-ref _neighbours exit-name))

    ;Predicate, checks if neighbour exist
    (define/public (neighbour-exist? direction)
      (hash-has-key? _neighbours direction))

    ;Adds neighbour to table
    (define/public (add-neighbour! exit-name place)
      (hash-set! _neighbours exit-name place))

    ;Removes neighbour from table
    (define/public (remove-neighbour! exit-name)
      (hash-remove! _neighbours exit-name))

    ;Predicate, checks if exist exists
    (define/public (exit-exist? direction)
      (hash-has-key? _exits direction))

    ;Returns a list of exists
    (define/public (exits)
      (hash-keys _exits))

    ;Add exist to table
    (define/public (add-exit! direction neighbour)
      (hash-set! _exits direction neighbour))

    ;Returns a list of neighbours
    (define/public (neighbours)
      (hash-values _neighbours))

    ;Predicate, checks if room is walkable
    (define/public (walkable?)
      walkable)

    ;Makes the room  walkable
    (define/public (make-walkable)
      (set! walkable #t))
    
    ;Makes the room not walkable
    (define/public (make-not-walkable)
      (set! walkable #f))

    ;; same as get-fire but is created for easier code reading 
    (define/public (fire?)
      fire)

    ;Makes a fire in room
    (define/public (set-fire)
      (set! fire #t)
      (make-not-walkable))

    ;Puts out fire
    (define/public (extinguish-fire)
      (set! fire #f)
      (set! walkable #t))

    
    ;; same as get-pit but is created for easier code reading 
    (define/public (pit?)
      pit)

    ;Makes a pit in the room
    (define/public (set-pit)
      (set! pit #t)
      (make-not-walkable))

    ;Add character to the room
    (define/public (add-character! character)
      (hash-set! _characters (send character get-name) character))

    ;Returns character-object
    (define/public (get-character character-name)
      (hash-ref _characters character-name))

    ;Removes character from room
    (define/public (delete-character! character-name)
      (hash-remove! _characters character-name))

    ;Checks if character exists
    (define/public (character-exists? character-name)
      (hash-has-key? _characters character-name))

    ;Returns a list of character
    (define/public (characters)
      (hash-values _characters))

    ;Add item to the room
    (define/public (add-item! item)
      (hash-set! _items (send item get-name) item))

    ;Removes item from room
    (define/public (remove-item! item-name)
      (hash-remove! _items item-name))

    ;Returns an item-object
    (define/public (get-item item-name)
      (hash-ref _items item-name))

    ;Predicate, checks if item exists in room
    (define/public (item-exist? item-name)
      (hash-has-key? _items item-name))


    ;Returns a list of item in room
    (define/public (items)
      (hash-values _items))
    
    (super-new)))


; ---------- public functions

;;Connects rooms to each other
(define (connect-places! place1 exit1 place2 exit2)
  (send place1 add-neighbour! exit1 place2)
  (send place2 add-neighbour! exit2 place1)
  (send place1 add-exit! exit1 place2)
  (send place2 add-exit! exit2 place1))