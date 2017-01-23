#lang racket
(require "la02.rkt")
(require rackunit)
;; (require rackunit/gui)
(require rackunit/text-ui)

;; Generate a list of random integers of a particular length.
(define (list-gen length)
  (if (zero? length)
      '()
      (cons (random length) (list-gen (- length 1)))))

(define lab2-tests
  (test-suite
   "Labb 2"   
   ;; Uppgift 1
   ;; Nope.
   
   ;; Uppgift 2
   (test-suite
    "2: atoms etc"
   (test-pred "3 is an atom" atom? 3)
   (test-pred "symbols are atoms" atom? 'lst)
   (test-false "simple pairs are not atoms" (atom? (cons 1 2)))
   (test-false "non-empty proper lists are neither" (atom? (list 1 2))))
   
   ;; Uppgift 3
   (test-suite
    "3: counting"
   (test-equal? "count-list, nested structures. Length of (1 (2 3) 4)"
                (count-list '(1 (2 3) 4)) 3)
   
   (test-pred "count-list-correct?" count-list-correct? '(1 (2 3) 4)))
   
   
   ;; Uppgift 4
   (test-suite 
    "4: keep-if"
   (test-equal? "keep-if"                 
                (keep-if (lambda (obj) (not (number? obj))) (list 'one 2 'three 4))
                '(one three))   
   
   (test-pred "keep-if-correct" 
              (lambda (lst) 
                (keep-if-correct? (lambda (obj) (not (number? obj))) lst)) '(1 (2 3) 4)))
   
   ;; Uppgift 5
   (test-suite 
    "Uppgift 5: first-n"
    (test-pred "(first-n 0 ...) is null" null? (first-n 0 (list 1 2 3 4)))
    (test-equal? "(first-n 2 '(1 (2 3) 2 3)). Nested structure."  
                 (first-n 2 '(1 (2 3) 2 3))
                 '(1 (2 3)))
    
    
    (test-pred "first-n med 0" 
               (lambda (lst)
                 (first-n-correct? 0 lst))
               '(1 (2 3) 2 3))
    
    (test-pred "first-n with n > length of list" 
               (lambda (lst)
                 (first-n-correct? 1000 lst))
               '(1 (2 3) 2 3))
    
    (test-pred "Standard first-n" (lambda (lst)
                                    (first-n-correct? 2 lst))
               '(1 (2 3) 2 3)))
   
   ;; Uppgift 6
   (test-suite
    "6: enumerate"
   (test-equal? "(enumerate 1 1 1) is singleton" (enumerate 1 1 1) '(1))
   (test-pred "(enumerate 1 0 0) should be empty" null? (enumerate 1 0 0)))
   
   ;; Uppgift 7
   (test-suite
    "7: reverses"
    (let 
        ((lst (list-gen 100)))
      (test-equal? "linear reverse" (reverse-order-rek lst) (reverse lst))
      (test-equal? "linear iterative" (reverse-order-iter lst) (reverse lst))))
   
   
   ;; Uppgift 8   
   (test-equal? "8: mapping sqrt"
                (map-to-each sqrt '(1 4 9 16 256))
                (map sqrt '(1 4 9 16 256)))   
   
   ;; Uppgift 9
   (test-suite
    "9: insertion sort"
    (let*
        ((size 100)
         (rands (list-gen size)) ;; Random list
         (sorted (sort rands <)) ;; Sorted
         (num (random size))  
         (ext-sorted (sort (cons num sorted) <)))
      (test-true "insert-at-asc-place" 
                 (equal? ext-sorted (insert-at-asc-place num sorted)))          
      (test-true "insertion sort" 
                 (equal? sorted (insert-sort rands)))))
   
   ;; Uppgift 10-14
   (test-suite
    "10-14: nested structures of various kinds"
    (let 
        ((lst3'((1 (4 . pair)) symbol (2 . pair) symbol (3 . pair) symbol (4 . pair) symbol (3 . pair) (2 (3 symbol)))))
      
      (test-equal? "keep-if-all" (keep-if-all (lambda (x) (eq? 'pair x)) lst3) '((pair) pair pair pair pair (())))
      (test-equal? "count-all, nested structure" (count-all lst3) 18)
      (test-true "occurs?" (occurs? 4 lst3))
      (test-false "occurs? No false positive" (occurs? 5 lst3))
      (test-equal? "subst-all" (subst-all 1 2 '(1 1 1 1 1)) '(2 2 2 2 2))
      
      (test-true "list-equal?" (list-equal? '(1 2 3 4) '(1 2 3 4)))
      (test-true "list-equal? Nested" (list-equal? '(1 2 (3) 4) '(1 2 (3) 4)))      
      (test-false "list-equal? No false positive" (list-equal? '(1 2 3 4) '(1 2 3 . 4)))))))
(run-tests lab2-tests)

