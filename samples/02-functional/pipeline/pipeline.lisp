;; 商品データ。plist（プロパティリスト：キーと値が交互に並ぶリスト）のリスト。
;; defparameter でグローバル変数を定義（慣習として前後を * で囲む）。
(defparameter *items*
  '((:name "Land of Lisp"      :category :book       :price 4000)
    (:name "Mechanical Pencil" :category :stationery :price 300)
    (:name "On Lisp"           :category :book       :price 3000)
    (:name "Coffee Mug"        :category :kitchen    :price 800)
    (:name "ANSI Common Lisp"  :category :book       :price 5000)
    (:name "Notebook"          :category :stationery :price 200)))

;; 述語関数（真偽を返す関数）。名前の末尾の -p は predicate の慣習。
;; getf で plist から :category の値を取り出し、:book かどうか比較する。
(defun book-p (item)
  (eq (getf item :category) :book))

;; 税込価格（税率 10%）。小数を避けるため 11/10 倍し、floor で切り捨てて整数にする。
(defun price-with-tax (item)
  (floor (* (getf item :price) 11) 10))

;; 本だけを残す。remove-if-not は条件を満たす要素だけを残すフィルタ。
;; #' は関数オブジェクトを取り出す記法（関数を引数として渡せる）。
(defun select-books (items)
  (remove-if-not #'book-p items))

;; 各商品を税込価格に変換する。mapcar は各要素に関数を適用して新しいリストを作る (map)。
(defun with-tax (items)
  (mapcar #'price-with-tax items))

;; 価格リストの合計。reduce は要素を #'+ で順に畳み込む (fold)。
(defun total (prices)
  (reduce #'+ prices))

;; Show each step.
;; 各ステップの中間結果を表示する。
;; let* は前の束縛を後の束縛で参照できる（prices が books を使っている）。
(let* ((books  (select-books *items*))
       (prices (with-tax books)))
  ;; ~{...~} はリストの繰り返し、~^ は最後の要素では区切りの ", " を出さない指定。
  (format t "1. books:      ~{~a~^, ~}~%" (mapcar (lambda (item) (getf item :name)) books))
  (format t "2. with tax:   ~a~%" prices)
  (format t "3. total:      ~a~%" (total prices)))

;; The same pipeline as a single expression.
;; 同じ処理を 1 つの式にまとめたもの。内側から外側へ
;; 「絞り込み → 税込計算 → 合計」の順に評価される。
(format t "total: ~a~%"
        (reduce #'+
                (mapcar #'price-with-tax
                        (remove-if-not #'book-p *items*))))
