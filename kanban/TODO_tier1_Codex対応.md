# Codex 対応

## 背景 / Why

現状 xp-harness は **Claude Code 専用**で、skill / subagent 機構を前提に書かれている。依頼者が本業で Codex を実際に使っており、そこでも xp-harness の XP 規律を効かせたい。APM は cross-agent (Cursor / Copilot / Codex / Gemini 等) を視野に入れた package manager なので、Codex でも動かせれば配信範囲が広がる。

`cross-agent 対応` を **エージェント単位で分割** したうちの 1 枚 (もう 1 枚は `Cursor 対応`)。このカードは「Codex で xp-harness を動かせる状態にする」で **自己完結** させる (= 単独で拾って完結できる)。

## 状況

**痛みが顕在化 (2026-07-17)**: 依頼者が本業で Codex を実利用。philosophy 4 象限の「痛みが明確化していない」保留を解く根拠が揃い、tier1。

Codex は **CLI / クラウド寄り** の機構で、Claude Code の `description` ベース skill 発火 / `/slash-command` / subagent とは仕組みが異なる。まず Codex 側の skill / agent / instruction 相当の機構を調査する必要がある。

## 取り組む内容

### Codex 固有の対応

- Codex 側の instruction / rules / agent 相当機構の調査
- skill → Codex の対応機構への mapping (発火のさせ方を含む)
- subagent (reviewer 系) → Codex の対応機構への変換
- `apm.yml` の `targets:` に `codex` を追加
- Claude Code 固有機構 (`/slash-command`, `description` ベース skill 発火) の Codex 機構への翻訳

### 共通土台 (エージェント非依存の汎用化 — `Cursor 対応` カードにも同記載)

先に拾った側が済ませれば、後のカードは差分だけでよい (重複は自然に解消):

- `.apm/instructions/main.instructions.md` の「Claude」ハードコード (5 箇所) を汎用語 (「エージェント」「main session」等) に置き換え、他 agent でも読める文章にする
- `AskUserQuestion` ツール参照 (Claude Code 固有) の汎用化 — `.apm/instructions/main.instructions.md` / `.apm/skills/basic-design/SKILL.md` / `.apm/skills/define-requirements/SKILL.md` / `.apm/skills/story-slicing/SKILL.md` / `.apm/skills/propose-options/SKILL.md` / `.apm/skills/git-workflow/SKILL.md` の 6 ファイル。抽象表現 (「ユーザーへの質問機構」等) か、各 agent の同等機構へのマッピング層
- `TaskCreate` ツール参照 (Claude Code 固有) の汎用化 — `.apm/instructions/main.instructions.md` / `.apm/skills/slice-tdd/SKILL.md` の 2 ファイル。同じく抽象表現かマッピング層
- 他の Claude Code 固有ツール参照が無いか網羅 grep (`Read` / `Write` / `Edit` / `Bash` / `Glob` / `Grep` / `Task` / `WebFetch` / `WebSearch` 等は一般概念寄りだが書きぶり次第で固有性が出る)

## 再開時の起点

1. 痛みは顕在化済み (本業で Codex 利用)。要件定義フェーズから始める (define-requirements で Why / Done / スコープを固める)
2. Codex の instruction / rules / agent 相当機構を調査
3. 対応方式を propose-options で議論 (共通土台の汎用化をこのカードで先にやるか含む)
4. `Cursor 対応` カードと下地が重複するので、先に着手する場合は共通土台の汎用化もこのカードで通す
