# フィボナッチ

`fib(35)` の実行時間を比較する。Lispは型宣言なし（`fib.lisp`）、型宣言あり（`fib-typed.lisp`）、ループ版（`fib-loop.lisp`）、末尾再帰版（`fib-tail.lisp`）の4パターン。計測は各プログラム内部で行う。

## 実行

リポジトリのルートで実行する（初回は `task build`）。

```sh
task fib
```

## 個別に実行

```sh
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/fibonacci/fib.lisp
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/fibonacci/fib-typed.lisp
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/fibonacci/fib-loop.lisp
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 01-algorithms/fibonacci/fib-tail.lisp
docker compose -f docker/compose.yaml run --rm java java 01-algorithms/fibonacci/Fib.java
docker compose -f docker/compose.yaml run --rm python python 01-algorithms/fibonacci/fib.py
docker compose -f docker/compose.yaml run --rm c sh -c "gcc -O2 -o /tmp/fib 01-algorithms/fibonacci/fib.c && /tmp/fib"
```

## 結果の読み方

実行結果の一例（環境により変わる）。

| 言語 | 時間 |
|------|------|
| C (`-O2`) | 0.008 s |
| Java | 0.013 s |
| Lisp（型宣言あり） | 0.043 s |
| Lisp（型宣言なし） | 0.130 s |
| Python | 0.438 s |

- **コンパイル時間は含まれない**: `sbcl --script` はトップレベルの式を1つずつ機械語にコンパイルして評価する。`defun fib` は `(time (fib 35))` より前にコンパイル済みで、`time` は `fib` の呼び出しだけを計測する。`compile-file` で事前コンパイルしても速度は変わらない。
- **型宣言の効果**: 型宣言なしだと `<` `-` `+` が汎用の整数演算になる。型宣言ありでは約3倍速くなる。
- **差の主因は再帰呼び出しのインライン展開**: gcc `-O2` と Java の JIT は、再帰呼び出しをインライン展開して実際の呼び出し回数（約3000万回）を減らす。SBCL は書いた通りに全て呼び出す。インライン展開を無効にすると、C は約0.03 s、Java は約0.02 s になり、SBCL に近づく。
- **アルゴリズムを変えれば別**: ループで書くと（O(n)）、計算が35回の繰り返しだけで済む。処理が短すぎて `time` の表示は `0.000` 秒になる（計算していないわけではなく、結果は同じ 9227465）。末尾再帰版（`fib-tail.lisp`）も、SBCL が末尾呼び出しをジャンプに変換するため、ループ版とほぼ同じ速度になる。ただし、他言語との比較は同じ二重再帰で行う。ループ版と末尾再帰版はLispだけの参考用で、比較の対象ではない。
