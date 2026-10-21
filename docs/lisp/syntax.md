# サンプルコードで使うLispの文法

このリポジトリの `samples/` に出てくるCommon Lispの文法を、初めて読む人向けにまとめる。出てくる順ではなく、読むのに必要な順に並べている。

## 1. 基本：S式 (Symbolic Expression) と前置記法

Lispのコードは、丸括弧で囲んだリスト（S式）でできている。リストの先頭が関数（または演算子）で、残りが引数になる。

```lisp
(+ 1 2)          ; => 3
(< n 2)          ; nが2より小さいか
(+ (fib 1) 2)    ; 入れ子にできる。内側から評価される
```

- 他の言語の `1 + 2` が、Lispでは `(+ 1 2)` になる。演算子も普通の関数と同じ形で書く。
- 括弧の対応がそのままプログラムの構造（木）になる。
- `;` から行末まではコメント。慣習として、行末は `;`、独立した行は `;;`、節の見出しは `;;;` を使う（`todo.lisp` を参照）。

## 2. 値の種類

| 書き方 | 意味 | 例 |
|---|---|---|
| `42` | 整数 | `35` |
| `"..."` | 文字列 | `"Buy milk"` |
| `nil` | 偽、または空リスト | `(when list ...)` |
| `t` | 真 | `(format t ...)` の `t` は出力先が標準出力という意味 |
| `:book` | キーワード（自分自身を表す名前。下で詳しく説明） | `:category :book` |
| `#\a` | 文字 | `#\a` |
| `'(1 2 3)` | リストのリテラル | `'(3 1 4 1 5 9 2 6)` |

### キーワード `:name`

先頭が `:` の名前をキーワードと呼ぶ。Lispの「シンボル」（名前を表すデータ）の一種で、次の性質を持つ。

- **評価しても自分自身になる。** 普通のシンボルは変数として評価され、値を探しにいく。キーワードは探しにいかず、そのまま `:book` が返る。そのためクォート `'` は不要。
- **事前の定義がいらない。** `:book` と書くだけで使え、`defparameter` などで宣言する必要はない。
- **同じ名前なら同一のもの。** `:book` はどこに書いても同じオブジェクトで、`eq` で比較できる（`book-p` の `(eq (getf item :category) :book)` がこの例）。

```lisp
:book              ; => :BOOK   そのまま返る
(eq :book :book)   ; => T       同じものなので真
(eq :book :kitchen) ; => NIL      別のものなので偽
```

他の言語でいう、次のものに近い。

| 言語 | 近いもの |
|---|---|
| Ruby | シンボル（`:book`） |
| Java | `enum` の定数 |
| Python | 文字列定数（`"book"`）や `Enum` |

このリポジトリでは、主に2つの使い方をしている。

1. **ラベル（列挙値）として使う。** `:category :book` の `:book` は「カテゴリが本である」という印で、文字列より比較が速く、タイプミスも見つけやすい。
2. **名前付き引数のキーとして使う。** `(make-string 51 :initial-element #\a)` や `(make-instance 'hunchentoot:easy-acceptor :port 4242)` では、`:initial-element` や `:port` が「次の値は何の引数か」を示している。`defstruct` の `:type` や `:read-only`、プロパティリスト（10章）の `:name`、`:price` も同じ仕組みである。

なお、Lispは大文字小文字を区別せず、内部では大文字に変換する。REPLで `:book` を評価すると `:BOOK` と表示されるのはこのためで、同じものである。

### クォート `'`

`'` を付けると、評価せずにデータとして扱う。

```lisp
(+ 1 2)     ; => 3       評価される
'(+ 1 2)    ; => (+ 1 2) ただのリスト
```

`'(3 1 4 1 5 9 2 6)` は、数のリストというデータを渡している。クォートを付けないと、`3` を関数として呼ぼうとしてエラーになる。

### 変数名の規則

- 単語はハイフンでつなぐ（`price-with-tax`、`remove-if-not`）。
- 述語（真偽を返す関数）は `-p` で終わる（`book-p`）。
- グローバル変数は `*` で挟む（`*items*`）。

## 3. 関数を定義する：`defun`

```lisp
(defun fib (n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))
```

- `(defun 名前 (引数...) 本体...)` の形。
- 最後に評価した式の値が戻り値になる。`return` は書かない。
- 上の例では、`fib` が自分自身を呼ぶ再帰で書かれている。

