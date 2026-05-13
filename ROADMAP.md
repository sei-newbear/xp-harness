# xp-harness ROADMAP

xp-harness を進化させるための保留 TODO リスト。各項目は harness 改修者 (依頼者本人 + 関心あるチームメンバー) が手を入れるときの起点として使う。

優先順位は実運用での痛み・採用度・コストで決める。「あった方が良いが、無くても困らない」レベルのものを多く含む。

---

## 優先順位（現在の温度感）

| ID | TODO | 対象 | 意味 | 温度感 |
|---|---|---|---|---|
| 1 | self-host (dogfooding) の実現 | `harness-repo`, `apm-mechanism` | `自己適用` | 開発周り、優先度低 |
| 2 | `.apm/instructions/main.md` の section 分割精査 | `main-instructions` | `構造改修` | 中身を精査しながら判断 |
| 3 | cross-agent 対応 (Cursor 等への移植) | (全体) | `他エージェント対応` | 痛みが見えてから |
| 4 | 初回 install 時の CLAUDE.md 退避カスタムコマンド | `apm-mechanism` | `新規作成`, `機能拡張` | 利用者の事故防止 |
| 5 | git-workflow skill の `gh` 禁止 / PR 作成依頼者責務の汎用性検討 | `git-workflow` | `責務境界` | 個人 / チーム portability では現状で OK |
| 6 | done-verifier のテスト/build/source dir 言及の完全除去 | `done-verifier` | `interface純化` | 開発周り |
| 7 | e2e-reviewer 本文の e2e skill 規約言及 / プロジェクト固有値の完全除去 (旧 7 + 旧 18 統合) | `e2e-reviewer` | `interface純化` | 開発周り |
| 8 | e2e skill を framework 中立化 (Playwright 前提を外す) | `e2e-skill` | `interface純化` | Playwright 以外を使う consumer が増えてから |
| 9 | e2e skill を思想 (e2e-philosophy) と実装 (e2e-playwright) に分離 | `e2e-skill` | `構造改修` | skill 増えてきたら検討 |
| 10 | 公式 skill-creator では足りない高度な機能 + skill-template 同梱 | `skill-creator` | `機能拡張`, `方法論導入` | skill 開発が増えてきたら |
| 11 | philosophy skill (改修者向け) を consumer に誤配布しない仕組み | `philosophy`, `apm-mechanism` | `責務境界` | 誤配布シナリオが実際に起きたら |
| 12 | skill 開発の TDD / eval 方法論導入 | `harness-repo` | `方法論導入` | チーム配布が見えてきたら |
| 13 | デバッグスキル新設 (systematic-debugging 相当) | (新規) | `新規作成` | バグ修正の質に痛みが見えてから |
| 14 | skill 編集時の思想 loading 仕組み | `philosophy`, skill-edit機構 | `機能拡張` | skill が増えるほど drift リスク累積 |
| 15 | AgentTeam 導入検討 | (harness 全体) | `他エージェント対応`, `方法論導入` | 現行 subagent の検証が進んでから |
| 16 | code-reviewer の description に設計書/要件定義パスを渡す前提を明示 | `code-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 17 | code-reviewer のレビュー範囲を diff だけに閉じず周辺コードも refactor 対象に | `code-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 18 | (欠番、TODO 7 に統合) | — | — | — |
| 19 | e2e-reviewer の「テスト独立性」section が重複しているのでまとめる | `e2e-reviewer` | `重複削減`, `構造改修` | レビューでの気づき (優先度未判断) |
| 20 | e2e-reviewer の description に設計書/要件定義パスを渡す前提を明示 | `e2e-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 21 | pre-implementation-reviewer の description に要件定義/基本設計パスを渡す前提を明示 | `pre-impl-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 22 | main.instructions.md のフェーズフロー section の削除またはスリム化 | `main-instructions` | `重複削減` | レビューでの気づき (優先度未判断) |
| 23 | main.instructions.md の各フェーズの振る舞い section の skill 重複解消検討 | `main-instructions` | `重複削減` | レビューでの気づき (優先度未判断) |
| 24 | main.instructions.md 全体の skill 重複洗い出し / 必要なものへの絞り込み (章ごと + 全体) | `main-instructions` | `重複削減` | レビューでの気づき (優先度未判断) |
| 25 | ふりかえり skill の新設 (作業完了後にユーザーへふりかえりを問いかけ、改善点を自発的に促す) | (新規) | `新規作成` | レビューでの気づき (優先度未判断) |
| 26 | basic-design / define-requirements の末尾「/clear で次フェーズへ」案内の要否検討 | `define-requirements`, `basic-design` | `責務境界` | レビューでの気づき (優先度未判断) |
| 27 | E2E と対になる実装 skill の新設 (実装規約 + architecture を担う) | (新規) | `新規作成` | レビューでの気づき (優先度未判断) |
| 28 | define-requirements / basic-design と dialogue-principles の重複整理 | `dialogue-principles`, `define-requirements`, `basic-design` | `重複削減` | レビューでの気づき (優先度未判断) |
| 29 | e2e skill の description から具体名 (Playwright, test.use, getByRole, page.locator) を除去 | `e2e-skill` | `interface純化` | レビューでの気づき (優先度未判断) |
| 30 | git-workflow skill の description から `gh` 不使用ルール言及を除去 (具体ツール名 NG) | `git-workflow` | `interface純化` | レビューでの気づき (優先度未判断) |
| 31 | git-workflow skill 本文から `.apm` / `apm compile` / consumer 等の APM 機構言及を除去 | `git-workflow` | `interface純化` | **優先度高** |
| 32 | slice-tdd skill の名前再検討 | `slice-tdd` | `interface純化` | **優先度高め** |
| 33 | slice-tdd skill 内の Playwright 記述 (L215) を除去 | `slice-tdd` | `interface純化` | レビューでの気づき (優先度未判断) |
| 34 | slice-tdd skill の「依頼者に状況を確認する」箇所を自走モード前提で詰める | `slice-tdd` | `責務境界` | レビューでの気づき (優先度未判断) |
| 35 | slice-tdd skill に「実装関連 skill があれば参照する」指示を追加 (TODO 27 の繋ぎ) | `slice-tdd` | `機能拡張` | **優先度高め** |
| 36 | code-reviewer / e2e-reviewer に skill 動的発見・適用機構を追加 (tools 宣言修正 + 本文指示追加) | `code-reviewer`, `e2e-reviewer` | `機能拡張` | レビューでの気づき (優先度未判断) |
| 37 | story-slicing の呼び出し指示を define-requirements 側に移す (発火不全の仮説対応) | `define-requirements`, `story-slicing` | `責務境界` | レビューでの気づき (優先度未判断) |
| 38 | GitHub Actions で release notes 自動化 (CHANGELOG.md 廃止、conventional commits + tag から自動生成) | `harness-repo` | `リリース運用` | リリース運用、初回 tag 時に整備 |
| 39 | CODE_OF_CONDUCT.md の追加 (OSS 慣行) | `harness-repo` | `リリース運用` | 後回し可、PR / Issue が来始めた時 |
| 40 | SECURITY.md の追加 (将来必要になったら) | `harness-repo` | `リリース運用` | 実行可能コードが増えたら / 脆弱性報告が現実味を帯びたら |
| 41 | e2e SKILL.md 本文の「日本語名」表記を「natural language」に揃える | `e2e-skill` | `interface純化` | レビューでの気づき (description は更新済、本文未更新) |

