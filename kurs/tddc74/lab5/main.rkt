#lang racket
(require "presentation.rkt")
(require "cmd_store.rkt")
(require "world_init.rkt")
(require "player_commands.rkt")

(define (handle-input_ this-ui command arguments)
  (cond
    [(valid-command? command) ((get-procedure command) this-ui arguments) ]
    [else
     (send this-ui present "Invalid command, following commands are allowed: ")
     (print-list this-ui (get-valid-commands) )]))

(define welcome-str
    "Welcome to the game 'Hunt the Wumpus'. To see user-commands , please write 'help' and press enter. \nYou are currently in room 1 ")

(define GUI
  (new adventure-UI%
       [window-name "Hunt the Wumpus"]
       [height 400]
       [width 600]
       [place-name "Dungeoun"]
       [handle-input handle-input_]))
 


;level = easy, medium, hard
(define main
  (begin 
    (send GUI present welcome-str)
    (send GUI present "Talk to everyone you see, they might have some useful information")))

      
         
         
 
  
    






                    
  