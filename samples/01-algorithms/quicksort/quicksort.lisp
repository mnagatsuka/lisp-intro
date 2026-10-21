;; クイックソート（リスト版）。
(defun quicksort (list)
  ;; 空リスト (NIL) なら when は NIL を返す＝空リストのまま。再帰の終了条件。
  (when list
    ;; 先頭要素を基準値 (pivot) に、残りを rest に束縛する。
    (let ((pivot (first list))
          (rest (rest list)))
      ;; 「pivot より小さい要素」＋「pivot」＋「pivot 以上の要素」を連結する。
      ;; それぞれの部分リストを再帰的にソートするのがポイント。
      (append (quicksort (remove-if-not (lambda (x) (< x pivot)) rest))
              (list pivot)
              (quicksort (remove-if-not (lambda (x) (>= x pivot)) rest))))))

;; 実行例：(1 1 2 3 4 5 6 9) と表示される。重複する値 (1) も保持される。
(format t "~a~%" (quicksort '(3 1 4 1 5 9 2 6)))
