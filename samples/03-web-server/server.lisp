;; Quicklisp（Lisp のライブラリ管理ツール）を読み込む。
(load "/opt/quicklisp/setup.lisp")
;; Web サーバライブラリ hunchentoot をダウンロード＆ロードする。
;; :silent t でロード時のログ出力を抑える。
(ql:quickload :hunchentoot :silent t)

;; ハンドラの定義：/hello にアクセスされたときの処理。
;; (name) は URL のクエリパラメータ ?name=... が自動で変数に束縛される。
;; 返した文字列がそのままレスポンスの本文になる。
(hunchentoot:define-easy-handler (hello :uri "/hello") (name)
  ;; name が未指定 (NIL) の場合は "Lisp" を使う。
  (format nil "Hello, ~A!" (or name "Lisp")))

;; ポート 4242 でサーバを起動する。起動後は別スレッドでリクエストを待ち受ける。
(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))
;; スクリプトがすぐ終了するとサーバも止まるため、ほぼ無限にスリープして待機する。
(sleep most-positive-fixnum)
