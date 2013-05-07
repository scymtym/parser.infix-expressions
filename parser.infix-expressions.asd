;;;; parser.infix-expressions.asd --- System definition for the parser.infix-expressions system.
;;;;
;;;; Copyright (C) 2012, 2013 Jan Moringen
;;;;
;;;; Author: Jan Moringen <jmoringe@techfak.uni-bielefeld.de>

(cl:defpackage #:parser.infix-expressions-system
  (:use
   #:cl
   #:asdf)

  (:export
   #:version/list
   #:version/string))

(cl:in-package #:parser.infix-expressions-system)

;;; Version stuff

(defparameter +version-major+ 0
  "Major component of version number.")

(defparameter +version-minor+ 1
  "Minor component of version number.")

(defparameter +version-revision+ 0
  "Revision component of version number.")

(defun version/list ()
  "Return a version of the form (MAJOR MINOR REVISION)."
  (list +version-major+ +version-minor+ +version-revision+))

(defun version/string ()
  "Return a version string of the form \"MAJOR.MINOR.REVISION\"."
  (format nil "~{~A.~A.~A~}" (version/list)))

;;; System definition

(defsystem :parser.infix-expressions
  :author      "Jan Moringen <jmoringe@techfak.uni-bielefeld.de>"
  :maintainer  "Jan Moringen <jmoringe@techfak.uni-bielefeld.de>"
  :version     #.(version/string)
  :license     "LLGPLv3; see COPYING file for details."
  :description "Provides parsing of Infix-Expressions expressions."
  :depends-on  (:alexandria
                (:version :let-plus "0.2")
                (:version :esrap    "0.9"))
  :components  ((:module     "src"
                 :serial     t
                 :components ((:file       "package")
                              (:file       "protocol")
                              (:file       "variables")
                              (:file       "grammar")
                              (:file       "builder-list"))))

  :in-order-to ((test-op (test-op :parser.infix-expressions-test))))

(defsystem :parser.infix-expressions-test
  :author      "Jan Moringen <jmoringe@techfak.uni-bielefeld.de>"
  :maintainer  "Jan Moringen <jmoringe@techfak.uni-bielefeld.de>"
  :version     #.(version/string)
  :license     "LLGPLv3; see COPYING file for details."
  :description "Tests for the parser.infix-expressions system."
  :depends-on  (:alexandria
                (:version :let-plus "0.2")

                :eos)
  :components  ((:module     "test"
                 :serial     t
                 :components ((:file       "package")
                              (:file       "grammar")))))
(defmethod perform ((operation test-op)
                    (component (eql (find-system :parser.infix-expressions-test))))
  (funcall (find-symbol "RUN-TESTS" :parser.infix-expressions.test)))
