;;; HTML-tools
;; Joakim Hellsten, 2005-09-21

;; Some simple procedures for formatting data as HTML.

;; Takes a string and returns a it tagged as a title.
(define (html-title string)
  (string-append "<H1>" string "</H1><br>"))

;; Takes a string and returns a it tagged as bold.
(define (html-bold string)
  (string-append "<b>" string "</b>"))

;; Takes a string and returns it tagged as italic (in swedish: kursiv)
(define (html-italic string)
  (string-append "<i>" string "</i>"))
                          
  ;; Takes a song and returns it as an HTML formatted string.
(define (song->html song)
  (string-append (html-bold (stringify-list (get-title song)))
                  (html-italic " by ") (html-bold (stringify-list (get-artist song)))
                  (html-italic " from ") (html-bold (number->string (get-year song)))
                  " (" (html-bold (symbol->string (get-genre song))) ") <br>"))

;;; ---- Additional procedures ----

;; takes a list of symbols/number and creates a string.
;; (R5RS primitive string->list takes a list of characters.)
;; Used by song->html
(define (stringify-list lst)
  (define (to-string thing)
    (cond 
      ((number? thing) (number->string thing))
      ((symbol? thing) (symbol->string thing))
      ((null? thing) "")
      (else (error "Invalid input" thing))))
  (cond 
    ((null? lst) "")
    ((null? (cdr lst))
     (string-append (to-string (car lst)) (to-string (cdr lst))))
    (else
     (string-append (to-string (car lst)) " " (stringify-list (cdr lst))))))
