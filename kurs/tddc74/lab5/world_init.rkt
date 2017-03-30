#lang racket
(require "character.rkt")
(require "place.rkt")
(require "item.rkt")
(require "cmd_store.rkt")
(provide (all-defined-out))


;; ------------ Places
(define java-cafe
  (new place%
       [name "Java"]
       
       [description "Of all the cafes in this world..."]))
(define stairs
  (new place%
       [name "Stairs"]
       [description "It would be easy to fall here, I reminded myself. "]))
