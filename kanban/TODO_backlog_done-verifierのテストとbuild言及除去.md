# done-verifier のテスト/build/source dir 言及の完全除去

## 背景 / Why

done-verifier subagent は現在 `npm test` / `pytest` / `cargo test` 等を例として併記する形で抽象化している。理想は project 側で実行コマンドを別途設定する仕組みにして、subagent file からは完全除去すること (interface 純化)。

## 状況

done-verifier subagent は現在 `npm test` / `pytest` / `cargo test` 等を例として併記する形で抽象化している。理想は project 側で実行コマンドを別途設定する仕組みにして、subagent file からは完全除去すること。

## 再開時の起点

1. APM の `scripts:` セクションで `test`, `build`, `typecheck` を定義する規約を harness 側で推奨
2. done-verifier は `apm run test` `apm run build` のような汎用 invocation を使うように書き換え
3. project (consumer) は自前 apm.yml に各コマンドを登録する運用