### タグの読み方

- **ID**: 安定識別子。マージや削除があっても欠番として保持し、他項目との cross-reference を壊さない。
- **対象**: 触るファイル / コンポーネント (例: `e2e-reviewer`, `git-workflow`, `main-instructions`, `apm-mechanism`, `harness-repo`)。
- **意味**: 作業の種類。複数付与可。
  - `interface純化`: description / skill 名 / 本文表面から具体名や禁則ワードを除去 (構造は変えない)
  - `重複削減`: 複数 file / section の同内容を single source of truth に集約
  - `構造改修`: file 分割 / section 統合 / 構造そのものの変更
  - `責務境界`: 責務範囲 / 呼び出し規約 / 対話と自走の境界の再定義
  - `新規作成`: 新規 skill / agent / file を作る
  - `機能拡張`: 既存 skill / agent に機能 (tools 宣言、参照指示等) を追加
  - `他エージェント対応`: Claude Code 以外で動かす移植性関連
  - `リリース運用`: CI / Release / OSS 慣行整備
  - `自己適用`: xp-harness を自分で使う環境整備 (dogfooding)
  - `方法論導入`: eval / TDD / debug 等の方法論導入
- **温度感**: 着手判断軸 (現時点での主観的優先順位)。タグとは別軸。

各 TODO の詳細は以下のセクション参照。

---

## TODO 1: self-host (dogfooding) の実現

### 状況

harness 改修者が `/path/to/xp-harness/` で Claude Code を起動したとき、`.apm/skills/<all>/SKILL.md`、`.apm/agents/<all>.md`、`.apm/instructions/main.instructions.md` を context に取り込みたい。理想は `apm install . --target claude` の self-host で `.claude/skills/` 等に deploy することだが、**APM の循環依存検出により拒否される**。

現状の harness 改修者の Claude Code は `.claude/skills/philosophy/SKILL.md` (元から git 管理されている) のみ skill として認識する。他の skill / agent / instruction は Read tool で参照する必要がある。

### 取り得る代替手段

- **案 a: 手動 deploy script** (`scripts/setup-dev.sh` で `.apm/skills/` を `.claude/skills/` に copy + `apm compile` で CLAUDE.md 生成)
- **案 b: symlink** (`.apm/skills/<x>` → `.claude/skills/<x>`、OS 依存、git 管理が煩雑)
- **案 c: 別作業 repo** で `apm install xp-harness` (循環依存を回避するが、別 repo の維持コスト)
- **案 d: APM 側に self-install サポートを upstream contribute** (大きい作業)

### 再開時の起点

1. 案 a / b / c のどれが最もコストパフォーマンス高いか propose-options で議論
2. 採用案で `scripts/setup-dev.sh` 等を実装
3. README の Development setup section に手順を追加

---

## TODO 2: `.apm/instructions/main.md` の section 分割精査

### 状況

現状 `.apm/instructions/main.instructions.md` は 1 ファイル集約。section ごとに分割すると `apm compile` の Distribution Score 最適化機能 (複数 instruction を target dir に分散配置) を活かせる。

ただし「分割の単位」は中身を精査しないと決まらない。場当たり的に分割すると後で逆戻りリスク。

### 再開時の起点

1. 現 main.instructions.md を読み返し、論理的に独立な section を識別
2. 分割候補: `xp-philosophy` / `phase-flow` / `cross-rules` / `dialogue-type` / `review-handling` / `implementation-rules` 等
3. 分割すると Distribution Score がどう変わるかを `apm compile --dry-run` で確認
4. consumer 側の `.apm/instructions/<own>.md` 命名規約とも整合させる

---

## TODO 3: cross-agent 対応 (Cursor 等への移植)

### 状況

現状 xp-harness は **Claude Code 専用**。skill / subagent 機構を前提に書かれている。

APM は cross-agent (Cursor / Copilot / Codex / Gemini 等) を視野に入れた package manager なので、xp-harness を他 agent でも動かせれば配信範囲が広がる。

### 取り組む内容

- skill → Cursor rules への mapping
- subagent → Cursor agents への変換
- Claude Code 固有機構 (`/slash-command`, `description` ベース skill 発火) を他 agent の機構に翻訳
- `apm.yml` の `targets:` を `[claude, cursor, copilot, ...]` に拡張
- **`.apm/instructions/main.instructions.md` 内の「Claude」ハードコード (L6, L8, L17, L66, L92) を汎用語 (例: 「エージェント」「main session」等) に置き換え、他 agent でも読める文章にする** — レビューでの気づき (2026-05-11) として記録
- **`AskUserQuestion` ツール参照 (Claude Code 固有) の汎用化** — `.apm/instructions/main.instructions.md`, `.apm/skills/basic-design/SKILL.md`, `.apm/skills/define-requirements/SKILL.md`, `.apm/skills/story-slicing/SKILL.md`, `.apm/skills/propose-options/SKILL.md`, `.apm/skills/git-workflow/SKILL.md` の 6 ファイルで使われている。他 agent では同名 tool が無いので、抽象表現 (「ユーザーへの質問機構」「対話的選択肢提示」等) に置き換えるか、各 agent の同等機構へのマッピング層を設ける — レビューでの気づき (2026-05-11)
- **`TaskCreate` ツール参照 (Claude Code 固有) の汎用化** — `.apm/instructions/main.instructions.md`, `.apm/skills/slice-tdd/SKILL.md` の 2 ファイルで使われている。同じく他 agent では同名 tool が無いので、抽象表現 (「タスク管理機構」「進捗トラッキング」等) に置き換えるか、各 agent の同等機構へのマッピング層を設ける — レビューでの気づき (2026-05-11)

### 再開時の起点

1. 痛みが見えてきたか確認 (依頼者が Cursor 等を使い始めたタイミング)
2. 各 target agent の skill / agent 機構を調査
3. cross-agent 対応の方式を propose-options で議論
4. main.instructions.md の Claude 固有語の汎用化 (上記)
5. `AskUserQuestion` の汎用化 (上記 6 ファイル一括)
6. `TaskCreate` の汎用化 (上記 2 ファイル一括)
7. 他にも Claude Code 固有ツール参照が無いか網羅的に grep (`Read`, `Write`, `Edit`, `Bash`, `Glob`, `Grep`, `Task`, `WebFetch`, `WebSearch` 等は一般概念に近いが、書きぶり次第で固有性が出る可能性)

---

## TODO 4: 初回 install 時の CLAUDE.md 退避カスタムコマンド

