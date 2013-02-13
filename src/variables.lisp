;;;; variables.lisp --- Variables used by the parser.infix-expressions system.
;;;;
;;;; Copyright (C) 2012, 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:in-package #:parser.infix-expressions)

;;; Builder

(declaim (special *builder*))

(defvar *builder* nil
  "Stores the builder object that should be used to construct parse
   results.")

;;; Syntax variation selectors

(declaim (special *comment-expression*
                  *whitespace-expression*
                  *disjunction-expression* *conjunction-expression*
                  *negation-expression*
                  *leaf-expression*
                  *identitfier-expression*
                  *string-literal-expression*))

(defvar *disjunction-expression* :or
  "TODO(jmoringe): document")

(defvar *conjunction-expression* :and
  "TODO(jmoringe): document")

(defvar *negation-expression* :not
  "TODO(jmoringe): document")

(defvar *leaf-expression* nil
  "TODO(jmoringe): document")

(defvar *identifier-expression* nil
  "TODO(jmoringe): document")

(defvar *string-literal-expression* nil
  "TODO(jmoringe): document")

(defvar *comment-expression* nil
  "TODO(jmoringe): document")

(defvar *whitespace-expression* :space-tab-newline?
  "TODO(jmoringe): document")
