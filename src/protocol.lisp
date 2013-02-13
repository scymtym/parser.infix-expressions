;;;; protocol.lisp ---
;;;;
;;;; Copyright (C) 2012, 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:in-package #:parser.infix-expressions)

;;; Builder Protocol

(defgeneric make-comment (builder content)
  (:documentation
   "TODO(jmoringe): document"))

(defgeneric make-identifier (builder name)
  (:documentation
   "TODO(jmoringe): document"))

(defgeneric make-operator/1 (builder op arg)
  (:documentation
   "TODO(jmoringe): document"))

(defgeneric make-operator/2 (builder op left right)
  (:documentation
   "TODO(jmoringe): document"))

(defgeneric make-operator/3 (builder op left middle right)
  (:documentation
   "TODO(jmoringe): document"))