### 状況

`apm compile --target claude` は CLAUDE.md を完全上書きする。consumer が既存 CLAUDE.md を持ったまま素朴に `apm compile` を実行すると、自前の内容が失われる。

現状は README で「初回 install 前の migrate 手順」を明示する形 (手動)。

理想は migrate を自動化するカスタムコマンド (`apm run init-migrate` 等) で、consumer の既存 CLAUDE.md を `.apm/instructions/<own>.md` に自動退避する。

### 再開時の起点

1. APM の `scripts:` セクションで `init-migrate` を定義
2. shell script (`scripts/init-migrate.sh`) で:
   - 既存 CLAUDE.md を読む
   - section ごとに `.apm/instructions/<section>.instructions.md` に分割保存
   - 元の CLAUDE.md を `.bak` にリネーム or 削除
3. README に手順を追加 (手動 migrate との両立)

---

## TODO 5: git-workflow skill の `gh` 禁止 / PR 作成依頼者責務の汎用性検討

### 状況

git-workflow skill には:
- 「`gh` コマンドは使わない」(挙動の安定性を優先)
- 「PR 作成は依頼者の責務」(守備範囲は git push まで)

がある。これらは元々 attendance-workers の環境固有経験則として生まれたルール。汎用 OSS としては consumer ごとに合わない可能性がある (例: `gh` を install 前提で運用するチームもある)。

### 取り得る案

- 案 a: core 哲学として残し、根拠を「責務分離」(守備範囲は git push まで) に書き直す
- 案 b: 中立化 (`gh` 禁止を外す、PR 作成方法は consumer の自前 instruction で決める)
- 案 c: 現状維持 + 「consumer は自前 instruction で override してよい」を skill 本文で明示

### 再開時の起点

1. consumer のフィードバックを集める (`gh` 使いたい / PR 作成も harness で扱いたい等)
2. 案 a / b / c のどれが筋か propose-options で議論

---

## TODO 6: done-verifier のテスト/build/source dir 言及の完全除去

### 状況

done-verifier subagent は現在 `npm test` / `pytest` / `cargo test` 等を例として併記する形で抽象化している。理想は project 側で実行コマンドを別途設定する仕組みにして、subagent file からは完全除去すること。

### 再開時の起点

1. APM の `scripts:` セクションで `test`, `build`, `typecheck` を定義する規約を harness 側で推奨
2. done-verifier は `apm run test` `apm run build` のような汎用 invocation を使うように書き換え
3. project (consumer) は自前 apm.yml に各コマンドを登録する運用

---

## TODO 7: e2e-reviewer 本文の e2e skill 規約言及 / プロジェクト固有値の完全除去

### 状況

e2e-reviewer subagent は preload した `e2e` skill から規約を借りる設計だと本文 L23 で明言しているのに、本文側に以下の具体名が残っており設計意図と矛盾している:

- **e2e skill 内の例への直接言及**: 「natural language ヘルパー」「注文履歴」等
- **プロジェクト固有 / framework 固有の語**: `specs/` (L19) / `src/` (L68) / `beforeEach` (L48, L62) / `globalSetup` (L64) / `afterEach` (L62)

理想は subagent 本文を完全に「観点」だけにして、規約は全て preload された skill 側から借りる純化。

### 再開時の起点

1. e2e-reviewer 本文を grep で読み返し、e2e skill 内の例 / framework / project 固有語を一覧
2. 該当箇所を preload した `e2e` skill 側の規約名 (例: 「e2e skill の Rule N を参照」「e2e skill の『テスト独立性』規約を参照」) で参照する形に書き換え
3. preload skill が変わったときに e2e-reviewer の文言を直さなくて済む状態にする

### 統合履歴

旧 TODO 7 (「e2e skill 規約言及完全除去」) + 旧 TODO 18 (「プロジェクト固有値 src/ specs/ beforeEach globalSetup 等のにじみ出し除去」) を統合 (2026-05-12)。両者とも触る対象が e2e-reviewer 本文で、意味が「規約を preload skill に委譲する純化」で完全に重なるため。

---

## TODO 8: e2e skill を framework 中立化 (Playwright 前提を外す)

### 状況

e2e skill は Playwright 前提で書かれている (`getByRole`, `test.use`, `page.locator` 等)。Cypress / Vitest browser mode 等を使う consumer は skill 全体を override する必要がある (現状)。

理想は skill から Playwright API への直接言及を抽象化し、「ロールベースセレクタの概念」レベルで書く。

### 再開時の起点

1. e2e skill 本文から Playwright 固有 API 名を抽象化 (「ロールベース API (例: getByRole, find() with role 等)」)
2. 各 framework での実装例を別 reference file (`e2e/references/playwright.md` 等) に切り出す
3. consumer が自分の framework に合わせて reference を選べるように

---

## TODO 9: e2e skill を思想 (e2e-philosophy) と実装 (e2e-playwright) に分離

### 状況

e2e skill は「テストは仕様書」「ロールベースセレクタ」「natural language ヘルパー」「テスト独立性」等の **思想** と、Playwright の **具体実装** が混ざっている。責務分離として 2 skill に分けると保守性が上がる。

### 再開時の起点

1. e2e skill から思想部分を抽出 → `e2e-philosophy` skill 新規作成
2. 実装部分を抽出 → `e2e-playwright` skill 新規作成 (preload `e2e-philosophy`)
3. README の skill 一覧を更新

---

## TODO 10: 公式 skill-creator では足りない高度な機能 + skill-template 同梱

### 状況

xp-harness は skill / agent の作成・編集に **Claude Code 公式 skill-creator skill** (consumer の `~/.claude/skills/` 等で利用可能と仮定) を使う想定。

不足する場面:
- eval 機構 (skill description / 本文の発火精度を機械的に評価)
- 敵対的シナリオ駆動の skill 開発 (TDD 方法論)
- description optimizer (発火精度の自動チューニング)
- 公式 skill-creator が install されていない consumer 向けの最小 template

### 再開時の起点

1. eval 機構のニーズが見えてきたら、harness 専用の eval skill を新規作成
2. 公式 skill-creator が install されていない consumer 向けに `.claude/skills/skill-template/` を harness に同梱する案を検討

---

## TODO 11: philosophy skill (改修者向け) を consumer に誤配布しない仕組み

### 状況

philosophy skill は `.claude/skills/philosophy/` (APM 管理外) に置くことで配信を抑止しているが、consumer が `.claude/` を丸ごとコピー / 同名 skill 自作によって誤って philosophy 系 skill を取り込むシナリオがある。

### 再開時の起点

1. namespace 分離の仕組みを検討 (例: harness 改修者向け skill は `_harness-dev-` prefix を付ける)
2. description に「xp-harness 自体の」など修飾語を明示して誤発火を抑制
3. consumer が間違えて取り込んだときの警告メカニズム

---

## TODO 12: skill 開発の TDD / eval 方法論導入

### 状況

