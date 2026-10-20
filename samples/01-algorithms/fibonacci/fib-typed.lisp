(declaim (optimize (speed 3) (safety 0)))
(declaim (ftype (function ((integer 0 40)) (integer 0 102334155)) fib))

(defun fib (n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(format t "~a~%" (time (fib 35)))
