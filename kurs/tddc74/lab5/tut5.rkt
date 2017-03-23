#lang racket
(require "presentation.rkt")

; Problem 1

(define window1 (make-object adventure-UI% "Window1" 300 500 ))
(define window2 (make-object adventure-UI% "Window2" 200 400 ))

; problem 2

;(send window1 present "hello")
;(send window1 present-no-lf "bla bal bal")
; present-no-lf do not give a new line after printing out the sting,
; so the next present will be on the same line as the previous one

; problem 3
;(send window1 set-name-place "my own name")

;problem 4/5

(define my-UI
  (new adventure-UI%
     [window-name "my game"]  
     [handle-input (lambda (this-ui command arguments) 
                     (send this-ui present (string-append
          "Commands: "
          command
          "\nArguments: "
          (string-join arguments)
          )))]))

;problem 6


