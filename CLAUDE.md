# xp-harness — このリポジトリで作業するときの working rules

このファイルは **xp-harness 本体を改修するとき** に守るべき暫定ルール。consumer に配布される skill / instruction ではない。ここに書く内容は「まだ固まっていないが、当面は守りたい」レベルのものを置く。固まったら philosophy skill / 新規 skill 等に昇格する。

---

## skill 設計の境界原則 (暫定、固まったら philosophy / skill-design-rules 等に昇格予定)

xp-harness の skill (`.apm/skills/<name>/SKILL.md`) を作る・改修するときの 3 つの境界原則。

### 原則 1: skill の frontmatter `description` は interface — 具体の話を入れない

- description は呼び出し側 (main session) に対する interface。発火条件と責務を抽象レベルで宣言する場所。
- **NG 例**: 具体 framework 名 (`Playwright`, `Cypress`)、具体 API 名 (`getByRole`, `test.use`, `page.locator`)、具体ツール名 (`gh`, `gh cli` 等)。
- **OK 例**: 一般概念 (E2E テスト、commit、branch、push、pull、rebase、conflict 等 — エコシステム共通の語彙)。
- 判断軸: 「consumer の環境 / 採用 framework が変わっても description の表現が成立するか」。成立しないなら具体に踏み込みすぎ。

### 原則 2: skill 本文は展開後 (consumer の `.claude/skills/` 等に deploy された状態) でも自然に読めること

- skill が APM 経由で consumer に配布されると、`.apm/` / `apm compile` / consumer といった APM 機構の語彙はもはや関係なくなる。
- **NG 例**: `.apm/instructions/<x>.md`, `apm compile`, "consumer の自前 instruction", "last-installed-wins 機構" のような APM 機構固有の言及を skill 本文に直書きすること。
- **正しい場所**: APM 機構の話は README / apm.yml / APM 側 instruction (`.apm/instructions/`) に書く。skill 本文は APM 非依存の汎用表現で書く。
- override の話を skill 本文に残したいなら「project 固有のルールで override 可能 (override 方法はインストール先 agent の仕様に従う)」程度の抽象表現にとどめる。

### 原則 3: description は発火条件、本文は発火後の振る舞いを書く

- skill の **発火** は Claude Code の skill 機構によって決まる: frontmatter `description` (および skill 名) を main session が読み、文脈にマッチしたら skill 本文が読み込まれる。発火を決めるのは description であって、本文ではない。
- 本文は発火後の振る舞いガイド: skill が呼ばれた後の対話進行・規律・成果物の書式などを書く場所。
- **NG 例**: 「main session がいつ skill を呼ぶか」「どの観測サインで呼ぶか」のような発火条件を本文側に書く。逆に「発火後の対話手順」「成果物の書式」を description 側に書く。
- 判断軸: 「これは skill が呼ばれる前に効く話か (= description)、呼ばれた後に効く話か (= 本文)」を区別する。混ぜると、skill が発火しない (= 発火条件が本文にあると Claude Code は読まない) / 振る舞いが安定しない (= 振る舞いが description にあると skill 利用側に伝わらない)。

### 適用タイミング

skill の新規作成 / 改修時は、description と本文の両方を上記 3 原則でチェックする。違反を見つけたら指摘 or 修正候補として提示する。skill-creator 系の作業に入る前に必ず思い出すこと。

---

## Description の書き方 (公式推奨)

skill の frontmatter `description` は「9 割の skill 発火失敗は description の品質に起因」(Claude Code 公式) と言われる重要 field。以下を守る:

- **third person のみ** (「I can」「You can」禁止)
- **What (何をするか) + When (いつ使うか) の 2 層構成**
- **Key use case (What) を最初に置く** — skill 数が増えると character budget で末尾が切られるため
- **最大 1,024 字、実質 200-300 字推奨** (短いほど発火精度高い)
- **具体ツール / API 名を避ける** (原則 1 と整合): framework-agnostic な表現で書く
- description が短く済まない場合、`when_to_use` frontmatter field を使う選択肢もある (Claude Code 固有)

Good:

    description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data.

Bad:

    description: Use openpyxl to process spreadsheets

参考: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

---

## Main instruction の取り込み (self-host / dogfooding)

xp-harness 本体の main instruction (consumer に配信される運用ルール) を改修者環境でも有効にするため、起動時に取り込む。改修者は `.apm/instructions/main.instructions.md` を直接編集すれば、Claude Code を再起動するだけで反映される (build step なし)。

`.apm/skills/` の各 skill と `.apm/agents/` の各 subagent は `scripts/setup-dev.sh` が `.claude/skills/<x>` / `.claude/agents/<x>.md` への symlink を作って認識させる (philosophy skill は元から `.claude/skills/philosophy/` で git tracked、対象外)。

@.apm/instructions/main.instructions.md
