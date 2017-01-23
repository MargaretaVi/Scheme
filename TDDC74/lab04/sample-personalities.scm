;; sample-personalites.scm
;; Updated for PRAM-M VT05
;; Joakim Hellsten, 2005-05-06

(define (make-hello-personality)
  (let ((parent (make-personality)))
    (define (interact self)
      (let ((name (ask (ask parent 'get-agent) 'name)))
        (display name)
        (display ": ")
        (display "Hello my name is ")
        (display name)
        (newline)))
    (lambda (msg)
      (cond
        ((eq? msg 'interact) interact)
        (else (parent msg))))))


(define (tell-player personality . args)
  (for-each display (cons (ask (ask personality 'get-agent) 'name)
                          (cons ": " args))))

(define (make-arithmetic-personality)
  (let ((parent (make-personality))
        (rights 0)
        (total 0))
    (define (interact self)
      ;; create two random integers [0,999] to form the question.
      (let ((num1 (random 1000))
            (num2 (random 1000)))
        (tell-player self "What is " num1 " + " num2 "? ")
        ;; read in an answer and compare it the the right answer.
        (let ((answer (read)))
          (if (and (number? answer) 
                   (= answer (+ num1 num2)))    
              (begin
                (set! rights (+ 1 rights))
                (tell-player self "Mmm, yes, your answer is correct.\n"))
              (tell-player self "You are not very good, are you? "
                           "The correct answer was " (+ num1 num2) ".\n"))
          (set! total (+ 1 total))))
      (tell-player self "You have answered " rights
                   " question(s) correctly out of " total ".\n"))
    (lambda (msg)
      (cond 
        ((eq? msg 'interact) interact)
        (else (parent msg))))))
