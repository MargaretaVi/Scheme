#lang racket
;; laboration 2
;; uppgift 1


(define foo (cons 2 3))
(define bar (list 2 3))
(define forex (cons 2 (cons 3 4)))
(define tesco (list 2 bar))

;; se inlämnat papper

;; uppgift 2

;; kollar om ett invärde är ett atomiskt värde
(define atom?
  (lambda (input)
    (if (or (pair? input) (null? input))
         #f
         #t)))

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
    (if (= (count-list lst) (length lst))
        #t
        #f)))


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
    (define own (keep-if pred lst))
    (define pre-build (filter pred lst))
    (if (comp-elem own pre-build)
        #t
        #f)))
 
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
    (let ((num-elem (count-list lst)))
      (if (> n num-elem)
          lst
          (extract-from-list n lst num-elem)))))


(define extract-from-list
  (lambda (n lst num-elem)
    (if (> n 0)   
        (cons (car lst) (extract-from-list (- n 1) (cdr lst) num-elem))
        '())))

;; kontrollerar om first-n och take skiljer sig åt
(define first-n-correct?
  (lambda (n lst)
    (define own (first-n n lst))
    (define pre-build (take lst n))
    (if (comp-elem own pre-build)
        #t
        #f)))

;; TEZTEXEMPLES!!!

;;uppgift 6

;;skapar en lista med element ifrån ett visst interval med steg som väljas av användaren
(define enumerate
  (lambda (from to step)
    (if (> from to)
        '()
        (cons from (enumerate (+ from step) to step)))))


;;uppgift 7

;;retunerar en lista i omvändordning
(define reverse-order-rek
  (lambda (lst)
    (append-elem lst)))

(define append-elem
  (lambda (lst)
    (if (null? (cdr lst))
        lst
        (list (append-elem (cdr lst)) (car lst)))))