## 4. 条件分岐

### `if`

```lisp
(if 条件 真のとき 偽のとき)
```

`fib` の `(if (< n 2) n (+ ...))` がこれにあたる。

### `when`

```lisp
(when list
  ...)
```

条件が真のときだけ本体を実行する。偽なら `nil` を返す。`quicksort` では、空リスト（`nil`）のときに何もせず `nil` を返すために使っている。

### `cond`

```lisp
(cond (条件1 式...)
      (条件2 式...)
      (t     式...))
```

条件を上から順に評価し、最初に真になった節の式を実行して、その最後の値を返す。他の言語の `if / else if / else` に近い。

- 各節は `(条件 式...)` の形で、全体を丸括弧で囲む。`if` と違い、節ごとに括弧が必要。
- どの条件も真にならなければ `nil` を返す。
- 最後の節の条件を `t`（常に真）にすると、`else` と同じ働きになる。

```lisp
(defun sign (n)
  (cond ((< n 0) :negative)
        ((= n 0) :zero)
        (t       :positive)))

(sign -5)   ; => :NEGATIVE
(sign 0)    ; => :ZERO
(sign 8)    ; => :POSITIVE
```

分岐が3つ以上あるときは、`if` を入れ子にするより `cond` のほうが読みやすい。2分岐なら `if`、真のときだけ実行するなら `when` を使う。

サンプルには `cond` は出てこないが、`quicksort` は次のように書くこともできる。

```lisp
(cond ((null list) nil)
      (t (let ((pivot (first list))
               (rest  (rest list)))
           ...)))
```

## 5. 局所変数：`let` と `let*`

```lisp
(let ((pivot (first list))
      (rest  (rest list)))
  ...)
```

- `(let ((名前 値) ...) 本体...)` の形。
- `let` は、すべての値を先に評価してから束縛する。
- `let*` は、上から順に束縛する。後ろの束縛が前の束縛を使える。

```lisp
(let* ((books  (select-books *items*))
       (prices (with-tax books)))   ; 上の books を使っている
  ...)
```

## 6. 無名関数：`lambda`

```lisp
(lambda (x) (< x pivot))
```

名前のない関数。`remove-if-not` などに、その場で渡す関数を書くときに使う。この例では、外側の `pivot` を参照している（クロージャ）。

## 7. 関数を値として渡す：`#'`

```lisp
(mapcar #'price-with-tax items)
(reduce #'+ prices)
```

`#'名前` は「その名前の関数そのもの」を指す。関数を引数として渡すときに付ける。

## 8. リスト操作の関数

| 関数 | 働き | 例 |
|---|---|---|
| `first` / `rest` | 先頭の要素 / 残り | `(first '(1 2 3))` => `1`、`(rest '(1 2 3))` => `(2 3)` |
| `second` | 2番目の要素 | |
| `list` | リストを作る | `(list pivot)` => `(3)` |
| `append` | リストをつなぐ | `(append '(1) '(2) '(3))` => `(1 2 3)` |
| `length` | 長さ | |

### cons、car、cdr

サンプルでは使っていないが、`first` / `rest` の元になっている基本の関数なので説明する。古いコードや資料ではこちらが使われる。

Lispのリストは、**cons（コンス）セル**をつなげたものである。consセルは2つの値を持つ小さな箱で、

- 1つ目を `car`（カー）
- 2つ目を `cdr`（クダー）

と呼ぶ。

```lisp
(cons 1 2)         ; => (1 . 2)   consセル。1つ目が1、2つ目が2
(car (cons 1 2))   ; => 1
(cdr (cons 1 2))   ; => 2
```

リストは、`cdr` に次のconsセルを入れてつないだもので、最後は `nil` で終わる。

```lisp
(cons 1 (cons 2 (cons 3 nil)))   ; => (1 2 3)
```

```
'(1 2 3) の中身

[1 | •]──→[2 | •]──→[3 | nil]
 car cdr
```

このため、次のように読み替えられる。

| 関数 | 働き | 同じ働きの関数 |
|---|---|---|
| `(car list)` | 先頭の要素 | `first` |
| `(cdr list)` | 先頭を除いた残り | `rest` |
| `(cons x list)` | 先頭に `x` を足した新しいリスト | |

