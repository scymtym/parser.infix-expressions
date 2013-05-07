;;;; package.lisp --- Package definition for tests of the parser.infix-expressions system.
;;;;
;;;; Copyright (C) 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:defpackage #:parser.infix-expressions.test
  (:use
   #:cl
   #:let-plus

   #:eos

   #:parser.infix-expressions)

  (:export
   #:run-tests)

  (:documentation
   "This package contains tests of the parser.infix-expressions
    system."))

(cl:in-package #:parser.infix-expressions.test)

(def-suite parser.infix-expressions)

(defun run-tests ()
  (eos:run! 'parser.infix-expressions))
