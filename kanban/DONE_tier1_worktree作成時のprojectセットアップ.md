# worktree 作成時の project セットアップ

完了 (2026-08-06、v0.19.0 でリリース)。

worktree で直接セッションを起動すると skill / subagent が丸ごと見えない事象が起きていた。原因は git 管理外で生成される設定 (このリポジトリでは `scripts/setup-dev.sh` が作る symlink) が新しい worktree に無いこと。

- `git-workflow`: worktree の作成手順を 2 手から 3 手にし、作成と入るの間に project 固有のセットアップを置いた。具体の手順は配らず探索に委ね、空振り時はでっち上げない。実行時はまだ元 repo にいるため、対象ディレクトリの明示も手順に含めた
- `CLAUDE.md`: xp-harness 側の具体 (`scripts/setup-dev.sh` を worktree のパス指定で流す) を追加。section 冒頭を「上書き、または補完」に拡張

元 repo から起動して worktree に入り直す使い方では元 repo 側の設定が見え続けるため、この穴に気づけない (Claude Code で確認: 設定の解決元はセッション起動時のディレクトリで、入り直しても移らない)。

sandbox で PASS を確認済み。`which apm` と各 `package.json` を読んでから何を流すか決めており、探索型として機能している。
