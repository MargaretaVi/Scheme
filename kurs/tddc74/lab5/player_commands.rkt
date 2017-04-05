#lang racket
(require "cmd_store.rkt")
(require "world_init.rkt")


(define (inventory_ this-ui)
  (send this-ui present "You have the following things in your inventory: ")
  (send this-ui get-inventory))
(add-command! "inventory" inventory_)

(define (look_ this-ui arguments)
  (if (eqv? (car arguments) null)
      (begin 
        (send this-ui present "You are at: ")
        (send (send this-ui get-place) get-name)
        (send (send this-ui get-place) get-description)
        (send this-ui present "You see the following exits: ")
        (send (send this-ui get-place) exits)
        (send (send this-ui get-place) items))
      (begin
        (send this-ui present "You are looking in the direction: ")
        (send this-ui direction)
        (send this-ui present "You see: ")
        (send (send this-ui get-place) get-description))))
(add-command! "look" look_)

(define (move_ this-ui arguments)
  (if (hash-has-key? this-ui (car arguments))
      (send this-ui move-to (car arguments))
      (send this-ui present "You cannot go there, there is not path leading to that place.")))
(add-command! "move" move_)

(define (take_ this-ui arguments)
  (if (hash-has-key? this-ui (car arguments))
      (send this-ui add-item! (car arguments))
      (send this-ui present "Item does not exist here.")))

(add-command! "take" take_)

(define (drop_ this-ui arguments)
  (if (hash-has-key? this-ui (car arguments))
      (send this-ui remove-item! (car arguments))
      (send this-ui present "Item does not exist here, cannot be dropped.")))
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
  (for-each
   (lambda (str)
     (send this-ui present str))
   (get-valid-commands)))


(add-command! "help" help_)
