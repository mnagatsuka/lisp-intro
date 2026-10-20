# 簡易Webサーバ

## 目的

- Hunchentootの `define-easy-handler` を使い、数行で動くWebサーバを見せる。
- ハンドラが単なる関数であることを示し、テーマ2（関数型）とつなげる。

## ファイル

`samples/03-web-server/server.lisp` に置く。他言語版は作らない。

## 仕様

- ポートは4242にする。
- ルートは2つにする。
  - `/hello`：「Hello, Lisp!」を返す。
  - `/hello?name=Alice`：クエリの `name` を使って「Hello, Alice!」を返す。
- ルートの定義はどちらも `define-easy-handler` で書く。
- サーバの起動は `hunchentoot:start`（アクセプタの生成）で行い、起動後もプロセスが終了しないようにする。
- ブラウザまたは `curl` で動作を確認できるようにする。

## Lisp版の方針

- 型宣言はしない。
- ハンドラは「文字列を返す関数」として書く。
- 全体で10行程度に収める。
- 補足として、速度重視ならWooもあることを口頭で一言触れる。サンプルコードは作らない。

## 実行環境

- HunchentootはQuicklispで入れる。DockerのLispイメージにQuicklispを組み込み、Hunchentootはビルド時に取得しておく（実行時にネットワークを使わない）。
- このサンプルはサーバが動き続けるので、他のサンプルと違い `up` で起動する。
  - `compose.yaml` にポート4242の公開を持つ `server` サービスを追加する（Lispのイメージを共有する）。
- `make server` で起動し、`Ctrl+C` で止める。

## 確認

- `http://localhost:4242/hello` で「Hello, Lisp!」が表示される。
- `http://localhost:4242/hello?name=Alice` で「Hello, Alice!」が表示される。