```lisp
(car '(1 2 3))       ; => 1
(cdr '(1 2 3))       ; => (2 3)
(cons 0 '(1 2 3))    ; => (0 1 2 3)
```

補足：

- `car` と `cdr` という名前は、初期のコンピュータのレジスタ名に由来する歴史的なもので、意味は名前からは分からない。新しく書くコードでは、読みやすい `first` / `rest` を使うのがよい。
- `cons` は元のリストを変更せず、新しいセルを1つ作って元のリストの前につなぐ。そのため、元のリストはそのまま残る（`quicksort` が元のリストを壊さないのと同じ考え方）。
- `cadr`（= `car` の `cdr`、つまり2番目）のように、`c` と `r` の間に `a` と `d` を並べた関数もある。`(cadr '(1 2 3))` は `2`。
- `(1 . 2)` のように `cdr` がリストでない形はドット対と呼ぶ。普通のリストでは `cdr` が `nil` か次のconsセルなので、ほとんど出てこない。

## 9. 高階関数（データ処理のパイプライン）

ループの代わりに、関数を受け取る関数を組み合わせる。

| 関数 | 働き |
|---|---|
| `(remove-if-not 述語 リスト)` | 述語が真の要素だけ残す（フィルタ） |
| `(remove-if 述語 リスト)` | 述語が真の要素を取り除く |
| `(mapcar 関数 リスト)` | 全要素に関数を適用した新しいリストを返す（マップ） |
| `(mapc 関数 リスト)` | 全要素に関数を適用する。副作用のためで、元のリストを返す |
| `(reduce 関数 リスト)` | 要素を1つの値にまとめる（畳み込み） |

```lisp
(reduce #'+
        (mapcar #'price-with-tax
                (remove-if-not #'book-p *items*)))
```

内側から外側へ、「本だけ選ぶ → 税込みにする → 合計する」の順に評価される。

## 10. プロパティリスト：`getf`

キーワードと値を交互に並べたリストを、レコードのように使う。

```lisp
'(:name "On Lisp" :category :book :price 3000)

(getf item :price)   ; => 3000
```

`pipeline.lisp` の `*items*` はこの形のリストのリストになっている。

## 11. グローバル変数：`defparameter`

```lisp
(defparameter *items* '(...))
```

グローバル変数を定義する。名前は `*` で挟む。

## 12. 比較

| 関数 | 用途 |
|---|---|
| `=` | 数値の等しさ |
| `eq` | 同一のオブジェクトか（キーワードやシンボルの比較に使う） |
| `<` `>` `<=` `>=` | 大小の比較 |

`(<= 1 (length raw) 50)` のように、比較関数は3つ以上の引数を取れる。「1 ≤ 長さ ≤ 50」という意味になる。

## 13. 出力：`format`

```lisp
(format t "~a~%" (quicksort '(3 1 4 1 5 9 2 6)))
```

`(format 出力先 書式文字列 引数...)` の形。

- 出力先 `t` は標準出力、`nil` は文字列として返す（`server.lisp` の `(format nil "Hello, ~A!" ...)`）。
- 書式指示子は次のとおり。

| 指示子 | 意味 |
|---|---|
| `~a` / `~A` | 人間が読む形で出力 |
| `~S` | 読み戻せる形（文字列に引用符が付く）で出力 |
| `~D` | 整数 |
| `~%` | 改行 |
| `~{...~}` | リストの各要素に対して中身を繰り返す |
| `~^` | 最後の要素では出力を止める（区切りの `, ` に使う） |

```lisp
(format t "~{~a~^, ~}~%" '("a" "b" "c"))   ; => a, b, c
```

そのほか、`(print x)` は改行付きで値を出力し、`(terpri)` は改行だけを出力する。

## 14. 構造体：`defstruct`

```lisp
(defstruct (open-todo (:constructor make-open-todo (id title)))
  (id 0 :type integer :read-only t)
  (title nil :type title :read-only t))
```

- 型の名前と、フィールドの定義を書く。フィールドは `(名前 初期値 オプション...)` の形。
- `:type` はフィールドの型。`:read-only t` にすると、作成後に変更できない（イミュータブル）。
- 自動で次の関数が作られる。
  - アクセサ：`(open-todo-id todo)`（`構造体名-フィールド名`）
  - 型の判定：`open-todo-p`
