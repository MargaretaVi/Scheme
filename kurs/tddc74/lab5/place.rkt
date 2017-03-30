#lang racket
(provide place%)

(define place%
  (class object%
    (init-field name
                description
                [*neighbours* (make-hash)]
                [*characters* (make-hash)]
                [*exits* (make-exits)]
                )
    
    (define/public (get-name)
      name)
    (define/public (get-description)
      description)
    
    (define/public (add-character! character)
      (if (hash-has-key? *characters* character)
          #f
          (begin
              (hash-set! *characters* (send character get-name) character)
              (send character move-to this)
              #t)))
    
    (define/public (get-character character-name)
      (if (hash-has-key? *characters* character-name)
          (hash-ref *characters* character-name)
          #f))
    
    (define/public (delete-character! character-name)
      (if (hash-has-key? *characters* character-name)
          (begin
            (hash-remove! *characters* character-name)
            #t)
          #f))
    
    (define/public (characters)
      (hash-keys *characters*))

    (define/public (get-neighbour exit-name)
      (if (hash-has-key? *neighbours* exit-name)
          (hash-ref *neighbours* exit-name)
          #f))
    
    (define/public (add-neighbour! exit-name place)
      (hash-set! *neighbours* place exit-name))
  
    (define/public (remove-neighbour! exit-name)
      (if (hash-has-key? *neighbours* exit-name)
          (hash-remove! *neighbours* exit-name)
          #f))
    
    (define/public (exits)
      (*exits*))
    (define/public (neighbours)
      (hash-keys *neighbours*))
    
    (define/public (connect-places! place1 exit1 place2 exit2)
      (send place1 add-neighbour! exit1 place2)
      (send place2 add-neighbour! exit2 place1))

    (define/private (make-exits)
      (let ((hash (make-hash)))
        (hash-set! hash "west" "")
        (hash-set! hash "east" "")
        (hash-set! hash "north" "")
        (hash-set! hash "south" "")))
    
    
    (super-new)))