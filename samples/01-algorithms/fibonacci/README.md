# フィボナッチ

`fib(35)` の実行時間を比較する。Lispは型宣言なし（`fib.lisp`）と型宣言あり（`fib-typed.lisp`）の2パターン。計測は各プログラム内部で行う。

## 実行

リポジトリのルートで実行する（初回は `make build`）。

```sh
make fib
```

## 個別に実行

```sh
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/fibonacci/fib.lisp
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/fibonacci/fib-typed.lisp
docker compose -f docker/compose.yaml run --rm java java 01-algorithms/fibonacci/Fib.java
docker compose -f docker/compose.yaml run --rm python python 01-algorithms/fibonacci/fib.py
docker compose -f docker/compose.yaml run --rm c sh -c "gcc -O2 -o /tmp/fib 01-algorithms/fibonacci/fib.c && /tmp/fib"
```
