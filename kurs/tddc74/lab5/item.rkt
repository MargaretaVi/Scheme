#lang racket
(provide item%)

(define item%
  (class object%
    (init-field amount ;how many is created
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

    
    (super-new)))

