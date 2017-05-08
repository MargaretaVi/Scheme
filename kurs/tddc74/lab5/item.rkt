#lang racket
(provide item%)

(define item%
  (class object%
    (init-field amount ;how many of the item are there
                description
                name
                [effect (void)]
                [place (void)]
               )

    ;Returns member amount
    (define/public (get-amount)
      amount)

    ;Returns member place
    (define/public (get-place)
      place)

    ;Returns member description
    (define/public (get-description)
      description)

    ;Returns member name
    (define/public (get-name)
      name)

    ;Returns member effect
    (define/public (get-effect)
      effect)
    
    ;Moves item to a new place
    (define/public (move-to! new-place)
      (send place remove-item! (send this get-name))
      (set! place new-place)
      (send place add-item! (send this get-name)))

    ;Decrerases amount with 1
    (define/public (decrease-amount)
      (set! amount (- amount 1)))

    ;Power of item
    (define/public (use direction)
      name)

    (super-new)))

;; Subclass water
(define water-class%
  (class item%
    (define/override (use direction)
     (send (send (send this get-place) get-neighbour direction) extinguish-fire))))

;;subclass arrow
(define arrow-class%
  (class item%
    (define/override (use direction)
     (kill-character (send (send (send this get-place) get-neighbour direction) characters)))
    
    (define/private (kill-character lst direction)
      (if (null? lst)
          (send (send (send (send this get-place) get-neighbour direction) get-character (car lst)) killed)
          (kill-character (cdr lst))))
          
    (super-new)))