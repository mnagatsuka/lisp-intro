;; 最適化の方針をコンパイラに伝える。
;; speed 3 = 速度を最優先、safety 0 = 実行時の型・範囲チェックを省略（危険だが速い）。
(declaim (optimize (speed 3) (safety 0)))
;; fib の型宣言：引数は 0〜40 の整数、戻り値は 0〜102334155 (= fib(40)) の整数。
;; 型が分かることで、コンパイラは generic な演算ではなく高速な整数演算を生成できる。
(declaim (ftype (function ((integer 0 40)) (integer 0 102334155)) fib))

;; 本体は fib.lisp と同じ。型宣言を足すだけで速くなるのが Lisp の特徴。
(defun fib (n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

;; 実行時間を計測して結果を表示する。
(format t "~a~%" (time (fib 35)))
