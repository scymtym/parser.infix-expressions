;;;; builder-list.lisp ---
;;;;
;;;; Copyright (C) 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:in-package #:parser.infix-expressions)

(defmethod make-node ((builder (eql 'list))
                      (kind    (eql :comment))
                      &key
                      content)
  (check-type content string)
  (list :comment '() :content content))

(defmethod make-node ((builder (eql 'list))
                      (kind    (eql :identifier))
                      &key
                      name)
  (check-type name string)
  (list :identifier '() :name name))

(defmethod make-node ((builder (eql 'list))
                      (kind    (eql :operator))
                      &key
                      name
                      args)
  (check-type name (or symbol string))
  (list :operator args :operator name))
