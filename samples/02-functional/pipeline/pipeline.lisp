(defparameter *items*
  '((:name "Land of Lisp"      :category :book       :price 4000)
    (:name "Mechanical Pencil" :category :stationery :price 300)
    (:name "On Lisp"           :category :book       :price 3000)
    (:name "Coffee Mug"        :category :kitchen    :price 800)
    (:name "ANSI Common Lisp"  :category :book       :price 5000)
    (:name "Notebook"          :category :stationery :price 200)))

(defun book-p (item)
  (eq (getf item :category) :book))

(defun price-with-tax (item)
  (floor (* (getf item :price) 11) 10))

(defun select-books (items)
  (remove-if-not #'book-p items))

(defun with-tax (items)
  (mapcar #'price-with-tax items))

(defun total (prices)
  (reduce #'+ prices))

;; Show each step.
(let* ((books  (select-books *items*))
       (prices (with-tax books)))
  (format t "1. books:      ~{~a~^, ~}~%" (mapcar (lambda (item) (getf item :name)) books))
  (format t "2. with tax:   ~a~%" prices)
  (format t "3. total:      ~a~%" (total prices)))

;; The same pipeline as a single expression.
(format t "total: ~a~%"
        (reduce #'+
                (mapcar #'price-with-tax
                        (remove-if-not #'book-p *items*))))
