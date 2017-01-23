;=================================================
; PRAM 2011, 2011-02-xy
; Laboration z
; Stina Stinson, Kalle Karlsson, grupp Yx
;=================================================
(require (lib "trace.ss")) 

; Ladda in test-drivern 
(load "test-driver.scm")

; Uppgift 1a Summera tre tal
(define (summera-3 x y z)
  (+ x y z))

; Testning
(define (test-1a) 
  (kör-testfall 
   summera-3 
   '(
     ((1 2 3) 6)
     ((-1 -2 -3) -6)
     ((0 -1 1) 0)
     )))

; Uppgift 1b Summera fyra tal
(define (summera-4 x y z v)
  (+ x y z z))

; Testning
(define (test-1b) 
  (kör-testfall 
   summera-4 
   '(
     ((1 2 3 3) 9)
     ((-1 -2 -3 -4) -10)
     ((0 -1 1 2) 2)
     )))
      
