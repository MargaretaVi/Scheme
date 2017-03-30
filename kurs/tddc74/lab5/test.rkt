#lang racket
(require "character.rkt")
(require "item.rkt")
(require "place.rkt")

(define screwdriver
    (new item%
         [amount 1]
         [name "Screwdriver"]
         [description "A fantastic screwdriver."]))

(define james-bond
  (new character%
       [name "James-Bond-agent"]
       [description "Shaken, not stirred"]
       [talk-line
        "There’s always something formal about the point of a pistol."]))

(define player
 (new character%
       [name "me"]
       [description "I who holds the power"]
       [talk-line "I sense gold, gold, GOLD"]))

(define water-bucket
    (new item% [name "water-bucket"]
         [amount 10000]
         [description "Good to use when you are hot"]))

(define arrows
    (new item% [name "Almighty arrows"]
         [amount 20]
         [description "Defend yourself"]))

(define fjkla7289~.
  (new item%
       [name "Garbage"]
       [amount 1]
       [description "tmp"]))

(define room1
  (new place%
       [name "1"]
       [description "Room 1"]))

(define start
  (new place%
       [name "0"]
       [description "Starting room"]))


(define java-cafe
    (new place%
         [name "Java"]
         [description "Of all the cafes in this world..."]))

;(send james-bond pick-up arrows)
;(send james-bond pick-up water-bucket)

(send java-cafe add-character! james-bond)
(send java-cafe get-character "James-Bond-agent")
(send james-bond get-place)
(send java-cafe delete-character! "James-Bond-agent")
(send james-bond move-to java-cafe)
(send james-bond get-place)
(send java-cafe get-character "James-Bond-agent")
(send java-cafe characters)
(send james-bond move-to start)
(send java-cafe characters)
(send start characters)
