# xp-harness 既存 skill の description を公式推奨に短縮

## 背景 / Why

xp-harness 既存 skill の description は 500-900 字台で、公式推奨レンジ (200-300 字) から外れている。「9 割の skill 発火失敗は description の品質」と公式が明示する重要 field なので、skill 数が増えるほど効いてくる負債 (interface 純化)。

## 状況

ふりかえり skill の basic-design 議論で claude-code-guide が調査した結果、Claude Code 公式 (<https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices>) の description ベストプラクティスは:

- third person のみ
- What + When の 2 層構成
- Key use case を最初に置く (skill 数が増えると character budget で末尾が切られるため)
- 最大 1,024 字、実質 200-300 字推奨 (短いほど発火精度高い)
- 具体ツール / API 名を避ける (framework-agnostic)

一方、xp-harness 既存 skill の description は 500-900 字台で公式推奨レンジから外れている (例: `define-requirements`, `slice-tdd`, `git-workflow`)。「9 割の skill 発火失敗は description の品質」と公式が明示する重要 field なので、skill 数が増えるほど効いてくる負債。CLAUDE.md の「Description の書き方 (公式推奨)」section と整合する形で短縮。

## 再開時の起点

1. 全 skill (`.apm/skills/*/SKILL.md`) の description を grep で列挙、各字数を測定
2. 公式推奨レンジ (200-300 字) から外れる skill を優先順位付け
3. 1 skill ずつ description を書き直す: What + When の 2 層構成 / Key use case を最初 / 具体名除去 / third person
4. 短くした description で発火サインが落ちないか実セッションで観察
5. 必要に応じて `when_to_use` frontmatter field (Claude Code 固有) を併用
