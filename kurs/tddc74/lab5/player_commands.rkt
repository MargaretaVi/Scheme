#lang racket
(require "cmd_store.rkt")
(require "world_init.rkt")
(provide print-list)
#|
Here the player commands are defined
|#

;Prints out the players inventory
(define (inventory_ this-ui arguments)
  (send this-ui present "You have the following item(s) in your inventory: ")
  (print-list this-ui (return-names (send player get-inventory) '())))
(add-command! "inventory" inventory_)


;Returns a despriction of either the room the player is currently in
;or information about the room the player wants to look into
(define (look_ this-ui arguments)
  (if (null? arguments)
      (begin
        (send this-ui present
              (string-append  "You are at: " (send (send player get-place) get-name) "\n"
                              (send (send player get-place) get-description) "\n"
                              "---------------- \nYou see the following exits: "))
        (print-list this-ui (send (send player get-place) exits))
        (send this-ui present
              (string-append "----------------
You see the following item(s) in the room: " ))
        (print-list this-ui (send (send player get-place) items))
        (send this-ui present (string-append  "---------------- 
The people(s) in this place are: "))
        (print-list this-ui (return-names (send (send player get-place)
                                                characters) '())))
      ;any other adjacent room
      (begin
        (send this-ui present (string-append "You are looking in the direction: "
                                             (car arguments) "\n----------------"))
        (cond
          [(not (send (send player get-place) exit-exist? (car arguments)))
           (send this-ui present "There is no path in that direction")]
          [(send (send (send player get-place) get-neighbour (car arguments)) fire?)
           (send this-ui present "The room is on fire, dont walk there")]
          [(send (send (send player get-place)  get-neighbour (car arguments)) pit?)
           (send this-ui present "There is a pit, dont walk there")]
          [(send (send (send player get-place) get-neighbour (car arguments))
                 character-exists? "wumpus")
           (send this-ui present "Shoot the monster!")]
          [else
           (begin
             (send this-ui present
                   (string-append "You see: "
                                  (send (send (send player get-place)
                                              get-neighbour (car arguments))
                                        get-description) "\n---------------- \n
The other people in that place are:" ))
             (print-list this-ui (return-names
                                  (send (send (send player get-place)
                                              get-neighbour (car arguments))
                                        characters) '())))]))))
(add-command! "look" look_)

; moves player to a walkable room that is adjacent to the current room
(define (move_ this-ui arguments)
  (cond
    [(or (null? arguments) (not (member (car arguments)
                                        '("south" "east" "west" "north"))))
     (send this-ui present
           "Invalid command. You need to specify where to go i.e move south,
north, east, west")]
    [(not (send (send (send player get-place) get-neighbour
                      (car arguments)) walkable?))
         (cond
           [(send (send (send player get-place) get-neighbour (car arguments))
                  fire?) (send this-ui present "You cannot go into that room, 
the room is on fire. Put out the fire first")]
           [(send (send (send player get-place) get-neighbour (car arguments))
                  pit?) (send this-ui present "You cannot go into that room, 
the room is a bottomless pit, find another way")]
           [(send (send (send player get-place) get-neighbour (car arguments))
                  character-exists? "wumpus")
            (send this-ui present "You cannot go into that room,
the wumpus will eat you alive")])]
    [(not (send (send player get-place) exit-exist? (car arguments)))
     (send this-ui present "No path to room that exist")]
    [else (begin
            (send player move-to (send (send player get-place) get-neighbour
                                       (car arguments)))
            (send this-ui present
                  (string-append "You have moved to: "
                                 (send (send player get-place) get-name))))]))
(add-command! "move" move_)

;Adds items to the players inventory, ie items that the player has picked up
(define (take_ this-ui arguments)
  (cond
    [(or (null? arguments) (> (length arguments) 2))
     (send this-ui present "Incorrect input, take takes ONE argument")]
    [(not (send (send player get-place) item-exist? (car arguments)))
     (send this-ui present "Item does not exist in this place.")]
    [(send player has-item? (car arguments))
     (send this-ui present "Cannot add item to inventory, item already exists")]
    [else
     (begin
       (send player pick-up (send (send player get-place)
                                  get-item (car arguments)))
       (send this-ui present (string-append (car arguments)
                                                  " added to inventory!")))]))
             
(add-command! "take" take_)

;Removes items from the players inventory
;i.e dropping items on the floor
(define (drop_ this-ui arguments)
  (cond
    [(or (null? arguments) (> (length arguments) 1))
     (send this-ui present "Incorrect input, drop takes ONE argument")]
    [(send player has-item? (car arguments))
      (begin
        (send player drop (send player get-item (car arguments)))
        (send this-ui present (string-append "You have dropped the: " (car arguments))))]
    [else (send this-ui present "You dont have the item in the inventory, item cannot be dropped.")]))
     
(add-command! "drop" drop_)

;Player can talk to other NPCs that are located in the same place
(define (talk_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "Please specify whom you want to talk to")]
    [(not (send (send player get-place) character-exists? (car arguments)))
      (send this-ui present "Person you want to talk to is not here")]
    [else (begin
            (send this-ui present (string-append
                                   (send (send (send player get-place)
                                               get-character (car arguments))
                                         get-talk-line)
                                   "I have these items in my inventory: "))
            (print-list this-ui (return-names (send (send (send player get-place)
                                     get-character (car arguments))
                                                    get-inventory) '())))]))
         
(add-command! "talk" talk_)

;adds and remove items from players inventory
(define (trade_ this-ui arguments)
  (cond
    [(or (< (length arguments) 3) (null? arguments))
     (send this-ui present "Please tell who you want to trade with,
what item you give and what item you want, in this order")]
    [(not (send (send player get-place) character-exists? (car arguments)))
     (send this-ui present "The person you want to trade with is not here")]
    [(equal?  (send (send (send player get-place)
                          get-character (car arguments)) get-name)
              (send player get-name))
     (send this-ui present "You cannot trade with yourself")]
    [(not (send (send (send player get-place) get-character (car arguments))
                has-item? (car (cdr (cdr arguments)))))
          (send this-ui present "Trader do not have that item")]
    [(not (send player has-item? (car (cdr arguments))))
          (send this-ui present "You do not have that item in you inventory")]
    (else
     ;trade occurs
     (send player receive (car (cdr (cdr  arguments)))
           (send (send player get-place) get-character (car arguments)))
     (send player give (send player get-item (car (cdr arguments)))
           (send (send player get-place) get-character (car arguments)))
     (send this-ui present
           (string-append (car (cdr (cdr arguments)))
                          " has been added to the inventory")))))
 
(add-command! "trade" trade_)

(define (amount_ this-ui arguments)
  (cond
    [(or (> (length arguments) 1) (null? arguments))
     (send this-ui present "Please specify which item you want to look at")]
    [(not (send player has-item? (car arguments)))
     (send this-ui present "Item not in inventory")]
    (else  
     (send this-ui present (number->string (send (send player get-item (car arguments)) get-amount))))))

(add-command! "amount" amount_)
;print out the player commands to the GUI
(define (help_ this-ui arguments)
  (send this-ui present "The following commands are allowed: ")
  (print-list this-ui (get-valid-commands)))

(add-command! "help" help_)

(define (use_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "You need to specify what item to use")]))
    
#|
; functions which are used to kill the wumpus,
; after the wumpus is dead player will be teleported to the market.
(define (shoot_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "You need to specify in which way you want to shoot")]
    [(if (send player has-item? "arrows")
         (if (< (send (send player get-item "arrows") get-amount) 1)
             (send this-ui present "You have not more arrows, impossible to continue. Please restart the game")
             (begin
               (send (send player get-item "arrows") decrease-amount)
               (if (send (send player get-place) exit-exist? (car arguments))
                   (if (eqv? (send (send wumpus get-place) get-name)
                             (send (send (send player get-place) get-neighbour (car arguments)) get-name))
                       (begin 
                         (send this-ui notify "Congratulations, you killed the wumpus! You will be sent to the market")
                         (send wumpus killed)
                         (send player move-to market)
                         (send this-ui present "You have moved to: the market ")
                         (send player add-item! gold)
                         (send this-ui present "gold has been added to your inventory")
                         (send this-ui set-place-name "market")
                         (send this-ui notify "Now the game is finished but you can still do things in this place."))
                       (send this-ui present "Arrow shot, the wumpus is not in that room"))
                   (send this-ui present "You cannot shoot in that direction, the rooms are not linked"))))
         (send this-ui present "You dont have arrows in your inventory "))]))

(add-command! "shoot" shoot_)


;Puts out the fire in the adjacent room of player
;makes that room walkable
(define (pour-water_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present "Please specify in which way you want to throw the water")]
    [(if (send player has-item? "water")
         (if (send (send (send player get-place) get-neighbour (car arguments)) extinguish-fire)
             (send this-ui present "Fire has been put out, now room can be entered")
             (send this-ui present "Room was not on fire, now it's wet"))
         (send this-ui present "Water not present in inventory, cannot extinguish fire"))]))

(add-command! "pour-water" pour-water_)


|#


; -------- help functions to the player commands
; prints out a list to the GUI
(define (print-list this-ui arguments)
  (for-each
   (lambda (str)
     (send this-ui present str))
   arguments))

;Returns a list with only names
;Input: list of class-objects
(define return-names
  (lambda (list-obj tmp)
    (if (null? list-obj)
        tmp
        (return-names (cdr list-obj) (cons (send (car list-obj) get-name) tmp )))))