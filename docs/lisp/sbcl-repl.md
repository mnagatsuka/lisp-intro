# SBCL（REPL）の基本的な使い方

SBCLはCommon Lispの処理系で、このリポジトリのサンプルはすべてSBCLで動かす。ここでは、対話的にコードを試せるREPLの使い方をまとめる。文法は [syntax.md](syntax.md) を参照。

REPLは Read（読む）→ Eval（評価する）→ Print（表示する）→ Loop（繰り返す）の略で、式を1つ入力するたびに結果が返ってくる。サンプルを読みながら、気になった式をその場で試すのに向いている。

## 1. 起動する

このリポジトリでは、SBCLはDockerコンテナの中にある。ホストにインストールする必要はない。

```sh
task repl
```

`task repl` は `rlwrap sbcl` を起動する（矢印キーが使える。8章を参照）。タスクを使わずに起動する場合は、端末サイズを先に設定する必要がある（理由は8章を参照）。

```sh
docker compose -f docker/compose.yaml run --rm -e COLUMNS=$(tput cols) -e LINES=$(tput lines) lisp \
  sh -c 'stty cols $COLUMNS rows $LINES; exec rlwrap sbcl'
```

起動すると、次のようなプロンプトが出る。

```
This is SBCL 2.2.9.debian, an implementation of ANSI Common Lisp.
...
*
```

`*` が入力待ちの印である。

## 2. 式を評価する

式を入力して Enter を押すと、評価結果が表示される。

```lisp
* (+ 1 2)
3
* (list 1 2 3)
(1 2 3)
* "hello"
"hello"
* :book
:BOOK
```

- 複数の式は、1つずつ評価される。括弧が閉じるまでは、Enter を押しても続きの入力待ちになる。
- 1行に複数の式を書いてもよい。

### 直前の結果：`*`、`**`、`***`

直前の結果は変数 `*` に入る。その前は `**`、さらにその前は `***` である。

```lisp
* (+ 1 2)
3
* (* * 10)
30
```

## 3. 関数や変数を定義する

REPLの中でも、サンプルと同じように定義できる。

```lisp
* (defun square (x) (* x x))
SQUARE
* (square 5)
25
* (defparameter *name* "Lisp")
*NAME*
* (format t "Hello, ~A!~%" *name*)
Hello, Lisp!
NIL
```

- `defun` は定義した関数の名前を返す（大文字で表示されるのは、内部で大文字に変換されるため）。
- `format` の `t` は標準出力に出すという意味で、出力のあとに戻り値の `NIL` も表示される。
- REPLを終了すると、定義は消える。残したいものはファイルに書く。

## 4. ファイルを読み込む

サンプルのファイルを、REPLの中で読み込んで実行できる。

```lisp
* (load "01-algorithms/quicksort/quicksort.lisp")
(1 1 2 3 4 5 6 9)
T
```

- `/samples` がカレントディレクトリなので、`samples/` からの相対パスで指定できる。
- 読み込んだあとは、ファイル内の関数をそのまま呼べる。

```lisp
* (quicksort '(5 2 8 1))
(1 2 5 8)
```

- ファイルを直したら、もう一度 `load` すれば反映される。

REPLを起動せずに、ファイルを直接実行することもできる（サンプルの実行方法）。

```sh
sbcl --script 01-algorithms/quicksort/quicksort.lisp
```

`--script` は、ファイルを実行して終了する。エラーが出ても対話モードには入らず、そのまま終了する。

## 5. エラーが出たとき（デバッガ）

REPLでエラーが起きると、SBCLはデバッガに入る。プロンプトが `0]` のように変わる。

```lisp
* (/ 1 0)

debugger invoked on a DIVISION-BY-ZERO in thread ...
  arithmetic error DIVISION-BY-ZERO signalled
Operation was (/ 1 0).

Type HELP for debugger help, or (SB-EXT:EXIT) to exit from SBCL.

restarts (invokable by number or by possibly-abbreviated name):
  0: [ABORT] Exit debugger, returning to top level.

(SB-KERNEL::INTEGER-/-INTEGER 1 0)
0]
```

- **`0` と入力して Enter**：デバッガを抜けて、元のREPL（`*`）に戻る。まずはこれだけ覚えておけばよい。
- `restarts` の一覧は、エラーからの復帰方法を示している。番号を入力すると、その方法で続行する。
- `backtrace` と入力すると、エラーに至るまでの呼び出しの履歴が見られる。
- `help` でデバッガのコマンド一覧が出る。

