# kanban — xp-harness 改修バックログ

改修 TODO を 1 項目 1 カードで管理する。ファイル名は `ステータス_優先度_タイトル.md`（ステータス: `TODO` / `DONE`、優先度: `tier1` / `backlog`）。

状況確認は読み取り専用スクリプト `.claude/skills/kanban/board.sh`:

- 引数なし … tier1 の TODO 一覧（次なにやるか）
- `todo` … TODO 全体（tier1 → backlog）
- `done` … DONE 一覧

カードの規約と追加・完了・優先度変更の手順は `kanban` skill（`.claude/skills/kanban/SKILL.md`）にある。
