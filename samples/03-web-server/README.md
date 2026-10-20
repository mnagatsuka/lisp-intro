# 簡易Webサーバ

Hunchentootの `define-easy-handler` によるサーバ（ポート4242）。HunchentootはDockerイメージのビルド時に取得済み。

## 起動

リポジトリのルートで実行する。`Ctrl+C` で停止する。

```sh
make server
```

## 個別に起動

```sh
docker compose -f docker/compose.yaml up --build server
```

## 確認

別のターミナル、またはブラウザから確認する。

```sh
curl http://localhost:4242/hello              # Hello, Lisp!
curl "http://localhost:4242/hello?name=Alice" # Hello, Alice!
```