harness の skill を変更したとき「期待通りに発火するか / 想定通りに動くか」を機械的に検証する方法論が無い。現状は実 session で動かして観察する手動検証のみ。

skill 発火と挙動を eval セットで検証する業界先行事例を参考に、skill TDD の方法論導入を検討する。

### 取り組む内容

- 失敗するシナリオ (skill が発火しないクエリ / 誤発火するクエリ) を eval セットとして用意
- skill 変更時に eval を回して挙動差分を確認
- skill description の発火精度を機械的にチューニング

### 再開時の起点

1. チーム配布が見えてきたか確認
2. 中間案 (簡易 eval 習慣) を先に導入するか議論
3. 業界の skill eval 方法論を参考に harness 用に翻訳

---

## TODO 13: デバッグスキル新設

### 状況

バグ修正の質を底上げするための skill。「4 phase root cause investigation」(Root Cause → Pattern Analysis → Hypothesis and Testing → Implementation) を強制する skill が xp-harness にはない。

`slice-tdd` は「テストを書く規律」であって「根本原因を探る規律」ではない。バグ修正時に同じパターンを繰り返さないための skill が必要。

### 再開時の起点

1. 4 phase root cause investigation の業界事例を読む
2. xp-harness の対話駆動・自走モードに合わせて文化的調整
3. slice-tdd との連携方式 (バグ修正時に systematic-debugging → slice-tdd の流れ)

---

## TODO 14: skill 編集時の思想 loading 仕組み

### 状況

新 skill を作る / 既存 skill を改修するときに、philosophy skill の判断軸を必ず参照した状態で進める仕組みが必要。現状は philosophy skill の description で「skill / agent 作成・改修時に発火」を強調しているが、確実に loading される保証はない (Claude の自律に依存)。

skill が増えるほど drift リスクが累積する。

### 再開時の起点

1. philosophy skill の description で更に発火条件を強化
2. or hook で skill 編集時に philosophy を強制 loading (ただし hook の保守コストとトレードオフ)
3. or `skill-creator` を改修して philosophy を pre-load

---

## TODO 15: AgentTeam 導入検討

### 状況

