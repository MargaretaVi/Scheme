#lang racket
;; laboration 2
;; uppgift 1
(require racket/trace)
(provide (all-defined-out))

(define foo (cons 2 3))
(define bar (list 2 3))
(define forex (cons 2 (cons 3 4)))
(define tesco (list 2 bar))

;; se inlämnat papper

;; uppgift 2
;; kollar om ett invärde är ett atomiskt värde
(define atom?
  (lambda (input)
    (and (not (pair? input)) (not (null? input)))))

;; uppgift 3
;;Räknar totala antalet element som finns i listan
(define count-list
  (lambda (lst)
    (if (atom? lst)
        1
        (count-elements lst 0))))

(define count-elements
  (lambda (lst count)
    (if (null? lst)
        0
        (+ 1 (count-elements (cdr lst) count)))))
        
(define count-list-correct?
  (lambda (lst)
    (= (count-list lst) (length lst))))


;; LÄGG TILL EXEMPLAR!

;; uppgift 4
;; Sparar undan ett element om predicatet stämmer 
;; antar att man inte skickar in en tom lista
(define keep-if
  (lambda (pred lst)
    (if (null? lst)
        '()
        (if (pred (car lst))
            (cons (car lst) (keep-if pred (cdr lst)))
            (keep-if pred (cdr lst))))))

;;Jämför om min funktion returnerar samma sak som fnk filter           
(define keep-if-correct?
  (lambda (pred lst)
    (comp-elem (keep-if pred lst) (filter pred lst))))

(define comp-elem
  (lambda (lst1 lst2)
    (if (and (null? lst1) (null? lst2))
        #t
        (if (equal? (car lst1) (car lst2))
            (comp-elem (cdr lst1) (cdr lst2))
            #f))))

;uppgift 5
;; Funktionen plockar ut de n första elementen ifrån en lista om n < längden av listan
(define first-n
  (lambda (n lst)
    (if (> n (count-list lst))
        lst
        (extract-from-list n lst (count-list lst)))))

(define extract-from-list
  (lambda (n lst num-elem)
    (if (> n 0)   
        (cons (car lst) (extract-from-list (- n 1) (cdr lst) num-elem))
        '())))

;; kontrollerar om first-n och take skiljer sig åt
(define first-n-correct?
  (lambda (n lst)
    (comp-elem (first-n n lst) (take lst n))))

;; TEZTEXEMPLES!!!

;;uppgift 6
;;skapar en lista med element ifrån ett visst interval med steg som väljas av användaren
(define enumerate
  (lambda (from to step)
    (if (> from to)
        '()
        (cons from (enumerate (+ from step) to step)))))

;;uppgift 7
;;returnerar en lista i omvändordning, rekursive process
(define reverse-order-rek
  (lambda (lst)
    (if (null? lst)
        lst
        (append-elem (car lst) (reverse-order-rek (cdr lst))))))

(define append-elem
  (lambda (elem lst)
    (if (null? lst)
        (cons elem lst)
        (cons (car lst) (append-elem elem (cdr lst) )))))

;; EJ KLAR!!!

;iterative version av reverse-order
(define reverse-order-iter
  (lambda (lst)
    (if (null? lst)
        lst
        (help-iter lst))))

(define help-iter
  (lambda (lst)
    (+ 0)))

;; uppgift 8

;; mappar varje element i listan till funktionen och retunerar en ny lista
(define map-to-each
  (lambda (fn lst)
    (if (null? lst)
        lst
        (cons (fn (car lst)) (map-to-each fn (cdr lst))))))


;;uppgift 9
;; Sätter in ett värde på rätt position i en sorterad lista
(define insert-at-asc-place
  (lambda (num lst)
    (cond
     ((or (null? lst) (<= num (car lst))) (cons num lst))
     (else (cons (car lst) (insert-at-asc-place num (cdr lst)))))))
         
;; sorterar en lista i stigande ordning
(define insert-sort
  (lambda (lst)
   (help-insert-sort '() lst )))

(define help-insert-sort
  (lambda (sorted-lst unsorted-lst)
    (if (null? unsorted-lst)
        sorted-lst
        (help-insert-sort (insert-at-asc-place (car unsorted-lst) sorted-lst) (cdr unsorted-lst)))))

;; uppgift 10
;;funktionen ska räkna alla element i listan, även de i underlistor
(define count-all
  (lambda (lst)
    (cond
      ((null? lst) 0)
      ((pair? lst) (+ (count-all (car lst)) (count-all (cdr lst))))
      ;; atom? isf addera 1
      (else 1))))

;; Specialfall som kan inträffa är om listan är tom eller om den består endast en atom

;; uppgift 11
;; Ett predikat som kollar om det första argumentet finns i en lista

(define occurs?
  (lambda (elem lst)
    (cond
      ((null? lst) #f)
      ;((atom? lst) (eq? elem lst))
      ((if (pair? lst) 
          (if (atom? (car lst))
              (if (eq? elem (car lst))
                  #t
                  (occurs? elem (cdr lst)))
              (if (occurs? elem (car lst))
                  #t
                  (occurs? elem (cdr lst))))
          (eq? elem lst))))))


(define occurs2?
  (lambda (elem lst)
    (cond
      ((null? lst) #f)
      ((atom? lst) (eq? elem lst))
      ((if (list? lst)
          (if (occurs-healp? elem lst)
              #t
              #f)
          (eq? elem lst)))
       )))
       
(define occurs-healp?
  (lambda (elem lst)
    (if (pair? lst)
        (if (occurs-healp? elem (car lst))
            #t
            (occurs-healp? elem (cdr lst)))
        (eq? elem lst))))

  
  
      
(trace occurs-healp?)

;; Likheten mellan de är att att conden är den samma, bortsett ifrån vad man ska göra iaf villkoret är falskt