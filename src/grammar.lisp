;;;; grammar.lisp --- Grammar for variable-syntax infix expressions.
;;;;
;;;; Copyright (C) 2012, 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

;;; The `leaf-rule' is special: it is intended to be redefined such
;;; that alternative leaf expression rules are added successively (via
;;; `add-leaf-expression' and `define-leaf-expression'). These rules
;;; should use :when options to ensure that only one alternative is
;;; active at each given time. The active alternative is controlled by
;;; the `*leaf-expr*' special variable.

(cl:in-package #:parser.infix-expressions)

#+l(setf (find-grammar '#:infix-expressions) nil)
#+l(defgrammar #:infix-expressions
  (:use #:whitespace
        #:literals))
#+l(in-grammar #:infix-expressions)

(defun add-expression-alternative (variation-point rule-name)
  "TODO(jmoringe): document"
  (let* ((alternative-rule (symbolicate variation-point '#:-expr))
         (old              (rule-expression (find-rule alternative-rule
                                                       #+l :grammar #+l '#:infix-expressions)))
         (new              `(,(first old) ,@(adjoin rule-name (rest old)))))
    (change-rule alternative-rule new #+l :grammar #+l '#:infix-expressions)))

(defmacro define-expression-alternative (variation-point
                                         symbol-and-options expression
                                         &body options)
  "TODO(jmoringe): document"
  (let+ ((alternative-var (symbolicate '#:* variation-point '#:-expression*))
         ((symbol &rest options1) (ensure-list symbol-and-options))
         (symbol/expr (symbolicate symbol '#:-expr)))
    `(progn
       (defrule ,symbol/expr #+l (,symbol/expr ,@options1)
           ,expression
         (:when (eq ,alternative-var ,(make-keyword symbol)))
         ,@options)
       (add-expression-alternative ',variation-point ',symbol/expr))))

(defmacro defrule/ws (name-and-options
                      expression &body options)
  "Like `esrap:defule' but define additional rules named NAME/WS and
   NAME/?WS which respectively require/ allow EXPRESSION to be
   followed by whitespace.

   NAME-AND-OPTIONS can either just be a rule name or list of the form

     (NAME &key WHITESPACE-RULE WS? ?WS? DEFINER)

   where WHITESPACE-RULE names the rule used to parsed whitespace in
   the NAME/WS and NAME/?WS variants. Defaults to `whitespace'.

   WS? and ?WS? control which of the NAME/WS and NAME/?WS rules should
   be generated. Default is generating both.

   DEFINER is the name of the macro used to define \"main\"
   rule. Defaults to `esrap:defrule'."
  (let+ (((name
           &key
           (whitespace-rule 'whitespace)
           (ws?             t)
           (?ws?            t)
           (definer         'defrule))
          (ensure-list name-and-options))
         (name/ws  (format-symbol *package* "~A/WS" name))
         (name/?ws (format-symbol *package* "~A/?WS" name)))
    `(progn
       (,definer ,name
                 ,expression
                 ,@options)
       ,@(when ws?
           `((defrule ,name/ws
                 (and ,name ,whitespace-rule)
               (:function first))))
       ,@(when ?ws?
           `((defrule ,name/?ws
                 (and ,name (? ,whitespace-rule))
               (:function first)))))))

(defmacro define-binary-operator-rule (name-or-names right &body options)
  "TODO(jmoringe): document"
  (let+ (((name &rest names) (ensure-list name-or-names))
         (rule-name (symbolicate name '#:-expr))
         (simple    '())
         ((&flet+ make-simple-rule ((name &optional (op name)))
            (let ((simple-rule-name (symbolicate '#:simple- name '#:-expr)))
              (push simple-rule-name simple)
              `(defrule ,simple-rule-name
                   (and ,right
                        whitespace-expr ,(string-downcase name) whitespace-expr
                        ,rule-name)
                 (:destructure (left ws1 op ws2 right)
                   (declare (ignore ws1 op ws2))
                   (make-operator/2 *builder* ',op left right)))))))
    `(progn
       ,@(mapcar (compose #'make-simple-rule #'ensure-list)
                 (or names (list name)))

       (defrule ,rule-name (or ,@simple ,right)
         ,@options))))

(defrule expr
    (and (* comment-expr)
         (or expr/parenthesis expr/no-parenthesis)
         (* comment-expr))
  (:function second))

(defrule comment-expr
    (or ))

#+l(define-expression-alternative comment |#|
    (and esrap::comment/# #\Newline)
  (:function first))

(defrule whitespace-expr
    (or ))

(define-expression-alternative whitespace space-tab-newline?
    (? (* (or #\Space #\Tab #\Newline)) #+l whitespace))

(defrule expr/parenthesis
    (and #\( whitespace-expr expr/no-parenthesis whitespace-expr #\))
  (:function third))

(defrule expr/no-parenthesis
    disjunction-expr)

(defrule disjunction-expr
    (or or-expr \|\|-expr))

(define-binary-operator-rule or conjunction-expr
  (:when (eq *disjunction-expression* :or)))

(define-binary-operator-rule (\|\| (\|\| or)) conjunction-expr
  (:when (eq *disjunction-expression* :||)))

(defrule conjunction-expr
    (or and-expr &&-expr))

(define-binary-operator-rule and negation-expr
  (:when (eq *conjunction-expression* :and)))

(define-binary-operator-rule (&& (&& and)) negation-expr
  (:when (eq *conjunction-expression* :&&)))

(defrule negation-expr
    (or equality-expr))

(define-expression-alternative negation not
    (and "not" whitespace-expr equality-expr)
  (:destructure (not ws expr)
    (declare (ignore not ws))
    (make-operator/1 *builder* 'not expr)))

(define-expression-alternative negation !
    (and "!" whitespace-expr equality-expr)
  (:destructure (not ws expr)
    (declare (ignore not ws))
    (make-operator/1 *builder* 'not expr)))

(define-binary-operator-rule (equality = (!= /=))
    relational-expr)

(define-binary-operator-rule (relational < <= > >=) additive-expr)

(define-binary-operator-rule (additive + -) multiplicative-expr)

(defrule multiplicative-expr
    (or binary-multiplicative-expr unary-expr))

(define-binary-operator-rule (binary-multiplicative * / mod) unary-expr)

(defrule unary-expr
    (or unary-multiplicative-expr comment-and-leaf-expr leaf-expr))

(defrule unary-multiplicative-expr
    (and #\- unary-expr)
  (:destructure (minus expr)
    (declare (ignore minus))
    (make-operator/1 *builder* '- expr)))

(defrule comment-and-leaf-expr
    (and (+ comment-expr) leaf-expr)
  (:function second))

(defrule leaf-expr
    (or expr/parenthesis))

(define-expression-alternative leaf literals-and-identifiers
    (or string-literal-expr identifier-expr))

(defrule string-literal-expr
    (or ))

#+l (define-expression-alternative string-literal double-quotes
    esrap::string/double-quotes)

(defrule identifier-expr
    (or ))

(define-expression-alternative identifier alphanumeric
    (and (alpha-char-p character) (* (alphanumericp character)))
  (:lambda (characters)
    (make-identifier *builder* (text characters))))