Claude Code v2.1.32+ の実験的機能 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`。teammate 同士が直接通信する decentralized なマルチエージェント機構。

xp-harness の long-term 構想 (要件定義から agent ペアで意思決定 / ユーザーストーリーごとにチームを作って対応) と方向性が一致する可能性。

### 注意点

- lead 固定 / ネスト不可 / 1 セッションに 1 チームの制限あり
- 既存 agent 定義 (`code-reviewer.md` 等) を teammate role として再利用可能。**ただし `skills:` プリロード指定は teammate モードでは無効**になる点に注意
- 「subagent はペアプロ相手」哲学と teammate モードの整合を取る必要 (worker 模式に倒さない)

### 再開時の起点

1. 現行 subagent / skill の検証がもう一段進んでから本格導入を計画
2. 1 ストーリー単位の AgentTeam 試験導入を計画
3. 既存 agent 定義の teammate role 再利用方法の検証 (preload skill 不可問題への対応)

---

## TODO 16: code-reviewer の description に設計書/要件定義パスを渡す前提を明示

### 状況

`.apm/agents/code-reviewer.md` の本文 (L17-18) では「呼び出される時点で `docs/working/<title>/要件定義.md` / `基本設計.md` がある (読む)」が前提と書かれている。一方 frontmatter の `description` には「設計整合 (docs/working/<title>/基本設計.md との照合)」とは書いてあるものの、**呼び出し側がそのパスを渡すべき** ことが明示されていない。

main session (呼び出し側) は description ベースで agent 起動可否を判断するので、「何を一緒に渡すべきか」が description だけで分からないと、パス無しで呼び出してしまい agent 側が手探りで探す事態になる。

### 再開時の起点

1. `.apm/agents/code-reviewer.md` frontmatter の `description` に「呼び出し時に対象タイトルの要件定義 / 基本設計のパスを引数として渡すこと」を明示
2. main session 側 (instructions / 関連 skill) で code-reviewer を呼ぶ際の例示文言とも整合を取る

---

## TODO 17: code-reviewer のレビュー範囲を diff だけに閉じず周辺コードも refactor 対象に

### 状況

`.apm/agents/code-reviewer.md` の「直近の変更にフォーカスする」section (L107-112) は `git diff` の範囲のみを対象とし、「変わってないが既存に問題があるコードは指摘しない (スコープ外)」と明示している。

実際の Refactor 場面では「今触っている箇所の周辺」を一緒に整理したいケースがある。diff 厳格主義だと、周辺の重複や責務違反が放置され続け、Refactor の機会を逃す。

### 再開時の起点

1. 「振る舞いのルール」section を改訂し、diff だけでなく「今触っている箇所の周辺」も refactor 対象として一緒に見る方針に書き換え
2. 「周辺」の範囲判断軸 (どこまでを周辺とみなすか) を定義
3. (派生) `slice-tdd` skill 側の Refactor フェーズ記述と整合を取る (周辺 refactor の責務が code-reviewer に拡張されることが、slice-tdd 全体の流れと矛盾しないか確認)

---

## TODO 18: (欠番)

旧 TODO 18「e2e-reviewer からプロジェクト固有値 (src/ specs/ beforeEach globalSetup 等) のにじみ出しを除去」は TODO 7 に統合した (2026-05-12)。ID は欠番として保持し、他項目との cross-reference を壊さないようにする。

---

## TODO 19: e2e-reviewer の「テスト独立性」section が重複しているのでまとめる

### 状況

`.apm/agents/e2e-reviewer.md` の「レビューの観点」内で、テスト独立性が 2 か所に分かれて書かれている:

- 「### 3. テスト独立性」(L46-49): beforeEach / 順序依存 / 単独実行
- 「### 5. テスト独立性の確認方法」(L60-64): beforeEach vs afterEach / 可変データクリア / globalSetup 依存

同じトピックが 2 section に割れているので、観点と確認方法を 1 つの section に統合した方が読みやすい。

### 再開時の起点

1. 3 と 5 の中身を統合し、「テスト独立性」1 section にまとめる
2. 番号が詰まるので 4 (ヘルパーの責務分離) / 6 (reviewer 自身の責務範囲) の番号も繰り上げる

---

## TODO 20: e2e-reviewer の description に設計書/要件定義パスを渡す前提を明示

### 状況

`.apm/agents/e2e-reviewer.md` 本文 (L18) で「`docs/working/<title>/要件定義.md` に Done が書かれている (読む)」が前提と書かれている。一方 frontmatter の `description` には、呼び出し側がそのパスを渡すべきことが明示されていない。TODO 16 (code-reviewer の同種の問題) と同じ構造。

### 再開時の起点

1. `.apm/agents/e2e-reviewer.md` frontmatter の `description` に「呼び出し時に対象タイトルの要件定義 (および必要なら基本設計) のパスを引数として渡すこと」を明示
2. TODO 16 と合わせて、subagent 一般の呼び出し規約として整理できないか検討 (pre-implementation-reviewer / done-verifier にも波及する可能性)

---

## TODO 21: pre-implementation-reviewer の description に要件定義/基本設計パスを渡す前提を明示

### 状況

`.apm/agents/pre-implementation-reviewer.md` の frontmatter `description` (L3) では「`docs/working/<title>/要件定義.md` と `docs/working/<title>/基本設計.md` が書き終わった段階で、依頼者または main session が呼ぶ」と書かれているが、**呼び出し側がそのパスを引数として渡す前提** であることが軽い書き方になっており、明確に読み取れない。本文 (L14-16) では前提として明示されているが、description だけ読んで呼び出すと paths を渡さず agent 側が手探りで探す事態になり得る。

TODO 16 (code-reviewer) / TODO 20 (e2e-reviewer) と同根の問題。subagent 一般の呼び出し規約として整理できる可能性がある。

### 再開時の起点

1. `.apm/agents/pre-implementation-reviewer.md` frontmatter の `description` に「呼び出し時に対象タイトルの要件定義 / 基本設計のパスを引数として渡すこと」を明示
2. TODO 16 / 20 / 21 を束ねた「subagent 呼び出し規約」として整理できないか検討

---

## TODO 22: main.instructions.md のフェーズフロー section の削除またはスリム化

### 状況

`.apm/instructions/main.instructions.md` のフェーズフロー section が context に乗る重量に対して、得られる価値が見合わない可能性。なくすか、もっとスリムにできないか検討する。

TODO 2 (section 分割精査) とは別の観点 — TODO 2 は「分割で Distribution Score 最適化」、こちらは「そもそも要らない section を削る」。

### 再開時の起点

1. 現フェーズフロー section の中身を読み返し、main session が実運用で参照する場面があるか確認
2. 同等の情報が skill 側 (`define-requirements`, `basic-design`, `slice-tdd` 等) でカバーされていないか照合
3. 削除 / スリム化の方針を決める (全削除 / 見出しだけ残す / 半分削る 等)

---

## TODO 23: main.instructions.md の各フェーズの振る舞い section の skill 重複解消検討

### 状況

`.apm/instructions/main.instructions.md` の「各フェーズの振る舞い」section は、各フェーズ (要件定義 / 基本設計 / 実装) の振る舞いを記述しているが、これらは対応する skill (`define-requirements`, `basic-design`, `slice-tdd` 等) 側に既にあるはず。重複していると context 二重課金 + drift リスク。

### 再開時の起点

1. main.instructions.md の「各フェーズの振る舞い」section と、対応 skill 本文を突き合わせて重複箇所を識別
2. 重複しているなら main 側を削除し、skill 側を single source of truth にする
3. instruction 側に残すべき責務 (フェーズ横断のルール、phase switching の判断軸 等) と、skill 側に委譲すべき責務 (各フェーズ内の振る舞い詳細) の境界を再定義

---

## TODO 24: main.instructions.md 全体の skill 重複洗い出し / 必要なものへの絞り込み (章ごと + 全体)

### 状況

main.instructions.md は全体的に skill 側と重複していそう。本当に instruction として必要なものに絞り込む必要がある。TODO 22 (フェーズフロー) / 23 (各フェーズの振る舞い) はその具体例だが、それ以外の章にも同じ問題がある可能性。各章ごとに見直し + 全体としてのまとまりも再検討。

TODO 2 (section 分割) とは関心が異なる: TODO 2 は「分割」、TODO 24 は「削減 / 絞り込み」。ただし両者は連動するので、TODO 2 と合わせて取り組むのが筋。

### 再開時の起点

1. main.instructions.md の全章を列挙し、各章ごとに「skill 側に同等の記述がないか」を照合
2. 章ごとに「残す / 削る / skill に委譲」を判定
3. instruction として必須の責務 (フェーズ間ルール、対話と自走の境界、レビュー受け渡し 等) を絞り込む
4. TODO 2 (section 分割) と一緒に走らせ、削減 → 分割の順で進めると Distribution Score 最適化が効きやすい

---

## TODO 25: ふりかえり skill の新設 (作業完了後にユーザーへふりかえりを問いかけ、改善点を分析・報告する)

### 状況

xp-harness にふりかえり (retrospective) を駆動する skill が無い。作業 (ユーザーストーリー / TDD サイクル / セッション 等) が完了したタイミングで、main session 側がユーザーに「ふりかえりませんか？」と自発的に問いかけ、改善点を引き出す skill を新設したい。

XP のペアプロ / イテレーションのリズムにおいてふりかえりは中核要素なので、harness 思想と整合する。現状はユーザー側がふりかえりを切り出さないと改善点が拾えない状態。

### 責務境界 (重要)

この skill の責務は **分析 + 改善点の報告までに限定** する。実際の skill / agent 修正は行わない。理由は 2 つ:

- **責務分離**: 修正は専門の skill / agent (例: `skill-creator`, または harness 改修者向けの editor agent) に委譲。レトロスペクティブと同じく、ふりかえり自体は「気づきを出す場」であって「直す場」ではない。
- **OSS 配布前提**: xp-harness は APM 経由で OSS として skill セットを配布するリポジトリ。consumer 環境では harness の skill 本体を直接書き換えるのは想定外なので、どっちみち「報告 → harness 改修者にフィードバック」のフローしか取れない。報告フォーマットを明確にすることが肝。

### 再開時の起点

1. 発火タイミングを定義 (作業完了 = 何をもって完了とするか: ストーリー Done / コミット完了 / セッション終了 等)
2. 問いかけ方の対話設計 (押し付けず、しかし忘れさせない言い方) — `dialogue-principles` skill と整合
3. 引き出す観点を定義 (Keep / Problem / Try? それとも YWT? 文化に合わせる)
4. 改善点の **報告先 / 報告フォーマット** を決める: ROADMAP に TODO として追記 / `docs/working/<title>/ふりかえり.md` に残す / consumer から harness 改修者へ届けるチャネル (issue / PR / Slack 等) など
5. 修正は専門 skill / agent に委譲する受け渡し方を設計 (どの形で投げるか、どの粒度で投げるか)
6. skill 名 / description を決め、`skill-creator` で雛形作成

---

## TODO 26: basic-design / define-requirements の末尾「/clear で次フェーズへ」案内の要否検討

### 状況

以下 2 ファイルの末尾に、ほぼ同じ構造の「次のフェーズへの誘導」section があり、`/clear` でセッションをリセットして次フェーズへ進む案内を出すよう書かれている:

- `.apm/skills/basic-design/SKILL.md` L334-347 (実装フェーズへの誘導)
- `.apm/skills/define-requirements/SKILL.md` L223-238 (基本設計フェーズへの誘導)

この案内が本当に必要か検討する。考えられる論点:

- そもそも skill 側で `/clear` を促す責務があるのか (instruction / phase-flow 側の責務では?)
- 同じパターンが 2 ファイルで繰り返されているので DRY 観点で集約余地
- 「強制ではなく任意のガイド」と書いてある通り価値が薄いなら削除候補
- 残すなら、Claude Code 固有機構 (`/clear`) を skill 本文に書くのは cross-agent 対応 (TODO 3) と衝突する点も検討

### 再開時の起点

1. 両 section の運用上の有用性をふりかえる (実際に使われているか / ユーザーが従っているか)
2. 残す場合: 共通化先を検討 (`phase-flow` 系 instruction or skill, あるいは Claude Code 固有部分の分離)
3. 削除する場合: 両 skill から該当 section を除去、phase 遷移は instruction 側 or ユーザー判断に委ねる

---

## TODO 27: E2E と対になる実装 skill の新設 (実装規約 + architecture を担う)

### 状況

現状、E2E spec の規約・哲学は `e2e` skill にまとまっている (ロールベースセレクタ、natural language ヘルパー、GIVEN/WHEN/THEN、テスト独立性 等)。一方、**実装コードそのものの規約 / architecture を扱う skill が無い**。

近いものに `slice-tdd` があるが、これは TDD のリズムと分割が主で、「実装の規約」「architecture (レイヤ構造、依存方向、モジュール境界、命名規約 等)」はカバーしていない。E2E skill と対になる「実装側の規約 + architecture を扱う skill」が欲しい。

現状は code-reviewer subagent が SOLID 等の品質観点を持っているが、これは「レビューする側の観点」であって、「実装する側が従う規約」ではない。implementer 側に規約 skill が無いので、レビューでしか規律が効いていない構造になっている。

### 再開時の起点

1. skill の責務範囲を定義: 実装規約 (命名、責務分離、エラーハンドリング境界) / architecture (レイヤ、依存方向、モジュール境界) / 既存 skill との境界
2. `slice-tdd` / `code-reviewer` との責務切り分けを明確化 (slice-tdd は TDD リズム、code-reviewer はレビュー視点、新 skill は実装規約の single source of truth)
3. `e2e` skill と同じく framework / 言語固有部分の扱いを設計 (TODO 8 / 9 で議論している分離方針と整合)
4. skill 名候補を決める (例: `implementation`, `coding-rules`, `architecture` 等) → `skill-creator` で雛形作成

---

## TODO 28: define-requirements / basic-design と dialogue-principles の重複整理

### 状況

`.apm/skills/define-requirements/SKILL.md` および `.apm/skills/basic-design/SKILL.md` の対話関連の記述と、`.apm/skills/dialogue-principles/SKILL.md` の内容に重複がありそう。skill 間で同じ思想 / ルールが二重 / 三重に書かれていると drift リスクが累積し、context にも二重課金が乗る。

dialogue-principles を single source of truth として、各フェーズ skill 側は dialogue-principles を preload / 参照する形に整理するのが筋。ただし「対話そのもののルール」と「フェーズ固有の対話 (要件定義の聞き方 / 基本設計の聞き方)」の境界は要検討。

TODO 24 (main.instructions.md の重複洗い出し) と方向性が近い (重複削減 + single source of truth 化)。

### 再開時の起点

1. 3 skill を並べて重複箇所を識別 (対話の姿勢 / 質問の仕方 / 押し付けない態度 / 共創を目指す等)
2. dialogue-principles に集約すべき内容と、フェーズ skill 固有として残すべき内容を切り分ける
3. フェーズ skill 側で dialogue-principles を preload / 引用する形に書き換え
4. TODO 24 と一緒に走らせると、main.instructions.md の重複整理と歩調を合わせやすい

---

## TODO 29: e2e skill の description から具体名 (Playwright, test.use, getByRole, page.locator) を除去

### 状況

`.apm/skills/e2e/SKILL.md` の frontmatter `description` (L3) に以下の具体名が直接書かれている:

- 「E2E テスト (Playwright 想定)」
- 「test.use / getByRole / page.locator」

**skill description は呼び出し側に対する interface**。具体の framework / API 名を入れると、その framework に縛られた skill だと誤解される / 他 framework を使う consumer が誤発火を防げない。description は「E2E テストを書く・編集する」レベルの一般概念にとどめるべき。

具体の Playwright API 規約は skill 本文に書き、description には書かない。TODO 8 (e2e skill を framework 中立化) / TODO 9 (思想と実装の分離) と方向性が一致。

### 再開時の起点

1. `.apm/skills/e2e/SKILL.md` frontmatter の description から Playwright / test.use / getByRole / page.locator を除去
2. description は「E2E テストを書く・編集する・レビューする際の規約」レベルの抽象表現に書き換え
3. TODO 8 / 9 と一緒に走らせると framework 中立化と整合的

---

## TODO 30: git-workflow skill の description から `gh` 不使用ルール言及を除去 (具体ツール名 NG)

### 状況

`.apm/skills/git-workflow/SKILL.md` の frontmatter `description` (L10, L12) に「`gh` 不使用ルール」「`gh` 禁止」と具体ツール名が書かれている。description は interface なので、具体ツール名 (`gh` / `gh cli`) は入れるべきでない。

判断軸: **commit / branch / push などの Git 一般概念は OK** (Git そのものの概念なので普遍)。`gh` のような **特定ツール名は NG** (consumer 環境によっては前提が変わる)。TODO 5 (`gh` 禁止 / PR 作成依頼者責務の汎用性検討) と関連。

### 再開時の起点

1. `.apm/skills/git-workflow/SKILL.md` frontmatter description から `gh` 言及を除去
2. description は「Git 操作の規律 (branch / commit / push / pull / rebase / conflict 等)」一般概念レベルの表現に統一
3. `gh` 禁止の具体ルール自体は skill 本文に残してよい (本文は実装層)、ただし TODO 5 で汎用性自体も再検討予定

---

## TODO 31: git-workflow skill 本文から `.apm` / `apm compile` / consumer 等の APM 機構言及を除去 (優先度高)

### 状況

`.apm/skills/git-workflow/SKILL.md` 本文に APM 機構固有の言及が複数ある:

- L12: "consumer 自前 instruction での部分上書き対応"
- L29: "consumer の自前 instruction (`.apm/instructions/<own>-git-rules.md` 等) が優先"
- L154: "`apm compile` で CLAUDE.md に bundle され、git-workflow skill は CLAUDE.md の該当 section を読んで動作を切り替える"
- L158: "consumer の `.apm/instructions/git-rules.md` に..."
- L160: "APM の last-installed-wins 機構 (`.apm/skills/git-workflow/SKILL.md` を consumer 側で書く)..."

**skill は展開された後の最終形 (consumer の `.claude/skills/` 等に deploy された状態) でも自然に読める形でなければならない**。展開後は `.apm/` も `apm compile` も関係ないので、これらの言及は skill 本文の責務外。APM 機構の話は APM 側 (README / apm.yml / instruction 等) に書くべき。

**優先度高** (依頼者明示)。skill の責務境界の根本問題なので、他の harness 改修より先に対処したい。

### 再開時の起点

1. `.apm/skills/git-workflow/SKILL.md` 本文から L12 / L29 / L154 / L158 / L160 の APM 機構言及を識別
2. 該当箇所を「project 固有のルールで override 可能 (consumer 側の override 方法はインストール先 agent 仕様に従う)」など、APM 非依存の汎用表現に書き換え
3. APM 機構固有の override 説明 (apm compile / .apm/instructions/ 配置) は別 doc (README or APM 側 instruction) に移す
4. 同じ問題が他 skill にも無いか grep で確認 (`.apm/skills/**/SKILL.md` 内の `apm` / `.apm` / `consumer` 言及)

---

## TODO 32: slice-tdd skill の名前再検討 (優先度高め)

### 状況

`slice-tdd` という skill 名が、この skill が担う役割の広さに対して適切かを再検討したい。現在の skill description は「コード書く / テスト書く / リファクタ / バグ修正 / E2E spec 追加 / 既存仕様への小さな修正 / 実装フェーズの作業など、コードに触る作業すべて」と広い。一方で名前は「slice (分割) + TDD」と TDD リズム寄りで、責務範囲を狭く見せている。

依頼者明示で **優先度高め**。skill 名は呼び出し側に対する interface (description と並ぶ重要な signal) なので、責務と一致しないとミスマッチが起き続ける。

### 再開時の起点

1. この skill の本当の責務範囲を 1 文で書き出す (TDD リズム + 分割 + 実装フェーズ全般 のどこまでか)
2. 候補名の発散 (例: `implementation`, `tdd-cycle`, `incremental-implementation`, `dev-loop` 等) — `propose-options` で議論
3. 名前変更に伴う他箇所の更新範囲を見積もる (instruction / 他 skill から `slice-tdd` を参照している箇所、subagent の preload `skills:`、`code-reviewer.md` の preload 等)

---

## TODO 33: slice-tdd skill 内の Playwright 記述 (L215) を除去

### 状況

`.apm/skills/slice-tdd/SKILL.md` L215 に Playwright 固有名が混入:

> E2E spec を書く必要が出たら、必ず **`e2e` skill を呼ぶ**。`e2e` skill が Playwright 固有の規約（ロールベースセレクタ、日本語ヘルパー、specs/ ディレクトリ構成、テスト独立性）を持っている。

`slice-tdd` は実装一般の skill であって、E2E framework の具体名を持つべきでない。`e2e` skill 側に責務を委譲しているなら「`e2e` skill が E2E 規約を持つ」とだけ書けば足りる。TODO 8 / 9 (e2e の framework 中立化 / 分離) とも整合。

### 再開時の起点

1. L215 から「Playwright 固有の規約」「ロールベースセレクタ、日本語ヘルパー、specs/ ディレクトリ構成、テスト独立性」を削除
2. 抽象表現に書き換え (「`e2e` skill が E2E spec の規約と書き方を持つ」程度)

---

## TODO 34: slice-tdd skill の「依頼者に状況を確認する」箇所を自走モード前提で詰める

### 状況

`.apm/skills/slice-tdd/SKILL.md` L264 / L270-290 に「自走をやめて依頼者に確認する」条件が複数列挙されている (詰まったら / 設計 md と矛盾する判断 / 設計に無いケース / スコープが想定より大きい / destructive 操作 / 複数アプローチで選択ミスると痛い)。

**自走モード前提では基本的に自分で解決してほしい**。現状のリストは止まる条件が広めで、自走の意図と合っていない可能性。何を残し、何を「自分で判断して進める」に倒すかを精査して詰めたい。

「対話と自走の境界」は xp-harness 中核思想の一つでもあるので、philosophy / dialogue-principles 系との整合も必要。

### 再開時の起点

1. L264 / L270-290 の各条件を一覧し、「自走モードで本当に止まるべきか / 自分で判断して進むべきか」を判定
2. 「止まる」と判定したものは止まる理由を強化、「進む」と判定したものは判断軸 (どう判断して何を選ぶか) を skill 内に書く
3. philosophy skill / dialogue-principles skill の「対話と自走の境界」記述と整合を取る
4. destructive 操作は止まる側で固定 (これは harness 安全規律として動かさない)

---

## TODO 35: slice-tdd skill に「実装関連 skill があれば参照する」指示を追加 (TODO 27 の繋ぎ、優先度高め)

### 状況

現状 slice-tdd skill は TDD リズム / 分割を担うのみで、「実装規約 + architecture」を担う skill は存在しない (TODO 27 で新設予定)。新 skill が出来上がるまでの繋ぎとして、**slice-tdd skill 本文に「実装に関連する skill (consumer 側で用意した架空の implementation skill / 業界の同種 skill 等) が見つかったら、それを参照して規約に従う」指示を入れる** ことで、当面の暫定対応とする。

依頼者明示で **優先度高め**。TODO 27 の本格対応より先に「とりあえず」入れたい暫定指示。

### 再開時の起点

1. slice-tdd skill 本文に「実装関連 skill (`implementation`, `coding-rules`, `architecture` 等の skill 名で利用可能であれば) を参照する」旨を 1 section 追加
2. TODO 27 で正式な実装 skill が出来たら、この暫定指示を正式な preload 指定に置き換える
3. consumer 側で自前の実装規約 skill を持っている場合の参照方式も書いておく (project 固有 skill 名の override)

---

## TODO 36: code-reviewer / e2e-reviewer に skill 動的発見・適用機構を追加 (tools 宣言修正 + 本文指示追加)

### 状況

xp-harness の reviewer subagent 4 つ (`code-reviewer`, `done-verifier`, `e2e-reviewer`, `pre-implementation-reviewer`) は全て `tools: Read, Grep, Glob, Bash` で **Skill が含まれていない**。Claude Code の `tools:` は allowlist 方式 (sub-agents.md line 302-304) なので、現状は **preload (`skills:` frontmatter) で指定した skill しか使えず、Skill tool 経由の動的発火が不可能**。依頼者明示「これは意図してない」(2026-05-13)。

公式仕様 (sub-agents.md line 421):
> "Subagents can still invoke unlisted project, user, and plugin skills through the Skill tool"

つまり `tools:` に `Skill` を含めれば、preload 以外の project / user / plugin の全 skill を subagent が動的に発見・発火できる。

ただし全 reviewer 一律に追加するわけではなく、subagent ごとの責務で判断する (依頼者と整理、2026-05-13):

| subagent | 動的発火 | 理由 |
|---|---|---|
| **code-reviewer** | **追加する** | 実装規約 / framework 固有規約 / architecture skill を動的発見したい |
| **e2e-reviewer** | **追加する** | test framework 規約 / project 固有 E2E 規約を動的発見したい |
| **done-verifier** | **追加しない (preload only を維持)** | 証拠検証専属、観点固定、他 skill 動的発見の場面が無い |
| **pre-implementation-reviewer** | **追加しない (preload only を維持)** | 「観点を当てる」責務で規約は持たない設計。project 固有 skill が必要な場合は main session が事前に観点を整理して渡すほうが筋 |

TODO 27 (実装 skill 新設) / TODO 35 (slice-tdd 経由の暫定参照) と連動する話。code-reviewer / e2e-reviewer が実装規約 skill / E2E 規約 skill を動的に参照できれば、レビュー基準が「subagent 固定観点」だけでなく「project 固有規約」「業界 skill」とも整合的に走る。

### 再開時の起点

1. `code-reviewer.md` / `e2e-reviewer.md` の frontmatter `tools:` に `Skill` を追加
2. それぞれの本文に「レビュー対象のコード / spec と文脈から関連 skill (実装規約 skill / framework 固有 skill / project 固有 skill 等) を探して読み、それに基づいてレビューする」旨の指示を追加
3. 動作確認: 最小 PoC で、preload 以外の skill を実際に発火できるか検証
4. `done-verifier.md` / `pre-implementation-reviewer.md` は **preload only を意図した設計として明示** する文言を本文に追加 (将来「これらも Skill 入れる？」が再燃しないように)
5. TODO 27 (実装 skill) が完成したら、code-reviewer / e2e-reviewer の preload にも組み込むか動的発見に任せるかを判断

---

## TODO 37: story-slicing の呼び出し指示を define-requirements 側に移す (発火不全の仮説対応)

### 状況

`story-slicing` skill が呼ばれないケースがあった (依頼者観測)。原因として疑っているのは、**呼び出しタイミングが呼ばれ側 (`story-slicing/SKILL.md`) の description に書かれているだけで、呼ぶ側 (`define-requirements/SKILL.md`) には story-slicing への言及が無い** という構造的問題。

実状:
- `story-slicing/SKILL.md` L3 description: 「要件定義完成直後に必ず発火させる (define-requirements がユーザーストーリーを書き終えた直後)」
- `define-requirements/SKILL.md`: `story-slicing` への言及なし (grep 結果 0 hit)

呼ばれ側に書いても、呼ぶ側の context にロードされていない skill は発火しにくい。呼び出しタイミングは **呼ぶ側に書く** のが筋。

### 再開時の起点

1. `define-requirements/SKILL.md` のフェーズ終了タイミング (ユーザーストーリー書き終えた直後の section) に「直後に `story-slicing` skill を呼ぶ」指示を追加
2. `story-slicing/SKILL.md` の description から呼び出しタイミングの記述を削除 or 簡略化 (description は responsibility 宣言中心にする)
3. 同様の「呼ばれ側に呼び出しタイミングを書いているだけ」パターンが他に無いか確認 (例: `pre-implementation-reviewer`, `code-reviewer`, `e2e-reviewer` 等の発火タイミングが呼ぶ側の skill に書かれているか)
4. (派生) この構造的問題を philosophy / skill-creator 側のルールとして集約する (skill 設計の原則: 呼び出しタイミングは呼ぶ側に書く)

---

## TODO 38: GitHub Actions で release notes 自動化 (CHANGELOG.md 廃止)

### 状況

CHANGELOG.md を repo root に手動でメンテするのは面倒。代わりに GitHub Releases の release notes を **Actions で自動生成**する運用にする。

候補 action / 方式:
- `release-please` (Google 製、conventional commits から CHANGELOG / release notes / version bump を自動化)
- `release-drafter` (PR ラベルから release notes を draft 生成)
- `gh release create` を tag push trigger で叩く独自 Action

採用 action / 方式は実装時に propose-options で議論。

### 再開時の起点

1. `release-please` / `release-drafter` / 独自 Action の 3 案を比較
2. conventional commits (feat: / fix: / chore: 等) の運用ルール を harness の commit 規約に組み込むか判断
3. `.github/workflows/release.yml` を整備
4. 初回 tag (`v0.1.0`) を push したときの自動生成挙動を確認

---

## TODO 39: CODE_OF_CONDUCT.md の追加 (OSS 慣行)

### 状況

OSS 公開リポジトリの慣行として `CODE_OF_CONDUCT.md` を root に置くケースが多い (Contributor Covenant 等)。xp-harness は personal harness で contribution guide はスコープ外と決めているため初版では同梱せず、将来 PR / Issue が活発に来始めたタイミングで追加する。

### 再開時の起点

1. Contributor Covenant の最新 version を <https://www.contributor-covenant.org/> で確認
2. `CODE_OF_CONDUCT.md` を root に配置、README から link
3. 違反報告窓口は GitHub Security Advisories を流用するか別途検討

---

## TODO 40: SECURITY.md の追加 (将来必要になったら)

### 状況

OSS 公開リポジトリの慣行として `SECURITY.md` (脆弱性報告ポリシー) を root に置くケースが多い。xp-harness は markdown ファイル中心で実行可能コードがほぼないため、典型的な「脆弱性」(XSS / SQLi / auth bypass 等) 概念が当てはまりにくく、初版では同梱しない。

GitHub にはデフォルトで Security Advisory 投稿フォームが存在するため、SECURITY.md がなくても報告経路は失われない。

将来 harness 自体に実行可能コード (Action / script 等) が増えるか、第三者からの脆弱性報告が現実味を帯びたタイミングで追加する。

### 再開時の起点

1. 実行可能コード (`.github/workflows/`、CLI script 等) が harness に増えたか確認
2. `SECURITY.md` を root に配置 (Contributor Covenant の SECURITY 雛形、または GitHub の Security Advisory ガイド準拠)
3. README から link

---

## TODO 41: e2e SKILL.md 本文の「日本語名」表記を「natural language」に揃える

### 状況

設計 §4.6 で「日本語ヘルパー」→「natural language ヘルパー」(project の言語選択を尊重) と方針確定し、`.apm/skills/e2e/SKILL.md` の description および `.apm/agents/e2e-reviewer.md` 本文は更新済。一方 SKILL.md 本文の見出し / 説明文 / 手順には「日本語名」表記が残存している:

- L33: `### 2. 操作はヘルパー関数（日本語名）に切り出す`
- L37 周辺: `**関数名は日本語で意図を表現**`
- L191 周辺: 「日本語名」言及

description と本文の表記不整合は読み手の混乱を招くため、本文も「natural language」に揃える。

### 再開時の起点

1. SKILL.md 本文の該当 3 箇所を grep で再確認
2. 「日本語名 / 日本語で」表現を「natural language 名 / project の言語で」等に置換
3. 例として残っている日本語関数名 (`taro` 等の dummy 値以外) を、必要に応じて project の言語の自由度を強調する文言に調整
4. e2e-reviewer.md / philosophy SKILL.md など関連 file との表記整合を最終確認

---

## このファイルの保守

新規 TODO を追加するときは、各項目に以下を含める:

- **状況**: 何の機能 / 改善か (1-2 段落)
- **再開時の起点**: 何から始めるか (具体的な action 1-3 個)

完了したら削除 or 「完了済」セクションに移す。優先順位は実運用での痛み・採用度・コストで都度見直し。
