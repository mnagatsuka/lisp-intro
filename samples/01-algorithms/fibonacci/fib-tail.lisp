;; 末尾再帰でフィボナッチ数を求める版。
;; 再帰呼び出しが関数の最後（末尾）にあるので、SBCL はこれをジャンプに変換する。
;; その結果、スタックを消費せず、fib-loop.lisp のループとほぼ同じ機械語になる。
;; ※ 末尾呼び出しの最適化は Common Lisp の規格では保証されていない（SBCL では通常有効）。
(declaim (optimize (speed 3) (safety 0)))
(declaim (ftype (function ((integer 0 90)) (unsigned-byte 62)) fib))

(defun fib (n)
  ;; i = 残りの回数、a = fib(k)、b = fib(k+1)。i が 0 になったら a が答え。
  (labels ((iter (i a b)
             (declare (type (integer 0 90) i)
                      (type (unsigned-byte 62) a b))
             (if (= i 0)
                 a
                 (iter (1- i) b (the (unsigned-byte 62) (+ a b))))))
    (iter n 0 1)))

;; 実行時間を計測して結果を表示する。
(format t "~a~%" (time (fib 35)))