- `(:constructor 名前 (引数...))` で、コンストラクタの名前と引数を決める。`todo.lisp` では `%make-title` のように `%` を付けて、外から直接呼ばない約束にしている（検証済みの値だけを作るため、`validate-title` を通す）。

## 15. 型宣言：`declaim`

```lisp
(declaim (ftype (function (string) title) validate-title))
```

「`validate-title` は文字列を受け取り、`title` を返す」という宣言。SBCLはこれを使って、コンパイル時に型を検査する。

```lisp
(declaim (optimize (speed 3) (safety 0)))
```

コンパイラへの最適化指示。`fib-typed.lisp` で、速度を最優先にし、実行時の安全検査をやめるために使っている。

```lisp
(declaim (ftype (function ((integer 0 40)) (integer 0 102334155)) fib))
```

型は範囲でも指定できる。`(integer 0 40)` は「0以上40以下の整数」。

## 16. エラー処理

```lisp
(error "Title must be 1-50 characters: ~S" raw)   ; エラーを発生させる

(handler-case (create-todo 99 raw)
  (error (e) (format t "  rejected: ~A~%" e)))     ; エラーを捕まえる
```

- `error` は、`format` と同じ書式でメッセージを作り、エラーを発生させる。
- `handler-case` は、式を評価し、`error` が起きたら対応する節に進む。他の言語の `try / catch` に近い。

## 17. マクロ：`defmacro`

`my-unless.lisp` で扱う。マクロは、コードを受け取ってコードを返す。評価の前に展開される。

```lisp
(defmacro my-unless (condition &body body)
  `(if ,condition
       nil
       (progn ,@body)))
```

| 記号 | 意味 |
|---|---|
| `&body body` | 残りの式をすべて `body`（リスト）として受け取る |
| `` ` ``（バッククォート） | テンプレート。基本は `'` と同じくそのままのデータ |
| `,x` | テンプレートの中で `x` を評価した値を埋め込む |
| `,@x` | `x`（リスト）の中身を展開して埋め込む |
| `progn` | 複数の式を順に評価し、最後の値を返す |

`(my-unless (> 1 2) A B)` は、評価の前に次のように書き換わる。

```lisp
(if (> 1 2) nil (progn A B))
```

`macroexpand-1` を使うと、この展開結果を見られる。関数と違い、マクロは引数を評価せずに受け取るので、条件が真のときは本体が一度も評価されない。

## 18. その他

| 書き方 | 意味 | 出てくる場所 |
|---|---|---|
| `(load "...")` | ファイルを読み込む | `server.lisp` |
| `(ql:quickload :hunchentoot)` | Quicklispでライブラリを読み込む | `server.lisp` |
| `パッケージ名:シンボル` | パッケージを指定してシンボルを使う（`hunchentoot:start`） | `server.lisp` |
| `(make-instance 'クラス :キー 値)` | クラスのインスタンスを作る | `server.lisp` |
| `(time 式)` | 式を評価し、実行時間を表示する | `fib.lisp` |
| `(or a b)` | 最初に真になった値を返す。`(or name "Lisp")` は、`name` が `nil` のときの既定値になる | `server.lisp` |
| `(sleep 秒)` | 指定した秒数だけ待つ | `server.lisp` |

`define-easy-handler`（Hunchentootのマクロ）は、URLと関数を結び付ける。

```lisp
(hunchentoot:define-easy-handler (hello :uri "/hello") (name)
  (format nil "Hello, ~A!" (or name "Lisp")))
```

`/hello?name=...` にアクセスすると、クエリパラメータ `name` が同名の引数として渡される。返した文字列が、そのままレスポンスの本文になる。

## 参考：どのサンプルで何が出てくるか

| サンプル | 主な文法 |
|---|---|
| `fibonacci` | `defun`、`if`、再帰、`format`、`time`、`declaim` |
| `quicksort` | `when`、`let`、`lambda`、`remove-if-not`、`append`、クォート |
| `pipeline` | `defparameter`、`getf`、`mapcar`、`reduce`、`#'`、`let*` |
| `todo-ddd` | `defstruct`、`declaim ftype`、`handler-case`、`error` |
| `web-server` | `load`、`ql:quickload`、パッケージ修飾、`define-easy-handler` |
| `macros` | `defmacro`、バッククォート、`macroexpand-1` |