## 6. 調べる

REPLには、関数や変数の情報を調べる機能がある。

```lisp
* (describe 'mapcar)
COMMON-LISP:MAPCAR
  [symbol]

MAPCAR names a compiled function:
  Lambda-list: (FUNCTION LIST &REST MORE-LISTS)
  ...
```

| 式 | 働き |
|---|---|
| `(describe 'mapcar)` | シンボルの説明（引数の形、ドキュメントなど）を表示する |
| `(apropos "REMOVE")` | 名前に `REMOVE` を含むシンボルを探す |
| `(documentation 'mapcar 'function)` | 関数のドキュメント文字列を表示する |
| `(macroexpand-1 '(my-unless a b))` | マクロの展開結果を見る（[syntax.md](syntax.md) の17章） |
| `(time (fib 35))` | 実行時間とメモリ使用量を表示する |
| `(trace fib)` / `(untrace fib)` | 関数の呼び出しと戻り値を表示する / 止める |

`describe` や `apropos` に渡すシンボルは、クォート `'` を付ける。

## 7. 終了する

```lisp
* (exit)
```

- `(exit)` または `(sb-ext:exit)` で終了する。
- `Ctrl+D` でも終了できる（デバッガ内では効かないことがある。先に `0` で抜ける）。
- 実行が止まらなくなったときは `Ctrl+C` で中断できる。デバッガに入るので、`0` で戻る。

## 8. 補足

### 矢印キーで移動・履歴の呼び出しをする

素のSBCLには行編集の機能がなく、矢印キーを押すと `^[[A` のような文字が表示される。そこで、コンテナには `rlwrap` を入れてある。`rlwrap` 経由で起動すると、次の操作ができる。

```sh
task repl
```

| キー | 働き |
|---|---|
| 左右の矢印、`Ctrl+A` / `Ctrl+E` | 行内のカーソル移動（行頭 / 行末） |
| 上下の矢印、`Ctrl+P` / `Ctrl+N` | 履歴の呼び出し |
| `Ctrl+R` | 履歴の検索 |
| `Ctrl+U` | カーソルから行頭まで削除 |
| `Ctrl+K` | カーソルから行末まで削除 |
| `Ctrl+A` → `Ctrl+K` | 行全体を削除（行頭へ移動してから、行末まで削除） |
| `Ctrl+W` | カーソルの前の1単語を削除 |
| `Ctrl+Y` | 直前に削除したものを貼り付け |

- 履歴は、そのセッションで入力したものだけが対象である。コンテナは `--rm` で毎回作り直されるため、再起動すると履歴は空になる。
- 削除できるのは、いま入力中の1行だけである。複数行の式の途中で、前の行を消すことはできない。その場合は `Ctrl+C` で中断し、デバッガで `0` を入力して戻り、最初から入力し直す。
- 行編集は1行ごとである。複数行にわたる式は、履歴では行ごとに分かれて呼び出され、行をまたいだカーソル移動はできない。長い式は、ファイルに書いて `load` するほうが扱いやすい。
- `docker compose … run --rm lisp rlwrap sbcl` を直接実行すると、`rlwrap: error: My terminal reports width=0` で失敗することがある。Dockerが作る端末は、最初はサイズが0で、コンテナの起動後にホストの端末サイズが伝わる。`rlwrap` は起動直後にサイズを読むため、この間に失敗する。`task repl` は、`stty` で先に端末サイズを設定してから `rlwrap` を起動するので、この問題が起きない。
- 以前のイメージを使っている場合は、`task build` で作り直す。
- 本格的に開発するなら、SLIMEやSly（Emacs）、Alive（VS Code）などのエディタ連携が一般的である。このリポジトリでは、手軽さを優先して `rlwrap` を使う。

### REPLに貼り付けて試す

ドキュメントのコード例は、REPLにそのまま貼り付けて試せる。行頭の `*` はプロンプトなので、貼り付けるのは式だけにする。

### 全体の流れ

1. `sbcl` でREPLを起動する。
2. `(load "...")` でサンプルを読み込む。
3. 関数を呼んだり、`describe` で調べたりして試す。
4. エラーが出たら `0` でデバッガから戻る。
5. `(exit)` で終了する。
