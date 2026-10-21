## 全体方針

**目的**：Lispのシンプルさ、エレガントさ、実行速度を気軽に紹介する
**使用言語**：Common Lisp（処理系はSBCL、コンパイル前提）

### テーマ1：有名なアルゴリズム

- **クイックソート**：単純な再帰で書き、定義がほぼそのままコードになるシンプルさを見せる。Java、Python、Cと比較する。
- **フィボナッチ**：`(time (fib 35))` で実行速度を見せる。Lispは型宣言なしと型宣言ありの2パターンを用意し、Java、Python、Cと比較する。
- **比較の範囲**：速度の比較はフィボナッチだけにし、クイックソートはシンプルさの比較に絞る。

### テーマ2：関数型プログラミング

- **データ処理**：`remove-if-not`、`mapcar`、`reduce` によるパイプライン。
- **DDDでの活用**：ToDoアプリを例にする（詳細は今後詰める）。
  - 状態ごとに型を分ける（未完了、完了済み）
  - 外部からの入力は境界でバリデーションする（タイトルの文字数など）
  - ワークフロー関数の入出力に型を付ける
  - イミュータブルにする
  - アプリを実際に動かしてデモする。ただし、コンパイル時の警告の実演はしない
- **補足**：より厳密な静的型付けの選択肢としてCoaltonに軽く触れる（まだ1.0に達していない点も添える）。あわせて、Coaltonの `Result` 型でモナド的な書き方もできることに触れる。

### テーマ3：簡易Webサーバ

- **Hunchentoot**：`define-easy-handler` を使い、数行で動くサーバを見せる。
- **一言補足**：速度重視ならWooもあり、アプリケーションが単なる関数である点はテーマ2とつながる。

### テーマ4：マクロ

- **自作の構文**：`my-unless` のような簡単な例で、「Lispでは構文自体を自分で作れる」ことを示す。仕組みの細部には踏み込まない。
- **締めくくり**：「これまでに使った `time` や `define-easy-handler` も実はマクロです」と振り返り、4テーマ全体をつなげる。

### 型付けの方針

- 静的型付けはテーマ2のDDDの部分と、テーマ1のフィボナッチ（型宣言ありのパターン）だけに使う。
- それ以外の箇所では型付けしない。

### 他言語との比較の方針

- 比較はテーマ1だけで行う（Java、Python、C）。
- テーマ2〜4では他言語との比較はしない。

### フォルダ構成

`samples/` 以下にテーマごとのフォルダを作る。他言語のファイルはテーマ1のみに置く。CoaltonとWooはサンプルコードを作らず、スライドでの言及にとどめる。

```
samples/
├── 01-algorithms/
│   ├── quicksort/
│   │   ├── quicksort.lisp
│   │   ├── Quicksort.java
│   │   ├── quicksort.py
│   │   └── quicksort.c
│   └── fibonacci/
│       ├── fib.lisp            # 型宣言なし
│       ├── fib-typed.lisp      # 型宣言あり
│       ├── Fib.java
│       ├── fib.py
│       └── fib.c
│
├── 02-functional/
│   ├── pipeline/
│   │   └── pipeline.lisp       # remove-if-not / mapcar / reduce
│   └── todo-ddd/
│       └── todo.lisp           # 状態ごとの型、境界のバリデーション、ワークフロー関数の型、イミュータブル
│
├── 03-web-server/
│   └── server.lisp             # Hunchentoot の define-easy-handler
│
└── 04-macros/
    └── my-unless.lisp          # 自作の構文
```

### 実行環境

言語ごとにDockerコンテナを用意し、ツールチェーンのバージョンを固定する。ホストにSBCL、JDK、gccなどを入れなくても動かせるようにする。

```
Taskfile.yaml          # 実行コマンドのエントリポイント（task quicksort など）
docker/
├── compose.yaml        # 言語ごとに1サービス。samples/ を読み取り専用でマウントする
├── lisp/Dockerfile     # SBCL + rlwrap + Quicklisp（依存はHunchentootのみ）
├── java/Dockerfile
├── python/Dockerfile
└── c/Dockerfile
```

- 実行は `docker compose -f docker/compose.yaml run --rm <言語> ...` で行う。`Taskfile.yaml` にまとめ、`task fib` で4言語を実行して結果を並べて表示する。
- REPLは `task repl` で起動する。SBCL単体では矢印キーが使えないため、`rlwrap` 経由で起動する（Lispのイメージに入れてある）。
- Webサーバのサービスにはポートを割り当てる（例：4242）。
- クイックソートは動作確認のために1回実行するだけでよい。比較するのはコードの読みやすさである。

#### フィボナッチの速度比較を公平にするための方針

- すべて同じDocker VM上で動かし、オーバーヘッドを揃える。
- イメージはすべてネイティブのarm64を使う（amd64のエミュレーションは使わない）。
- 計測は各プログラムの内部で行い、`docker run` 全体は計測しない（コンテナやJVMの起動時間を含めない）。
- コンパイルは `gcc -O2`、`javac`、SBCLの `compile-file`（または `--script`）を使い、バージョンはDockerfileで固定する。
- ライブデモではSLIMEなどのエディタ連携は使わず、コードを見せてターミナルから実行する（REPLは `docker compose run` で使える）。

### 今後詰める事項

- ToDoアプリのサンプルの詳細
- 各サンプルコードの最終版（Lisp版と、テーマ1の比較用のJava、Python、C版）