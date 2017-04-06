#lang racket
(require "character.rkt")
(require "place.rkt")
(require "item.rkt")
(require "cmd_store.rkt")
(provide (all-defined-out))


(define random-from-to
  (lambda (from to)
    (+ (random (- to (- from 1))) from)))

;; Creates and adds a character to a given place. Returns the character.
(define (make&add-character name_ desc_ talk-line_ place)
  (let
      ([new-char
        (new character%
             [name name_]
             [description desc_]
             [talk-line talk-line_])])
    (send new-char move-to place)
    (send place add-character! new-char)
    new-char))

;; ------------ Places
(define room1
  (new place%
       [name "Room 1"]
       [description "This is room 1, one of many"]))

(define room2
  (new place%
       [name "Room 2"]
       [description "This is room 2, one of many"]))

(define room3
  (new place%
       [name "Room 3"]
       [description "This is room 3, one of many"]))

(define room4
  (new place%
       [name "Room 4"]
       [description "This is room 4, one of many"]))

(define room5
  (new place%
       [name "Room 5"]
       [description "This is room 5, one of many"]))

(define room6
  (new place%
       [name "Room 6"]
       [description "This is room 6, one of many"]))

(define room7
  (new place%
       [name "Room 7"]
       [description "This is room 7, one of many"]))

(define room8
  (new place%
       [name "Room 8"]
       [description "This is room 8, one of many"]))

(define room9
  (new place%
       [name "Room 9"]
       [description "This is room 9, one of many"]))

(define market
  (new place%
       [name "market"]
       [description "Where you can buy stuffs to eat"]))

;; Connect the world.
(connect-places! room1 "east" room2 "west")
(connect-places! room1 "north" room4 "south")
(connect-places! room2 "north" room5 "south")
(connect-places! room2 "east" room3 "west")
(connect-places! room3 "north" room6 "south")
(connect-places! room4 "north" room7 "south")
(connect-places! room4 "east" room5 "west")
(connect-places! room5 "north" room8 "south")
(connect-places! room5 "east" room6 "west")
(connect-places! room6 "north" room9 "south")
(connect-places! room7 "east" room8 "west")
(connect-places! room8 "east" room9 "west")

;; -----------rooom specialities
(send room5 set-pit)
(send room7 set-fire)
(send room9 set-fire)
(send room3 set-fire)
;; ------------- Items

(define arrows
  (new item%
       [amount 5]
       [name "arrows"]
       [description "Silver arrows"]))

(define water
  (new item%
       [amount 100]
       [name "water"]
       [description "waterbucket"]))
           

(define apple
  (new item%
       [amount 1]
       [name "apple"]
       [description "Om nom nom"]))

(define milk
  (new item%
       [amount 1]
       [name "milk"]
       [description "Glup"]))

(define gold
  (new item%
       [amount 500]
       [name "gold"]
       [description "So shiny"]))

(define berries
  (new item%
       [amount 20]
       [name "berries"]
       [description "So round"]))

(define torches
  (new item%
       [amount 20]
       [name "torches"]
       [description "Good for fire"]))
             
;; ------------- Characters

(define player
  (make&add-character
   "Me"
   "The coat looked worse for wear. Its wearer even more so."
   "You again! I have nothing to say to myself."
   room1))


;(send player add-item! apple)

(define wumpus
  (make&add-character
   "Wumpus"
   "I smell."
   "Chomp Chomp Chomp"
   room2))

(define merchant
  (make&add-character
   "merchant"
   "I has apple, ."
   "kaching!"
   market))

(define guide
  (make&add-character
   "guide"
   "Helper"
   "Welcome player, to find the gold you need to kill the wumpus. Trade me some berries and torches and I will give you the weapons. "
   room1))


(send room2 add-item! gold)
(send room1 add-item! berries)
(send room1 add-item! torches)
(send merchant add-item! apple)
(send merchant add-item! milk)
(send guide add-item! arrows)
(send guide add-item! water)