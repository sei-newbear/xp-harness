# 初回 install 時の CLAUDE.md 退避カスタムコマンド

## 背景 / Why

`apm compile --target claude` は CLAUDE.md を完全上書きする。consumer が既存 CLAUDE.md を持ったまま素朴に `apm compile` を実行すると、自前の内容が失われる。利用者の事故防止のため、migrate を自動化したい。

## 状況

`apm compile --target claude` は CLAUDE.md を完全上書きする。consumer が既存 CLAUDE.md を持ったまま素朴に `apm compile` を実行すると、自前の内容が失われる。

現状は README で「初回 install 前の migrate 手順」を明示する形 (手動)。

理想は migrate を自動化するカスタムコマンド (`apm run init-migrate` 等) で、consumer の既存 CLAUDE.md を `.apm/instructions/<own>.md` に自動退避する。

## 再開時の起点

1. APM の `scripts:` セクションで `init-migrate` を定義
2. shell script (`scripts/init-migrate.sh`) で:
   - 既存 CLAUDE.md を読む
   - section ごとに `.apm/instructions/<section>.instructions.md` に分割保存
   - 元の CLAUDE.md を `.bak` にリネーム or 削除
3. README に手順を追加 (手動 migrate との両立)
