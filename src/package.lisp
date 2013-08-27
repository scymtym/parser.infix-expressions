;;;; package.lisp --- Package definition for parser.infix-expressions system.
;;;;
;;;; Copyright (C) 2012, 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:defpackage #:parser.infix-expressions
  (:use
   #:cl
   #:alexandria
   #:let-plus

   #:esrap)

  ;; Variables
  (:export
   #:*builder*

   #:*comment-expression
   #:*leaf-expression*
   #:*disjunction-expression*
   #:*conjunction-expression*)

  ;; Builder protocol
  (:export
   #:make-node)

  ;; Rules
  (:export
   #:expr)

  (:documentation
   "TODO"))
