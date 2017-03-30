#lang racket
(provide character%)

(define character%
  (class object%
    (init-field
                description
                name
                talk-line
                [*inventory* (make-hash)]
                [place #f]
                )
    (define/public (get-place)
      place)
    
    (define/public (get-description)
      description)
    
    (define/public (get-name)
      name)
    
    (define/public (get-talk-line)
      talk-line)
    
    (define/public (move-to new-place)
      (if (eqv? place new-place)
          #f
          (begin
            (set! place new-place)
            (send new-place add-character! this)
            #t)))
    
    (define/public (get-inventory)
      (hash-keys *inventory*))
    
    (define/public (get-item item-name)
      (if (hash-has-key? *inventory* item-name)
          (hash-ref *inventory* item-name)
          #f))
    
    (define/public (receive item giver)
      (if (eqv? place (send giver get-room))
          (begin
            (hash-set! *inventory* item item)
            (send giver drop item))
          (display "Reciever and giver is not in the same room")))
    
    (define/public (give item-name recipient)
      (begin
        (if (hash-has-key? *inventory* item-name)
            (begin
              (send recipient pick-up item-name)
              (hash-remove! *inventory* item-name))
            #f)))

    (define/public (pick-up item)
      (hash-set! *inventory* item item))
    
    (define/public (drop item)
      (hash-remove! *inventory* item))

    (super-new)))

