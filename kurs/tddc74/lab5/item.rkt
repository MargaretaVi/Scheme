#lang racket
(provide item%)

(define item%
  (class object%
    (init-field amount ;how many exists
                description
                name
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

    ;Moves item to a new place
    (define/public (move-to! new-place)
      (send place remove-item! (send this get-name))
      (set! place new-place)
      (send place add-item! (send this get-name)))

    ;Decrerases amount with 1
    (define/public (decrease-amount)
      (set! amount (- amount 1)))

    
    (super-new)))

