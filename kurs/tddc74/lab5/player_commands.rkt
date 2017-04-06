#lang racket
(require "cmd_store.rkt")
(require "world_init.rkt")
(provide print-list)

(define (inventory_ this-ui arguments)
  (send this-ui present "You have the following item(s) in your inventory: ")
  (print-list this-ui (return-names (send player get-inventory) '())))
(add-command! "inventory" inventory_)

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
        (print-list this-ui (send (send player get-place) items))
        (send this-ui present "The people(s) in this place are: ")
        (print-list this-ui (return-names (send (send player get-place) characters) '())))
      (begin
        (send this-ui present-no-lf "You are looking in the direction: ")
        (print-list this-ui arguments)
        (if (send (send player get-place) exit-exist? (car arguments))
            (begin
              (send this-ui present "You see: ")
              (send this-ui present (send (send (send player get-place) get-neighbour (car arguments)) get-description))
              (send this-ui present "Room specifications: ")
              (if (send (send (send player get-place)
                              get-neighbour (car arguments)) fire?)
                  (send this-ui present "The room is on fire, dont walk there.")
                  (send this-ui present "No fire.")) 
              (if (send (send (send player get-place)
                              get-neighbour (car arguments)) pit?)
                  (send this-ui present "There is a pit, dont walk there.")
                  (send this-ui present "No pit")) 
              (if  (send (send (send player get-place)
                               get-neighbour (car arguments))
                         character-exists? "wumpus: ")
                   (send this-ui present "Shoot the monster!")
                   (send this-ui present "No monster, safe to go"))
              (send this-ui present "The other people in this place are: ")
              (send this-ui present (send (send player get-place) characters)))
            (send this-ui present "There is no path in that direction, maybe you ment either north, east, south, west")))))
(add-command! "look" look_)

(define (move_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "Invalid command 'move'. You need to specify where to go i.e move south, north, east, west")]
    [(if (not (send (send (send player get-place) get-neighbour (car arguments)) walkable?))
         (cond
           [(send (send (send player get-place) get-neighbour (car arguments)) fire?)
            (send this-ui present "Cannot go to that room, the room is on fire")]
           [(send (send (send player get-place) get-neighbour (car arguments)) pit?)
            (send this-ui present "Cannot go to that room, the room is a bottomless pit, find another way")]
           [(send (send (send player get-place) get-neighbour (car arguments)) character-exists? "wumpus")
              (send this-ui present "Cannot go to that room, the wumpus will eat you alive")])
         (if (send (send player get-place) exit-exist? (car arguments))
             (if (send player move-to (send (send player get-place) get-neighbour (car arguments)))
                 (send this-ui present (string-append "You have moved to: " (send (send player get-place) get-name)))
                 (send this-ui present "You are already in that room, did not move"))
             (send this-ui present "You cannot go there, there is not path leading to that place.")))]))
(add-command! "move" move_)

(define (take_ this-ui arguments)
  (if (send (send player get-place) item-exist? (car arguments))
      (if (send player add-item! (send (send player get-place) get-item (car arguments)))
          (begin
            (send (send player get-place) remove-item! (car arguments))
            (send this-ui present (string-append (car arguments) " added to inventory!")))
          (send this-ui present "Cannot add item to inventory, item already exists"))
      (send this-ui present "Item does not exist in this place.")))
(add-command! "take" take_)

(define (drop_ this-ui arguments)
  (if (send player has-item? (car arguments))
      (begin
         (send (send player get-place) add-item! (send player get-item (car arguments)))
         (send player remove-item! (car arguments))
         (send this-ui present (string-append "You have dropped the: " (car arguments))))
      (send this-ui present "You dont have the item in the inventory, cannot drop item")))
     
(add-command! "drop" drop_)

(define (shot_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "You need to specify in which way you want to shot")]
    [(if (send player has-item? "arrows")
         (if (send (send player get-place) exit-exist? (car arguments))
             (if (eqv? (send (send wumpus get-place) get-name)
                       (send (send (send player get-place) get-neighbour (car arguments)) get-name))
                 (begin
                   (send (send player get-item "arrows") decrease-amount)
                   (send (send player get-item "arrows") get-amount)
                   (send this-ui notify "Congratulations, you killed the wumpus! You will be sent to the market")
                   (send wumpus killed)
                   (send player move-to market)
                   (send this-ui present "You have moved to: market ")
                   (send player add-item! gold)
                   (send this-ui present "gold has been added to your inventory")
                   (send this-ui set-place-name "market"))
                 (send this-ui present "the wumpus is not in that room"))
             (send this-ui present "You cannot shot in that direction, the rooms are not linked"))
         (send this-ui present "You dont have arrows in your inventory "))]))

(add-command! "shot" shot_)

(define (extinguish-fire_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "Please specify in which way you want to throw the water")]
    [(if (send player has-item? "water")
      (if (send (send (send player get-place) get-neighbour (car arguments)) extinguish-fire)
          (send this-ui present "Fire has been put out, now room can be entered")
          (send this-ui present "Room was not on fire, now it's wet"))
      (send this-ui present "Water not present, cannot extinguish fire"))]))

(add-command! "extinguish-fire" extinguish-fire_)

(define (help_ this-ui arguments)
  (send this-ui present "The following commands are allowed: ")
  (print-list this-ui (get-valid-commands)))

(add-command! "help" help_)

(define (talk_ this-ui arguments)
  (if (null? arguments)
      (send this-ui present "Please specify whom you want to talk to")
      (begin
        (if (send (send player get-place) character-exists? (car arguments))
            (begin
              (send this-ui present (string-append
                                     (send (send (send player get-place) get-character (car arguments)) get-talk-line)
                                     "I have these items in my inventory: "))
              (print-list this-ui (return-names (send (send (send player get-place) get-character (car arguments)) get-inventory) '())))
            (send this-ui present "Person you want to talk to is not here")))))
(add-command! "talk" talk_)

(define (trade_ this-ui arguments)
  (cond
   [(null? arguments)
      (send this-ui present "Please tell who you want to trade with, what item you give and what item you want, in this order")]
   [(not (and (send (send (send player get-place) get-character (car arguments)) has-item? (car (cdr (cdr arguments))))
             (send player has-item? (car (cdr arguments))))) (send this-ui present "Item(s) do not exist")]       
   [(if (send (send player get-place) character-exists? (car arguments))
        (begin
         (send player add-item! (send (send (send player get-place) get-character (car arguments)) get-item (car (cdr (cdr arguments)))))
         (send this-ui present (string-append (car (cdr (cdr arguments))) " has been added to the inventory"))
         (send (send (send player get-place) get-character (car arguments)) add-item! (send player get-item (car (cdr arguments))))
         (send player remove-item! (car (cdr arguments)))
         (send this-ui present (string-append (car (cdr arguments)) " has been removed from the inventory"))
         (send (send (send player get-place) get-character (car arguments)) remove-item! (car (cdr (cdr arguments)))))
        (send this-ui present "The character you want to trade with is not here"))]))
        ;(send (send (send player get-place) get-character  (car arguments)) add-item! (car (cdr arguments)))
        ;(send player add-item! (car (cdr (cdr arguments)))))))

(add-command! "trade" trade_)
        

(define (print-list this-ui arguments)
  (for-each
   (lambda (str)
     (send this-ui present str))
   arguments))
