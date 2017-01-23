#lang racket
(require rackunit)
(require rackunit/text-ui)
;; (require rackunit/gui)
(require "la01.rkt")

#|
RackUnit is a unit-testing framework for Racket. Unit tests can be thought of 
tests for individual components and parts of systems. There are several other 
forms (or levels) of testing, including testing an entire system.

You should get used to writing tests for smaller components (though not 
necessarily this small), and learn about testing. You do not need to know
 anything about this particular framework. If you want to read more, you can
 find information at http://docs.racket-lang.org/rackunit/

--- Usage
(run-tests lab1-tests)

OR the slower-but-prettier
   (require rackunit/gui)
   (test/gui lab1-tests)


Test cases (mostly) by Johan Billman, 2013.

|#

(define lab1-tests
  (test-suite
   "Labb 1"
   
   ;; Uppgift 2
   (test-suite "2: sum"
               (test-equal? "(sum 5)" (sum-rec 5) 15)
               (test-equal? "(sum 105)" (sum-iter 105) 5565)
               (test-equal? "(sum 0)" (sum-iter 0) 0))
   
   ;; Uppgift 3
   (test-suite "3: powers-of-two"
               (test-equal? "(powers-of-two 3)" (powers-of-two 3) 8 )
               (test-equal? "(powers-of-two 31)" (powers-of-two 31) 2147483648 ))
   
   ;; Uppgift 4
   (test-suite "4: pascal"
               (test-equal? "(pascal 15 2)" (pascal 15 2) 105)
               (test-equal? "(pascal 32 5)" (pascal 32 5) 201376 ))
   
   ;; Uppgift 5
   ;; Nope.
   
   ;; Uppgift 6
   (test-suite
    "6: digit procedures and randomness"
    (test-equal? "(sum-of-digits 104)" (sum-of-digits 104) 5)   
    (test-equal? "(last-digit 645463)" (last-digit 645463) 3)
    (test-equal? "(but-last-digit 65438)" (but-last-digit 65438) 6543)
    (test-equal? "(sum-of-digits 104)" (sum-of-digits 104) 5)
    (test-equal? "(number-of-digits 0)" (number-of-digits 0) 1)
    (test-equal? "(number-of-digits 500)" (number-of-digits 500) 3)
    (test-true  "(divisible? 57 19)" (divisible? 57 19))
    (test-false "(divisible? 57 56)" (divisible? 57 56))
    
    (test-true
     "random-from-to in range"
     (and (<= 123 (random-from-to 123 124))
          (= 2 (random-from-to 2 2))
          (>= 124 (random-from-to 123 124)))))
   
   ;; Uppgift 7
   (test-suite
    "7: simple-sv-nums"
    (test-true "(simple-sv-num? 910464 12)" 
               (simple-sv-num? 910464 12))
    (test-true "make-simple-sv-num should generate a valid simple-sv-num" 
               (simple-sv-num? (make-simple-sv-num 23) 23))
    (test-false "make-simple-sv-num should not generate invalid simple-sv-nums"
                (simple-sv-num? (make-simple-sv-num 23) 21)))
   
   ;; Uppgift 8
   ;; Providing a (guaranteed-finite-time) test case for this would show the solution to the problem.
   
   ;; Uppgift 9
   (test-suite
    "9: sum-and-apply-to-digits"
    (test-equal? "sum-and-apply-to-digits, case 0" (sum-and-apply-to-digits 0 (lambda (dig pos) 4)) 4)
    (test-equal? "(sum-and-apply-to-digits 34 (lambda (dig pos) (* dig pos)))" 
                 (sum-and-apply-to-digits 34 (lambda (dig pos) (* dig pos))) 11)
    (test-case
     "sum of digits med sum-and-apply..."
     (let ((tal (random 99999)))
       (check-equal? (sum-of-digits-high-order tal) 
                     (sum-of-digits tal) 
                     (string-append "Test case " (number->string tal)))))
    
    (test-case
     "number of digits med sum-and-apply..."
     (let ((tal (random 99999)))
       (check-equal? (number-of-digits-high-order tal) 
                     (number-of-digits tal) 
                     (string-append "Test case " (number->string tal)))))) 
   
   ;; Uppgift 10
   (test-suite
    "10: person-number?"
    (test-pred "Testing 920227-1772." person-number? 9202271772)
    (test-pred "Testing 920227-1970. Note the check-digit 0!" person-number? 9202271970)
    (test-false "Testing 920227-1979. Weed out false positives." (person-number? 9202271979))
    (test-false "Testing 111111-1110. Weed out false positives." (person-number? 1111111110)))))

(run-tests lab1-tests)