#lang racket
(provide item% water-class% arrow-class% pass-class%)

(define item%
  (class object%
    (init-field amount ;how many of the item are there
                description
                name
                [place #f]
                [effect (void)])

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
    (define/public (use this-ui room)
      name)

    ;Gives the item a place
    (define/public (set-place! new-place)
      (set! place new-place))
    
    (super-new)))

;; Subclass water
(define water-class%
  (class item%
    (inherit-field
     amount)
    (inherit decrease-amount)
    (define/override (use this-ui room)
      (send room extinguish-fire)
      (decrease-amount)
      (send this-ui present "Water used"))
    (super-new)))

;;subclass arrow
(define arrow-class%
  (class item%
    (inherit-field
     amount)
    (inherit decrease-amount)
    (define/override (use this-ui room)
      (kill-character (return-names (send room characters) '()) room this-ui))
    
    (define/private (kill-character lst room this-ui)
      (if (null? (cdr lst))
          (begin
            (send (send room get-character (car lst)) killed)
            (send room delete-character! (car lst))
            (decrease-amount)
            (send room make-walkable) 
            (if (equal? (car lst) "wumpus")
                (send this-ui notify "Congratulations! You have killed the wumpus!")
                (send this-ui present "Arrow shot")))
          (kill-character (cdr lst) room)))
          
    (super-new)))

;;subclass pass
(define pass-class%
  (class item%
    (inherit-field
     place)
    (inherit get-place)
      
    (define/override (use this-ui room)
      (cond
))
      
    (super-new)))
        

;Returns a list with only names
;Input: list of class-objects
(define return-names
  (lambda (list-obj tmp)
    (if (null? list-obj)
        tmp
        (return-names (cdr list-obj) (cons (send (car list-obj) get-name) tmp )))))