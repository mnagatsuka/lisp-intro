(defun quicksort (list)
  (when list
    (let ((pivot (first list))
          (rest (rest list)))
      (append (quicksort (remove-if-not (lambda (x) (< x pivot)) rest))
              (list pivot)
              (quicksort (remove-if-not (lambda (x) (>= x pivot)) rest))))))

(format t "~a~%" (quicksort '(3 1 4 1 5 9 2 6)))
