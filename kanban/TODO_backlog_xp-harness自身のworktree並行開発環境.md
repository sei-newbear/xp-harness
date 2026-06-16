# xp-harness 自身を worktree で並行開発できる環境整備 (改修者 dogfooding)

## 背景 / Why

「git-workflow worktree 化」案件の主成果は利用者向け (consumer に配る git-workflow skill を worktree 化)。本 TODO はその派生で、**xp-harness 自身を worktree で並行開発できるようにする改修者側 (dogfooding) の環境整備** (自己適用)。

## 状況

「git-workflow worktree 化」案件 (`docs/working/git-workflow-worktree/`) の主成果は **利用者向け** (consumer に配る git-workflow skill を worktree 化し、任意プロジェクトで Claude = worktree 側 / ユーザー = メイン側の並行作業を成立させる)。本 TODO はその派生で、**xp-harness 自身を worktree で並行開発できるようにする改修者側 (dogfooding) の環境整備**。

spike (`docs/working/git-workflow-worktree/worktree-scope-spike-メモ.md` の section 5) で判明した固有事情:

- xp-harness の worktree を作ると、`.claude/skills/` には改修者向けの実体ディレクトリ (philosophy / release / skill-design-style 等) だけが来て、**consumer 向け skill / agent の symlink (git-workflow 等) は来ない** (`.gitignore` 非追跡のため)
- worktree 内で `scripts/setup-dev.sh` を再実行すると symlink が復旧する (相対 symlink が worktree 内で解決することは実測済)
- → xp-harness 自身を worktree で動かすなら「worktree 作成後に setup-dev.sh 再実行で symlink 復旧」のステップが要る

過去の self-host 案件 (2026-05-17 完了削除「本格対応は痛みが見えてから新規 TODO で起こす」) の系譜にある dogfooding 案件。

## 再開時の起点

1. xp-harness を worktree で並行開発する運用フローを定義 (worktree 作成 → setup-dev.sh 再実行 → 並行作業)
2. setup-dev.sh 再実行を worktree セットアップに自動で織り込めるか検討 (手動ステップを減らす)
3. 利用者向け git-workflow worktree 化 (本丸) の設計が固まってから、その knowhow を改修者側にも適用するか判断
