# クイックソート

Lisp、Java、Python、Cの4言語で実装している。比較するのはコードの読みやすさで、実行は動作確認のみ。

## 実行

リポジトリのルートで実行する（初回は `task build`）。

```sh
task quicksort
```

## 個別に実行

```sh
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/quicksort/quicksort.lisp
docker compose -f docker/compose.yaml run --rm java java 01-algorithms/quicksort/Quicksort.java
docker compose -f docker/compose.yaml run --rm python python 01-algorithms/quicksort/quicksort.py
docker compose -f docker/compose.yaml run --rm c sh -c "gcc -O2 -o /tmp/qs 01-algorithms/quicksort/quicksort.c && /tmp/qs"
```
