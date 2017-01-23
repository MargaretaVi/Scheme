;=================================================
; PRAM 2011, 2011-02-xy
; Laboration x
; Stina Stinson, Kalle Karlsson, grupp Yx
;=================================================
(require (lib "trace.ss")) 

; Uppgift 1a Summera tre tal
(define (summera-3 x y z)
  (+ x y z))

; Hantering av testfall, en mycket enkel modell
(define (test-1a)
  (if (and 
       (equal? (summera-3 1 2 3) 6)  
       ; alternativt mer specialicerad jämförelsefunktion, t ex =
       (equal? (summera-3 -1 -2 -3) -6)
       (equal? (summera-3 0 -1 1) 0))
      'alla-ok
      'alla-ej-ok))



      
