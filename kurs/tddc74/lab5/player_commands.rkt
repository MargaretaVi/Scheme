#lang racket
(require "cmd_store.rkt")
(require "world_init.rkt")
(provide print-list)
#|
Here the player commands are defined
|#

;; Help lines for each of the player commands
(define inventory_help
  "Command inventory do NOT take any arguments")

(define look_help
  "Command Look requires either ONE argument,
 in which direction you wish to look, or ZERO.
If zero arguments are given,
then information about the current room is shown")

(define move_help
  "Command move requires ONE argument.
You need to specify in which direction you want to move, ie move south,
north, east, or west")

(define take_help
  "Command take requires ONE argument.
You need to specify which item you take to take.")

(define drop_help
  "Command drop requires ONE argument. You need to specify which item to drop.")

(define talk_help
  "Command talk requires ONE argument. You need to specify whom to talk to")

(define trade_help
  "Command trade requires THREE arguments. You need to specify whom you want to
trade to, what you have to trade with and what you want.")

(define amount_help
  "Command amount requires ONE argument.
Please specify which item you want to look at")

(define use_help
  "Command use requires TWO arguments.
Please specify which item you want to use (arrow or water) and in which
direction")

(define help_help
  "To get more information about each commanad please type help 'command-name'")

;Prints out the players inventory
(define (inventory_ this-ui arguments)
  (if (not (null? arguments))
      (send this-ui present inventory_help)
      (begin
        (send this-ui present "You have the following item(s) in your inventory: ")
        (print-list this-ui (return-names (send player get-inventory) '())))))
(add-command! "inventory" inventory_)

;Returns a despriction of either the room the player is currently in
;or information about the room the player wants to look into
(define (look_ this-ui arguments)
  (cond
    [(null? arguments)
     (begin (send this-ui present
                  (string-append "You are at: "
                                 (send (send player get-place) get-name) "\n"
                                 (send (send player get-place) get-description) "\n"
                                 "---------------- \nYou see the following exits "))
       (print-list this-ui (send (send player get-place) exits))
       (send this-ui present  (string-append "----------------
You see the following item(s) in the room: " ))
       (print-list this-ui (return-names (send (send player get-place) items) '()))
       (send this-ui present (string-append  "---------------- 
The people(s) in this place are: "))
       (print-list this-ui (return-names (send (send player get-place) characters)
                                         '())))]
    ;any other adjacent room
    [(equal? (length arguments) 1)
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
         [(if (and (send (send (send player get-place) get-neighbour
                               (car arguments)) character-exists? "wumpus")
                   (send (send (send (send player get-place) get-neighbour
                                     (car arguments)) get-character "wumpus") alive?))
              (send this-ui present "Shoot the monster!")
              (send this-ui present "Safe to go"))]
         [else (begin
                 (send this-ui present (string-append "You see: "
                                           (send (send (send player get-place)
                                                       get-neighbour (car arguments))
                                                 get-description) "\n---------------- \n
The other people in that place are:" ))
                      (print-list this-ui (return-names
                                           (send (send (send player get-place)
                                                       get-neighbour (car arguments))
                                                 characters) '())))]))]
    [else (send this-ui present look_help)]))
(add-command! "look" look_)

; moves player to a walkable room that is adjacent to the current room
(define (move_ this-ui arguments)
  (cond
    [(or (null? arguments) (not (member (car arguments)
                                        '("south" "east" "west" "north"))))
     (send this-ui present move_help)]
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
    [(or (null? arguments) (not (equal? (length arguments) 1)))
     (send this-ui present take_help)]
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
     (send this-ui present drop_help)]
    [(send player has-item? (car arguments))
     (begin
       (send player drop (send player get-item (car arguments)))
       (send this-ui present (string-append "You have dropped the: "
                                            (car arguments))))]
    [else (send this-ui present
                "You dont have the item in the inventory, item cannot be dropped.")]))
     
(add-command! "drop" drop_)

;Player can talk to other NPCs that are located in the same place
(define (talk_ this-ui arguments)
  (cond
    [(or (null? arguments) (not (equal? (length arguments) 1)))
                                (send this-ui present talk_help)]
    [(not (send (send player get-place) character-exists? (car arguments)))
     (send this-ui present "Person you want to talk to is not here")]
    [(equal? (send player get-name) (car arguments))
     (send this-ui present "I'm starting to get cracy, talking to my self")]
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
    [(or (not (equal? (length arguments) 3)) (null? arguments))
     (send this-ui present trade_help)]
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
     (send this-ui present amount_help)]
    [(not (send player has-item? (car arguments)))
     (send this-ui present "Item not in inventory")]
    (else  
     (send this-ui present
           (number->string (send (send player get-item (car arguments))
                                 get-amount))))))

(add-command! "amount" amount_)
;print out the player commands to the GUI
(define (help_ this-ui arguments)
  (cond
    [(or (null? arguments) (equal? (car arguments) "help"))
     (begin
       (send this-ui present "The following commands are allowed: ")
       (print-list this-ui (get-valid-commands))
       (send this-ui present help_help))]
    [(equal? (length arguments) 1)
     (cond
       [(equal? (car arguments) "inventory")
        (send this-ui present inventory_help)]
       [(equal? (car arguments) "trade")
        (send this-ui present trade_help)]
       [(equal? (car arguments) "move")
        (send this-ui present move_help)]
       [(equal? (car arguments) "take")
        (send this-ui present take_help)]
       [(equal? (car arguments) "drop")
        (send this-ui present drop_help)]
       [(equal? (car arguments) "amount")
        (send this-ui present amount_help)]
       [(equal? (car arguments) "use")
        (send this-ui present use_help)]
       [(equal? (car arguments) "look")
        (send this-ui present look_help)]
       [(equal? (car arguments) "talk")
        (send this-ui present talk_help)]
       [(equal? (car arguments) "trade")
        (send this-ui present trade_help)]
       [(equal? (car arguments) "help")
        (send this-ui present help_help)])]))
    

(add-command! "help" help_)

(define (use_ this-ui arguments)
  (cond
    [(null? arguments) (send this-ui present use_help)]
    [(not (eq? (length arguments) 2))
     (send this-ui present "Not enough input arguments")]
    [(not (send player has-item? (car arguments)))
     (send this-ui present
           (string-append "You do not have "
                          (car arguments) " in your inventory"))]
    [(not (send (send player get-place) exit-exist? (car (cdr arguments))))
     (send this-ui present "Exist do not exist")]
    [(send (send player get-item (car arguments)) use this-ui
           (send (send player get-place) get-neighbour
                 (car (cdr arguments))))]))
           
(add-command! "use" use_)

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