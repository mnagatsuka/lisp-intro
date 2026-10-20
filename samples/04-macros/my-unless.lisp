(defmacro my-unless (condition &body body)
  `(if ,condition
       nil
       (progn ,@body)))

;; 条件が偽のとき：本体が実行される
(print (my-unless (> 1 2)
         (format t "executed~%")
         :done))

;; 条件が真のとき：本体は評価されない（"executed" は表示されない）
(print (my-unless (< 1 2)
         (format t "not printed~%")
         :done))

;; 展開結果：普通の if に書き換わる
(print (macroexpand-1 '(my-unless (> 1 2) (format t "executed~%") :done)))
(terpri)
