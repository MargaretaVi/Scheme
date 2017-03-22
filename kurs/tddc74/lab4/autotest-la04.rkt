#lang racket
(require "la04.rkt")
(require rackunit)
;; (require rackunit/gui)
(require rackunit/text-ui)

(require racket/string)

(define (list-gen length)
  (if (zero? length)
      '()
      (cons (random length) (list-gen (- length 1)))))


;; Generate a list of random integers of a particular length.
(define lab4-tests
  (test-suite
   "Labb 4"   
   ;; Uppgift 1
   ;; Nope.
   
   ;; Uppgift 2
   (test-suite
    "3: for-each"
    (test-equal? "for-each doesn't return anything" (for-each-element * '(1 2 3)) (void))
    (test-equal? "for-each does what it should" 
                 (let ((sum 0))
                   (for-each-element (lambda (num) (set! sum (+ sum num)))
                                     '(4 5 6 7))
                   sum) 22))
   
   ;; Uppgift 3
   ;; Nope.
   
   
   ;; Uppgift 4
   ;; Nope
   ;; Uppgift 5   
   
   (test-suite 
    "5: count-calls"
    (test-begin      
     (count-calls)
     (count-calls)
     (count-calls)
     (count-calls)
     (void))
    (test-equal? "Have the calls been counted?" (count-calls 'how-many-calls) 4)
    (test-equal? "Reset doesn't return anything" (count-calls 'reset) (void))
    (test-equal? "Reset does reset the counter" (count-calls 'how-many-calls) 0))
   
   ;; Uppgift 6
   ;; Nope.
   
   ;; Uppgift 7
   
   (test-suite
    "7: make-monitored"
    (test-begin
     (define foobar 
       (make-monitored 
        (lambda (n)
          (if (negative? n)
              314
              (+ (foobar (- n 1)) 
                 (foobar (- n 2)) 
                 (foobar (- n 3)))))))
     
     (define rm (make-monitored random))    
     (foobar 10)
     (rm)
     (rm 20)
     (void)
     (test-pred "make-monitored returns a procedure?" procedure? (make-monitored max))
     (test-equal? "make-monitored returns a procedure that counts" (foobar 'how-many-calls) 1801)
     (test-equal? "make-monitored returns a procedure that counts" (rm 'how-many-calls) 2)))
   
   
   
   ;; Uppgift 8   
   ;; Nope.
   
   ;; Uppgift 9
   (test-suite
    "9: rev loop"
    (let 
        ((lst (list-gen 100)))
      (test-equal? "linear reverse" (rev lst) (reverse lst))))
   
   ;; Uppgift 10-11
   (test-suite 
    "10: reader"
    (let ((tmp '()))
      (reader "autotest-la04-text.txt"
              (lambda (current-line)
                (set! tmp (cons current-line tmp))))
      (set! tmp (string-join (reverse tmp) " "))
      (test-equal? "reader" tmp 
                   "'Curiouser and curiouser!' cried Alice (she was so much surprised, that for the moment she quite forgot how to speak good English); 'now I'm opening out like the largest telescope that ever was! Good-bye, feet!' (for when she looked down at her feet, they seemed to be almost out of sight, they were getting so far off). 'Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I'm sure I shan't be able! I shall be a great deal too far off to trouble myself about you: you must manage the best way you can;—but I must be kind to them,' thought Alice, 'or perhaps they won't walk the way I want to go! Let me see: I'll give them a new pair of boots every Christmas.' ")))
   
   
   (test-suite
    "11: reader + writer"
    (let ((tmp '())
          (test '(Detta är ett primitivt test)))
      (writer "" "rand_tmp.txt")
      (for-each 
       (lambda (sym) 
         (writer sym "rand_tmp.txt" +))
       test)         
      (reader "rand_tmp.txt"
              (lambda (cur-line) 
                (set! tmp (cons (string->symbol cur-line) tmp))))
      (set! tmp (reverse tmp))
      (test-equal? "read+write" (cdr tmp) test)))))

(run-tests lab4-tests)