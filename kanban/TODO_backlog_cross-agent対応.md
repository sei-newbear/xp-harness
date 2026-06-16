# cross-agent 対応 (Cursor 等への移植)

## 背景 / Why

現状 xp-harness は Claude Code 専用で、skill / subagent 機構を前提に書かれている。APM は cross-agent (Cursor / Copilot / Codex / Gemini 等) を視野に入れた package manager なので、xp-harness を他 agent でも動かせれば配信範囲が広がる。

## 状況

現状 xp-harness は **Claude Code 専用**。skill / subagent 機構を前提に書かれている。

APM は cross-agent (Cursor / Copilot / Codex / Gemini 等) を視野に入れた package manager なので、xp-harness を他 agent でも動かせれば配信範囲が広がる。

## 取り組む内容

- skill → Cursor rules への mapping
- subagent → Cursor agents への変換
- Claude Code 固有機構 (`/slash-command`, `description` ベース skill 発火) を他 agent の機構に翻訳
- `apm.yml` の `targets:` を `[claude, cursor, copilot, ...]` に拡張
- **`.apm/instructions/main.instructions.md` 内の「Claude」ハードコード (L6, L8, L17, L66, L92) を汎用語 (例: 「エージェント」「main session」等) に置き換え、他 agent でも読める文章にする** — レビューでの気づき (2026-05-11) として記録
- **`AskUserQuestion` ツール参照 (Claude Code 固有) の汎用化** — `.apm/instructions/main.instructions.md`, `.apm/skills/basic-design/SKILL.md`, `.apm/skills/define-requirements/SKILL.md`, `.apm/skills/story-slicing/SKILL.md`, `.apm/skills/propose-options/SKILL.md`, `.apm/skills/git-workflow/SKILL.md` の 6 ファイルで使われている。他 agent では同名 tool が無いので、抽象表現 (「ユーザーへの質問機構」「対話的選択肢提示」等) に置き換えるか、各 agent の同等機構へのマッピング層を設ける — レビューでの気づき (2026-05-11)
- **`TaskCreate` ツール参照 (Claude Code 固有) の汎用化** — `.apm/instructions/main.instructions.md`, `.apm/skills/slice-tdd/SKILL.md` の 2 ファイルで使われている。同じく他 agent では同名 tool が無いので、抽象表現 (「タスク管理機構」「進捗トラッキング」等) に置き換えるか、各 agent の同等機構へのマッピング層を設ける — レビューでの気づき (2026-05-11)

## 再開時の起点

1. 痛みが見えてきたか確認 (依頼者が Cursor 等を使い始めたタイミング)
2. 各 target agent の skill / agent 機構を調査
3. cross-agent 対応の方式を propose-options で議論
4. main.instructions.md の Claude 固有語の汎用化 (上記)
5. `AskUserQuestion` の汎用化 (上記 6 ファイル一括)
6. `TaskCreate` の汎用化 (上記 2 ファイル一括)
7. 他にも Claude Code 固有ツール参照が無いか網羅的に grep (`Read`, `Write`, `Edit`, `Bash`, `Glob`, `Grep`, `Task`, `WebFetch`, `WebSearch` 等は一般概念に近いが、書きぶり次第で固有性が出る可能性)
