# ToDoアプリ（DDD）

状態ごとの型、境界のバリデーション、ワークフロー関数の型、イミュータブルな設計のデモ。

## 実行

リポジトリのルートで実行する（初回は `make build`）。

```sh
make todo
```

## 個別に実行

```sh
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 02-functional/todo-ddd/todo.lisp
```
