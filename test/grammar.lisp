;;;; grammar.lisp --- Tests for the infix expressions grammar.
;;;;
;;;; Copyright (C) 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:in-package #:parser.infix-expressions.test)

(in-suite parser.infix-expressions)

(test parse.smoke

  (mapc
   (lambda+ ((bindings input expected))
     (progv
         (mapcar #'first bindings)
         (mapcar #'second bindings)
       (is (equal expected (let ((*builder* 'list))
                             (esrap:parse 'expr input #+l :grammar #+l '#:infix-expressions))))))

        '((((*disjunction-expression*    :||)
            (*conjunction-expression*    :and)
            (*negation-expression*       :not)
            (*leaf-expression*           :literals-and-identifiers)
            (*identifier-expression*     :alphanumeric)
            (*string-literal-expression* :double-quotes)
            (*comment-expression*        :#))
           "bla * u+u || (u||-u) and not  (u = u and u != u)"
           (or (+ (* :|bla| :|u|) :|u|)
               (and (or :|u| (- :|u|)) (not (and (= :|u| :|u|) (/= :|u| :|u|)))))))))
