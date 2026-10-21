;; マクロ定義：unless を自前で再実装したもの。
;; 関数と違い、マクロは引数を評価する「前に」コードとして受け取り、別のコードに書き換える。
;; &body は「残りの式をすべてリストとして受け取る」という意味（&rest と同じ働き）。
(defmacro my-unless (condition &body body)
  ;; ` (バッククォート) はテンプレート。, (カンマ) の部分だけ値が差し込まれる。
  `(if ,condition
       nil
       ;; ,@ はリストを「展開して」埋め込む（body の各式が progn の中に並ぶ）。
       (progn ,@body)))

;; 条件が偽のとき：本体が実行される
;; (> 1 2) は NIL なので body が評価され、最後の式の値 :done が print される。
(print (my-unless (> 1 2)
         (format t "executed~%")
         :done))

;; 条件が真のとき：本体は評価されない（"executed" は表示されない）
;; 関数なら引数は必ず先に評価されるが、マクロなので評価を制御できる。
(print (my-unless (< 1 2)
         (format t "not printed~%")
         :done))

;; 展開結果：普通の if に書き換わる
;; macroexpand-1 はマクロを 1 段だけ展開し、生成されるコードを確認できる。
;; クォート (') を付けて、展開前のコードをそのまま渡している点に注意。
(print (macroexpand-1 '(my-unless (> 1 2) (format t "executed~%") :done)))
;; 改行を出力して表示を整える。
(terpri)
