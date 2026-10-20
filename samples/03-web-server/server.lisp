(load "/opt/quicklisp/setup.lisp")
(ql:quickload :hunchentoot :silent t)

(hunchentoot:define-easy-handler (hello :uri "/hello") (name)
  (format nil "Hello, ~A!" (or name "Lisp")))

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))
(sleep most-positive-fixnum)
