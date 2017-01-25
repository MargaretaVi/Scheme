#lang racket
(require racket/trace)
(provide (all-defined-out))
;; uppgift 1

;(define foo (* 1 2 3 4))
;(define foobar (lambda () (* 1 2 3 4)))

;; foo --> 24, Eftersom foo är definierad som talet (* 1 2 3 4) = 24
#|24|#

;; foobar --> "procedure:foobar"  den är definierad som en procedur

;; (foo) --> ger felmeddelande, eftersom den inte är en procedur 
;; och () anropar en procedur

;; (foobar) --> 24. Kallelse på procedur
#|(foobar)
(* 1 2 3 4)
24 
|#

;;uppgift 2

;; linjärrekursiv funktion som summerar alla (>= 0) tal upp till det givna
(define sum-rec
  (lambda (n)
    (if (= n 0)
        0
        (+ n (sum-rec (- n 1 ))))))

;;  iterativt rekursiv  som summerar alla tal (>= 0) upp till det givna
(define sum-iter
  (lambda (n)
    (iter n 0)))

;; hjälpfunktion till sum-iter
(define iter
  (lambda (a count)
    (if (= a 0)
     0
     (+ a (iter (- a 1) (+ a count))))))

;; uppgift 3

#|(define powers-of-two
  (lambda (expt)
(expt 2 expt)))|#

#|scheme syntax är prefix, alltså operationen först och sedan operanderna.
I kroppen för lambda funktionen så har labbassen skrivit expt som en operation,
men när den i själva verket är en parameter. Därför fungerar inte koden|#

; egen definierade två-upphöjt till
(define powers-of-two
  (lambda (exp)
    (if (= exp 0)
        1
        (* 2 (powers-of-two (- exp 1))))))

;; uppgift 4
;; en funktion som ger ut elementet i pascals triangel givet rad och kolumn
(define pascal
  (lambda (row col)
    (if (or (= row col) (= col 0))
        1
        (+ (pascal (- row 1) col) (pascal (- row 1) (- col 1))))))

;; uppgift 5

#| (pascal 4 3)
(+ (pascal 3 3) (pascal 3 2))
(+ 1 (+ (pascal 2 2) (pascal 2 1)))
(+ 1 (+ 1 (+ (pascal 1 1) (pascal 1 0))))
(+ 1 (+ 1 (+ 1 1)))
(+ 1 (+ 1 2))
(+ 1 3)
4 |#

;; uppgift 6
;; tar ut den sista siffran i strängen
(define last-digit
  (lambda (n)
    (remainder n 10)))

;; ger ut alla siffror utom den sista som en sträng
(define but-last-digit
  (lambda (n)
    (quotient n 10)))

;; retunerar siffersumman
(define sum-of-digits
  (lambda (n)
    (if (= (but-last-digit n) 0)
        n
        (+ (last-digit n) (sum-of-digits (but-last-digit n))))))

;; Räknar antalet siffor i talet
(define number-of-digits
  (lambda (n)
    (counter n 1)))

(define counter
  (lambda (n count)
    (if (= (but-last-digit n) 0)
        count
        (counter (but-last-digit n) (+ count 1)))))
     
;; kontrollerar om talet är dividerbart med en dividerare, 
;; alltså om div är en multipel av n

(define divisible?
  (lambda (n div)
    (if (= (remainder n div) 0)
        #t
        #f)))

;; ger ut ett slumpmässigt tal ifrån givet intervall
(define random-from-to
  (lambda (from to)
    (define rand (random (+ 1 to)))
    (if (< rand from)
        (+ rand (- from rand))
        rand)))

;; uppgift 7
;; kollar om ett tal är dividerbar med en annan
(define simple-sv-num?
  (lambda (int div)
    (if (divisible? (sum-of-digits int) div)
        #t
        #f)))

;; skapar ett 6-siffrigt tal som är jämtdelbart med en delare
(define make-simple-sv-num
  (lambda (div)
    (let ((six-digit (random-from-to 100000 999999)))
      (if (simple-sv-num? six-digit div)  six-digit
          (make-simple-sv-num div)))))

;; uppgift 8
;; skapar ett 6-siffrigt tal som uppfyller villkor enligt labpm

(define make-cc-sv-num
  (lambda ()
    (let ((num (random-from-to 100000 999999)))
      (if (divisible? (weights num 0) 10)
          num
          (make-cc-sv-num)))))

(define weights
  (lambda (num count)
    (if (= (number-of-digits num) 1)
        count
        (if (and (even? (number-of-digits num)) (>= (last-digit num) 5))
            (weights (but-last-digit num) 
                     (+ count (+ (* 2 (last-digit num)) 1)))
            (if (and (even? (number-of-digits num)) (< (last-digit num )5))
                (weights (but-last-digit num) (+ count (* 2 (last-digit num))))
                (weights (but-last-digit num) (+ count (last-digit num))))))))

;; uppgift 9a
;; Denna funktion tar in en process och ett tal och behandlar talet med processen
(define sum-and-apply-to-digits
  (lambda (num proc)
    (define len (number-of-digits num))
    (help-sum num proc len)))
            

(define help-sum
  (lambda (num proc len)
    (if (= len 1)
        (proc num 1)
        (+ (proc (last-digit num) len)
           (help-sum (but-last-digit num) proc (- len 1))))))
 

;; uppgift 9b

;; omdefinerade funktioner mha sum-and-apply-to-digits
(define number-of-digits-high-order
  (lambda (number)
    (sum-and-apply-to-digits number (lambda (number pos) 1))))
                             
(define sum-of-digits-high-order
  (lambda (number)
    (sum-and-apply-to-digits number (lambda (number pos) number))))

(define make-cc-sv-num-high-order
  (lambda ()
    (let ((num (random-from-to 100000 999999)))
      (if (divisible?
           (sum-and-apply-to-digits num
                                    (lambda (num pos)
                                      (let ((pos (number-of-digits num)))
                                        (cond
                                          ((odd? pos) num)
                                          ((< pos 5) (* 2 num))
                                          (else (+ (* 2 num) 1))))) ) 10)
          num
          (make-cc-sv-num-high-order)))))


;; uppgift 10

;;kontrollerar om ett personer är ett gilltigt personnummer
(define person-number?
  (lambda (num)
    (divisible? (+ (last-digit num)
                   (sum-and-apply-to-digits (but-last-digit num) controll-num))
                10)))

;; kontrollerar om nummret är gilltigt
(define controll-num
  (lambda (digit pos)
    (cond
      ((and (odd? pos) (>= (* 2 digit) 10))
       (sum-of-digits (* 2 digit)))
      ((odd? pos) (* 2 digit))
      (else digit))))
      
