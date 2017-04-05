#lang racket
(require "cmd_store.rkt")
(require "world_init.rkt")
(provide print-list)

(define (inventory_ this-ui arguments)
  (send this-ui present "You have the following item(s) in your inventory: ")
  (print-list this-ui (get-inventory-list '())))
(add-command! "inventory" inventory_)

(define (get-inventory-list inventory-list)
  (let* ((list-obj (send player get-inventory)))
         inventory-list (return-names list-obj '())))

(define return-names
  (lambda (list-obj tmp)
    (if (null? list-obj)
        tmp
        (return-names (cdr list-obj) (cons (send (car list-obj) get-name) tmp )))))

(define (look_ this-ui arguments)
  (if (null? arguments)
      (begin
        (send this-ui present "You are at: ")
        (send this-ui present (send (send player get-place) get-name))
        (send this-ui present (send (send player get-place) get-description))
        (send this-ui present "You see the following exits: ")
        (print-list this-ui (send (send player get-place) exits))
        (send this-ui present "You see the following item(s) in the room: ")
        (print-list this-ui (send (send player get-place) items)))
        #|
        (send this-ui present (string-join (list "You are at: " (send (send player get-place) get-name)
                                             (send (send player get-place) get-description)
                                             "You see the following exit(s): "
                                             (print-list this-ui (send (send player get-place) exits))
                                             "You see the follwing item(s) in the room: ")))
        (print-list this-ui (send (send player get-place) items)))
|#
      (begin
        (send this-ui present-no-lf "You are looking in the direction: ")
        (print-list this-ui arguments)
        (if (send (send player get-place) exit-exist? (car arguments))
            (begin
              (send this-ui present "You see: ")
              (send this-ui present (send (send (send player get-place) get-neighbour (car arguments)) get-description)))
            (send this-ui present "There is no path in that direction, maybe you ment either north, east, south, west")))))
(add-command! "look" look_)

(define (move_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "Invalid command 'move'. You need to specify where to go i.e move south, north, east, west")]
    [(if (send (send player get-place) exit-exist? (car arguments))
         (begin
           (send player move-to (send (send player get-place) get-neighbour (car arguments)))
           (send this-ui present "You have moved to: ")
           (send this-ui present (send (send player get-place) get-name)))
         (send this-ui present "You cannot go there, there is not path leading to that place."))]))
(add-command! "move" move_)

(define (take_ this-ui arguments)
  (if (send (send player get-place) item-exist? (car arguments))
      (if (send player add-item! (send (send player get-place) get-item (car arguments)))
          (begin
            (send (send player get-place) remove-item! (car arguments))
            (send this-ui present "Item added to inventory!"))
          (send this-ui present "Cannot add item to inventory, item already exists"))
      (send this-ui present "Item does not exist in this place.")))
(add-command! "take" take_)

(define (drop_ this-ui arguments)
  (if (send player has-item? (car arguments))
      (begin
        (send player remove-item! (car arguments))
        (send (send player get-place) add-item! (send (send player get-place) get-item (car arguments))))
      (send this-ui present "You don't have the item, cannot be dropped.")))
(add-command! "drop" drop_)

(define (shot_ this-ui arguments)
  (if (hash-has-key? (send this-ui get-exit) (car arguments))
      (send this-ui decrease-amount)
      (send this-ui present "You cannot shot this way")))

(add-command! "shot" shot_)

(define (extinguish-fire_ this-ui arguments)
  (if (and (hash-has-key? (send this-ui get-exit) (car arguments)) (send this-ui fire?))
      (send this-ui extinguish-fire)
      (send this-ui present "Cannot extinguish fire")))

(add-command! "extinguish-fire" extinguish-fire_)

(define (help_ this-ui arguments)
  (send this-ui present "The following commands are allowed: ")
  (print-list this-ui (get-valid-commands)))
  
(define (print-list this-ui arguments)
  (for-each
   (lambda (str)
     (send this-ui present str))
   arguments))

(add-command! "help" help_)
