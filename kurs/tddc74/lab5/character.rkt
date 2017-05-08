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

    ;Returns the member place
    (define/public (get-place)
      place)

    ;Returns the member description
    (define/public (get-description)
      description)
    
    ;Returns the member name
    (define/public (get-name)
      name)
    
    ;Returns the member talk-line
    (define/public (get-talk-line)
      talk-line)

    ;Sets the member living to false
    (define/public (killed)
      (set! living #f))

    ;Moves the character to a specific place
    (define/public (move-to new-place)
      (send place delete-character! (send this get-name))
      (send new-place add-character! this)
      (set! place new-place))

    ;Returns a list of items
    (define/public (get-inventory)
      (hash-values _inventory))

    ;Returns the object of item-name
    (define/public (get-item item-name)
      (hash-ref _inventory item-name))

    ;Adds an item to inventory
    (define/public (add-item! item)
      (hash-set! _inventory (send item get-name) item))

    ;Adds item to current character and removes said item
    ;from the other party in the trade
    (define/public (receive item-name giver)
      (add-item! (send giver get-item item-name))
      (send giver remove-item! item-name))

    ;Removes item from inventory and adds said item to
    ; the other partys inventory
    (define/public (give item recipient)
      (send recipient add-item! item)
      (send this remove-item! (send item get-name)))

    ;Drops the item in the current room
    (define/public (drop item)
      (send place add-item! item)
      (hash-remove! _inventory (send item get-name)))

    ;Pick up an item from the room
    (define/public (pick-up item)
      (add-item! item)
      (send place remove-item! (send item get-name)))

    ;Removes item from inventory
    (define/public (remove-item! item-name)
      (hash-remove! _inventory item-name))

    ;Predicate, checks if item is in inventory
    (define/public (has-item? item-name)
      (hash-has-key? _inventory item-name))

    ;Predicate, checks if character is alive
    (define/public (alive?)
      living)

    (super-new)))

      