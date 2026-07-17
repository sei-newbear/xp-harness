# cross-agent コア対応 (Codex / Cursor 最低限 enablement)

完了 (2026-07-18)。**v0.14.0 でリリース**。`cross-agent 対応` を垂直分割した「コア」= Codex / Cursor に xp-harness を install できて skill がロードされる最低限の状態にした。

やったこと:
- 全配布 skill (12) の SKILL.md に `name` (= ディレクトリ名) 付与 — Codex / Cursor は `name` 必須 (無いとロード不可、ディレクトリ名フォールバック無し)。改修者向け skill 8 個にも付与して全 skill で揃えた
- `apm.yml` の targets に `codex` / `cursor` 追加
- README に Codex (install + `apm compile --target codex`) / Cursor (install のみ、compile 不要) のフロー
- `skill-design-style` の name ガイドを cross-agent 前提に更新

PR #18 / `docs/working/Codex対応/要件定義.md` に検証済み事実を記録。

残る follow-up (別カード / 別トラック):
- **Codex の compile 依存の軽減 / 既存 AGENTS.md 保護** → tier1 TODO カード
- **skill 発火・subagent 委譲・hook 起動の実環境検証** → 利用者の実地検証に委ねる (導入初期、Codex / Cursor 両方)
- **「Claude」ハードコード語の汎用化** (AGENTS.md 冒頭「あなたは Claude」等) → 実地検証後に判断。据え置き内で最も実害寄りは `git-workflow` の `EnterWorktree`
