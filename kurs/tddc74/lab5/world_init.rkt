#lang racket
(require "character.rkt")
(require "place.rkt")
(require "item.rkt")
(require "cmd_store.rkt")
(provide (all-defined-out))

#|
(define rooms (make-vector 24))

(define make-rooms
  (for-each
   (lambda (i)
     (let ((room-name (string-append "room" (number->string i)))
            (des (string-append "Current room is: " (number->string i))))
       (define room-name
         (new place%
              [name room-name]
              [description des]))
       (display room-name)))
   '(1 2 3 4)))
|#
(define random-from-to
  (lambda (from to)
    (+ (random (- to (- from 1))) from)))

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

;; Connect the world.
(connect-places! room1 "west" room2 "east")
(connect-places! room1 "north" room5 "south")
(connect-places! room2 "north" room6 "south")
(connect-places! room2 "east" room3 "west")
(connect-places! room3 "north" room6 "south")
(connect-places! room4 "north" room7 "south")
(connect-places! room4 "east" room4 "west")
(connect-places! room5 "north" room8 "south")
(connect-places! room5 "east" room6 "west")
(connect-places! room6 "north" room9 "south")
(connect-places! room7 "east" room8 "west")
(connect-places! room8 "east" room9 "west")


;; ------------- Characters

(define player
  (make&add-character
   "Me"
   "The coat looked worse for wear. Its wearer even more so."
   "You again! I have nothing to say to myself."
   room1))

(define wumpus
  (make&add-character
   "Wumpus"
   "I smell."
   "Chomp Chomp Chomp"
   room2))


;; ------------- Items

(define arrows
  (new item%
       [amount 5]
       [name "Mighty arrow"]
       [description "Silver arrows"]))