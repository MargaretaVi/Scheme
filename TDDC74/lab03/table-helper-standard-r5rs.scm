;; table-helper.scm

;; This version is for Scheme standard 5, dvs s5rs.
;; This module provides the following procedures: 
;; put, get, display-table.
;:
;; load it by adding the following expression
;; to the beginning of your .scm-file:
;; (require (file "table-helper.scm"))

;; Note to students: you do not need to understand this code
;; when you do lab02a, however, the techniques used below
;; will be introduced in lab03-05

(module 
    table-helper
  mzscheme
  
  (provide put 
           get 
           display-table)
  
  (define (make-table)
    (let ((local-table (list '*table*)))
      (define (lookup key-1 key-2)
        (let ((subtable (assoc key-1 (cdr local-table))))
          (if subtable
              (let ((record (assoc key-2 (cdr subtable))))
                (if record
                    (cdr record)
                    #f))
              #f)))
      
      (define (insert! key-1 key-2 value)
        (let ((subtable (assoc key-1 (cdr local-table))))
          (if subtable
              (let ((record (assoc key-2 (cdr subtable))))
                (if record
                    (set-cdr! record value)
                    (set-cdr! subtable
                              (cons (cons key-2 value)
                                    (cdr subtable)))))
              (set-cdr! local-table
                        (cons (list key-1
                                    (cons key-2 value))
                              (cdr local-table)))))
        'ok)
      
      (define (display* . args)
        (for-each display args))
      
      (define (display-table)
        (for-each (lambda (subtable)
                    (for-each (lambda (entry)
                                (display* (car subtable)
                                          "\t  \t"
                                          (car entry)
                                          "\t  \t"
                                          (cdr entry)
                                          "\n"))
                              (cdr subtable)))
                  (cdr local-table)))
      
      (define (dispatch m)
        (cond ((eq? m 'lookup-proc) lookup)
              ((eq? m 'insert-proc!) insert!)
              ((eq? m 'display-table) display-table)
              (else (error "Unknown operation -- TABLE" m))))
      dispatch))
  
  (define operation-table (make-table))
  (define get (operation-table 'lookup-proc))
  (define put (operation-table 'insert-proc!))
  (define display-table (operation-table 'display-table))
  
  )
