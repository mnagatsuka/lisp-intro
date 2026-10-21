# マクロ（my-unless）

自作の構文 `my-unless` の動作確認と、`macroexpand-1` による展開結果の表示。素のSBCLだけで動く。

## 実行

リポジトリのルートで実行する（初回は `task build`）。

```sh
task macro
```

## 個別に実行

```sh
docker compose -f docker/compose.yaml run --rm lisp sbcl --script 04-macros/my-unless.lisp
```
