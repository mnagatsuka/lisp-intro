;;; ドメインモデル（すべて読み取り専用）

(defstruct (title (:constructor %make-title (value)))
  (value "" :type string :read-only t))

(defstruct (open-todo (:constructor make-open-todo (id title)))
  (id 0 :type integer :read-only t)
  (title nil :type title :read-only t))

(defstruct (done-todo (:constructor make-done-todo (id title)))
  (id 0 :type integer :read-only t)
  (title nil :type title :read-only t))

;;; ワークフロー

(declaim (ftype (function (string) title) validate-title))
(defun validate-title (raw)
  (if (<= 1 (length raw) 50)
      (%make-title raw)
      (error "Title must be 1-50 characters: ~S" raw)))

(declaim (ftype (function (integer string) open-todo) create-todo))
(defun create-todo (id raw-title)
  (make-open-todo id (validate-title raw-title)))

(declaim (ftype (function (open-todo) done-todo) complete-todo))
(defun complete-todo (todo)
  (make-done-todo (open-todo-id todo) (open-todo-title todo)))

;;; 表示

(defun show-open (todo)
  (format t "  [ ] ~D ~A~%" (open-todo-id todo) (title-value (open-todo-title todo))))

(defun show-done (todo)
  (format t "  [x] ~D ~A~%" (done-todo-id todo) (title-value (done-todo-title todo))))

(defun try-create (raw)
  (handler-case (create-todo 99 raw)
    (error (e) (format t "  rejected: ~A~%" e))))

;;; デモ

(let* ((todos (list (create-todo 1 "Buy milk")
                    (create-todo 2 "Write slides")))
       (finished (list (complete-todo (second todos))))
       (pending  (remove-if (lambda (todo) (= (open-todo-id todo) 2)) todos)))
  (format t "Open:~%")
  (mapc #'show-open pending)
  (format t "Done:~%")
  (mapc #'show-done finished))

(format t "Invalid titles:~%")
(try-create "")
(try-create (make-string 51 :initial-element #\a))
