;;;; protocol.lisp --- Protocol functions provided by the parser.infix-expressions.
;;;;
;;;; Copyright (C) 2012, 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:in-package #:parser.infix-expressions)

;;; Builder Protocol

(defgeneric make-node (builder kind &key bounds &allow-other-keys)
  (:documentation
   "Use BUILDER to make a syntax tree node of kind KIND and return it.

    BOUNDS is of the form (START . END) and indicates the input range
    for which the tree is constructed."))
