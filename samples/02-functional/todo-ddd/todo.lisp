;;; ドメインモデル（すべて読み取り専用）

;; タイトルを表す値オブジェクト。
;; (:constructor %make-title (value)) でコンストラクタ名と引数を指定。
;; 先頭の % は「内部用：直接呼ばない」という慣習で、検証済みの値だけを作らせる意図。
;; :read-only t でスロットを変更不可（イミュータブル）にしている。
(defstruct (title (:constructor %make-title (value)))
  (value "" :type string :read-only t))

;; 未完了の ToDo。「未完了」と「完了」を別の型にして、状態を型で区別する。
(defstruct (open-todo (:constructor make-open-todo (id title)))
  (id 0 :type integer :read-only t)
  (title nil :type title :read-only t))

;; 完了済みの ToDo。open-todo と同じ構造だが別の型。
(defstruct (done-todo (:constructor make-done-todo (id title)))
  (id 0 :type integer :read-only t)
  (title nil :type title :read-only t))

;;; ワークフロー

;; ftype 宣言：入力と出力の型を明示する（文字列 → title）。
(declaim (ftype (function (string) title) validate-title))
;; 生の文字列を検証して title に変換する。1〜50 文字のみ許可。
(defun validate-title (raw)
  ;; (<= 1 x 50) は 1 <= x <= 50 を表す。Lisp の比較演算子は複数引数を取れる。
  (if (<= 1 (length raw) 50)
      (%make-title raw)
      ;; 不正な場合はエラーを発生させる。~S は文字列を引用符付きで表示する。
      (error "Title must be 1-50 characters: ~S" raw)))

;; ID とタイトル文字列から未完了の ToDo を作る。
(declaim (ftype (function (integer string) open-todo) create-todo))
(defun create-todo (id raw-title)
  (make-open-todo id (validate-title raw-title)))

;; 未完了 → 完了への状態遷移。新しい done-todo を作って返す（元の値は変更しない）。
(declaim (ftype (function (open-todo) done-todo) complete-todo))
(defun complete-todo (todo)
  (make-done-todo (open-todo-id todo) (open-todo-title todo)))

;;; 表示

;; 未完了は [ ]、完了は [x] で表示する。~D は整数、~A は人間向けの文字列表示。
(defun show-open (todo)
  (format t "  [ ] ~D ~A~%" (open-todo-id todo) (title-value (open-todo-title todo))))

(defun show-done (todo)
  (format t "  [x] ~D ~A~%" (done-todo-id todo) (title-value (done-todo-title todo))))

;; 作成を試み、検証エラーならメッセージを表示して続行する。
;; handler-case は他言語の try/catch に相当（error 条件を捕捉して e に束縛）。
(defun try-create (raw)
  (handler-case (create-todo 99 raw)
    (error (e) (format t "  rejected: ~A~%" e))))

;;; デモ

(let* ((todos (list (create-todo 1 "Buy milk")
                    (create-todo 2 "Write slides")))
       ;; 2 番目の ToDo (id=2) を完了にする。
       (finished (list (complete-todo (second todos))))
       ;; 完了にした id=2 を未完了の一覧から除く。
       (pending  (remove-if (lambda (todo) (= (open-todo-id todo) 2)) todos)))
  (format t "Open:~%")
  ;; mapc は mapcar と似ているが、結果リストを作らず副作用（表示）のためだけに使う。
  (mapc #'show-open pending)
  (format t "Done:~%")
  (mapc #'show-done finished))

;; 不正なタイトルの例：空文字列と、51 文字（上限超過）の文字列。
(format t "Invalid titles:~%")
(try-create "")
(try-create (make-string 51 :initial-element #\a))
