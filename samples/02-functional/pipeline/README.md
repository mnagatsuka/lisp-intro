# データ処理パイプライン

`remove-if-not` / `mapcar` / `reduce` によるパイプライン。

## 実行

リポジトリのルートで実行する（初回は `make build`）。

```sh
make pipeline
```

## 個別に実行

```sh
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 02-functional/pipeline/pipeline.lisp
```
