;=================================================
; PRAM 2011, 2011-02-xy
; Laboration z
; Stina Stinson, Kalle Karlsson, grupp Yx
;=================================================
(require (lib "trace.ss")) 

; En generll test-driver

; Om du har din egen test-driver så spara den i
; labbens map.
; För att komma åt den gör (load "test-driver.scm")

(define (kör-testfall funktion testfall) 
  ; test-fallär en lista med listor med 2 element 
  ;((argument värde) ... (argument värde))
  (define alla-ok #t)
  (define (testa ett-testfall)
    (let ((värdet (apply funktion (car ett-testfall))))
      (if (not (equal? värdet (car (cdr ett-testfall))))
          (begin (display "Felaktigt testfall: ")
                 (display (car ett-testfall))
                 (newline)
                 (display "Ger värdet: ")
                 (display värdet)
                 (newline)
                 (display "Önskat värde är: ")
                 (display (car (cdr ett-testfall)))
                 (newline)
                 (display "---") 
                 (newline)
                 (set! alla-ok #f)))))
  (map testa testfall)
  (if alla-ok 'alla-ok (void)))



      
