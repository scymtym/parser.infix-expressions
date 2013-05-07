;;;; builder-list.lisp ---
;;;;
;;;; Copyright (C) 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:in-package #:parser.infix-expressions)

(defmethod make-comment ((builder (eql 'list)) (content string))
  (list :comment content))

(defmethod make-identifier ((builder (eql 'list)) (name string))
  (intern name :keyword))

(defmethod make-operator/1 ((builder (eql 'list)) (op symbol) (arg t))
  (list op arg))

(defmethod make-operator/2 ((builder (eql 'list)) (op symbol) (left t) (right t))
  (list op left right))

(defmethod make-operator/3 ((builder (eql 'list)) (op symbol) (left t) (middle t) (right t))
  (list op left middle right))
