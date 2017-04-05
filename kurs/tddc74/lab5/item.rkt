#lang racket
(provide item%)

(define item%
  (class object%
    (init-field amount ;how many exists
                description
                name
                [place #f]
               ) 
    (define/public (get-amount)
      amount)
    
    (define/public (get-place)
      place)
    
    (define/public (get-description)
      description)
    
    (define/public (get-name)
      name)

    (define/public (move-to! new-place)
      (if (eqv? place new-place)
          #f
          (set! place new-place)))

    (define/public (decrease-amount)
      (set! amount (- amount 1)))

    
    (super-new)))

