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
     (send this-ui print-commands arguments)]))

(define welcome-str
    "Hello! And welcome to the game 'Hunt the Wumpus'. To see user-commands , please write 'help' and press enter. \nYou are currently in room 0")

(define GUI
  (new adventure-UI%
       [window-name "Hunt the Wumpus"]
       [height 400]
       [width 600]
       [place-name "Dungeoun"]
       [handle-input handle-input_]))
  
(define-syntax-rule (own-while condition body ...)
  (let loop ()
    (when condition
      body ...
      (loop))))

;level = easy, medium, hard
(define main
  (begin 
    (send GUI present welcome-str)
    (if (not (send wumpus alive?))
        (send GUI notify "Congratulations, you killed the wumpus. You will be sent to the market")
        (send GUI notify "Find the wumpus!!"))))


      
         
         
 
  
    






                    
  