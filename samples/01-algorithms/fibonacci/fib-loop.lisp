;; ループ（繰り返し）でフィボナッチ数を求める版。
;; 二重再帰は同じ値を何度も計算し直すが、ループなら直前の2つの値を持ち回すだけで済む。
;; 計算量は O(n)（二重再帰は指数的）なので、fib(35) でもほぼ一瞬で終わる。
(declaim (optimize (speed 3) (safety 0)))
(declaim (ftype (function ((integer 0 90)) (unsigned-byte 62)) fib))

(defun fib (n)
  (let ((a 0)   ; fib(i)
        (b 1))  ; fib(i+1)
    (declare (type (unsigned-byte 62) a b))
    ;; n 回、(a, b) を (b, a+b) に進める。最後の a が fib(n)。
    (dotimes (i n a)
      (psetf a b
             b (the (unsigned-byte 62) (+ a b))))))

;; 実行時間を計測して結果を表示する。
(format t "~a~%" (time (fib 35)))
