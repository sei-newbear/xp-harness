# xp-harness ROADMAP

xp-harness を進化させるための保留 TODO リスト。各項目は harness 改修者 (依頼者本人 + 関心あるチームメンバー) が手を入れるときの起点として使う。

優先順位は実運用での痛み・採用度・コストで決める。「あった方が良いが、無くても困らない」レベルのものを多く含む。

---

## 優先順位（現在の温度感）

| ID | TODO | 対象 | 意味 | 温度感 |
|---|---|---|---|---|
| 1 | (欠番、完了として削除 2026-05-17 — self-host は一時対応 `scripts/setup-dev.sh` + symlink で十分、本格対応は痛みが見えてから新規 TODO で起こす) | — | — | — |
| 2 | `.apm/instructions/main.md` の section 分割精査 | `main-instructions` | `構造改修` | 中身を精査しながら判断 |
| 3 | cross-agent 対応 (Cursor 等への移植) | (全体) | `他エージェント対応` | 痛みが見えてから |
| 4 | 初回 install 時の CLAUDE.md 退避カスタムコマンド | `apm-mechanism` | `新規作成`, `機能拡張` | 利用者の事故防止 |
| 5 | git-workflow skill の `gh` 禁止 / PR 作成依頼者責務の汎用性検討 | `git-workflow` | `責務境界` | 個人 / チーム portability では現状で OK |
| 6 | done-verifier のテスト/build/source dir 言及の完全除去 | `done-verifier` | `interface純化` | 開発周り |
| 7 | (欠番、完了 2026-06-07 — 規約探索型スキルへの薄型化で e2e-reviewer を観点導出型に疎結合化、規約言及・プロジェクト固有値を除去) | — | — | — |
| 8 | (欠番、完了 2026-06-07 — e2e skill を探索型に薄型化、Playwright 前提を配布既定から除去) | — | — | — |
| 9 | (欠番、取り下げ 2026-06-07 — 規約探索型スキルへの薄型化で逆方向に確定: 思想ごと配布既定から外し、流儀はプロジェクト側で定義する) | — | — | — |
| 10 | 公式 skill-creator では足りない高度な機能 + skill-template 同梱 | `skill-creator` | `機能拡張`, `方法論導入` | skill 開発が増えてきたら |
| 11 | philosophy skill (改修者向け) を consumer に誤配布しない仕組み | `philosophy`, `apm-mechanism` | `責務境界` | 誤配布シナリオが実際に起きたら |
| 12 | skill 開発の TDD / eval 方法論導入 | `harness-repo` | `方法論導入` | チーム配布が見えてきたら |
| 13 | デバッグスキル新設 (systematic-debugging 相当) | (新規) | `新規作成` | バグ修正の質に痛みが見えてから |
| 14 | skill 編集時の思想 loading 仕組み | `philosophy`, skill-edit機構 | `機能拡張` | skill が増えるほど drift リスク累積 |
| 15 | AgentTeam 導入検討 | (harness 全体) | `他エージェント対応`, `方法論導入` | 現行 subagent の検証が進んでから |
| 16 | code-reviewer の description に設計書/要件定義パスを渡す前提を明示 | `code-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 17 | code-reviewer のレビュー範囲を diff だけに閉じず周辺コードも refactor 対象に | `code-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 18 | (欠番、TODO 7 に統合) | — | — | — |
| 19 | (欠番、取り下げ 2026-06-07 — e2e-reviewer 疎結合化で対象 section 自体が消滅) | — | — | — |
| 20 | e2e-reviewer の description に設計書/要件定義パスを渡す前提を明示 | `e2e-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 21 | pre-implementation-reviewer の description に要件定義/基本設計パスを渡す前提を明示 | `pre-impl-reviewer` | `責務境界` | レビューでの気づき (優先度未判断) |
| 22 | main.instructions.md のフェーズフロー section の削除またはスリム化 | `main-instructions` | `重複削減` | レビューでの気づき (優先度未判断) |
| 23 | main.instructions.md の各フェーズの振る舞い section の skill 重複解消検討 | `main-instructions` | `重複削減` | レビューでの気づき (優先度未判断) |
| 24 | main.instructions.md 全体の skill 重複洗い出し / 必要なものへの絞り込み (章ごと + 全体) | `main-instructions` | `重複削減` | レビューでの気づき (優先度未判断) |
| 25 | (欠番、完了として削除 2026-05-17 — ふりかえり skill 本体は実装・リリース完了。開発中に出た派生課題は 45/46/47/48/49 として完全独立 TODO で追跡) | — | — | — |
| 26 | basic-design / define-requirements の末尾「/clear で次フェーズへ」案内の要否検討 | `define-requirements`, `basic-design` | `責務境界` | レビューでの気づき (優先度未判断) |
| 27 | E2E と対になる実装 skill の新設 (実装規約 + architecture を担う) | (新規) | `新規作成` | レビューでの気づき (優先度未判断) |
| 28 | define-requirements / basic-design と dialogue-principles の重複整理 | `dialogue-principles`, `define-requirements`, `basic-design` | `重複削減` | レビューでの気づき (優先度未判断) |
| 29 | (欠番、完了 2026-06-07 — e2e 薄型化で description から具体名を除去) | — | — | — |
| 30 | git-workflow skill の description から `gh` 不使用ルール言及を除去 (具体ツール名 NG) | `git-workflow` | `interface純化` | レビューでの気づき (優先度未判断) |
| 31 | git-workflow skill 本文から `.apm` / `apm compile` / consumer 等の APM 機構言及を除去 | `git-workflow` | `interface純化` | **優先度高** |
| 32 | slice-tdd skill の名前再検討 | `slice-tdd` | `interface純化` | **優先度高め** |
| 33 | (欠番、完了 2026-06-07 — slice-tdd の Playwright 記述を抽象表現に訂正) | — | — | — |
| 34 | slice-tdd skill の自走強化 (止まる条件の精査 + 相談用 subagent の検討) | `slice-tdd`, (新規 subagent) | `責務境界`, `新規作成` | レビューでの気づき、**Tier 1** (2026-05-23 「ユーザーに確認せず動く」目的で再駆動) |
| 35 | (欠番、TODO 53 で本実装。slice-tdd が実装 skill / E2E実行 skill を直接参照するため暫定指示は不要に) | — | — | — |
| 36 | (欠番、TODO 53 で消化。Skill tool 追加 + 名指し参照追従 + done-verifier / pre-impl-reviewer の preload only 明示まで実施) | — | — | — |
| 37 | story-slicing の呼び出し指示を define-requirements 側に移す (発火不全の仮説対応) | `define-requirements`, `story-slicing` | `責務境界` | レビューでの気づき (優先度未判断) |
| 38 | GitHub Actions で release notes 自動化 (CHANGELOG.md 廃止、conventional commits + tag から自動生成) | `harness-repo` | `リリース運用` | リリース運用、初回 tag 時に整備 |
| 39 | CODE_OF_CONDUCT.md の追加 (OSS 慣行) | `harness-repo` | `リリース運用` | 後回し可、PR / Issue が来始めた時 |
| 40 | SECURITY.md の追加 (将来必要になったら) | `harness-repo` | `リリース運用` | 実行可能コードが増えたら / 脆弱性報告が現実味を帯びたら |
| 41 | e2e SKILL.md 本文の「日本語名」表記を「natural language」に揃える | `e2e-skill` | `interface純化` | レビューでの気づき (description は更新済、本文未更新) |
| 42 | pre-implementation-reviewer を要件定義のみ段階でも呼べるよう description / 本文を明示改修 | `pre-impl-reviewer` | `interface純化`, `責務境界` | reviewer 実証で気づき (2026-05-15) |
| 43 | xp-harness 既存 skill の description を公式推奨 (200-300 字 / What+When / third person) に短縮 | (全 skill) | `interface純化` | 公式 best-practice 調査で気づき (2026-05-16) |
| 44 | (欠番、完了 2026-05-31 — PR #3 で `skill-reviewer` subagent を新設、`.claude/agents/` に稼働中) | — | — | — |
| 45 | ふりかえり skill 発火検知の既存 skill フック (運用結果次第で着手、main session の文脈判断で検知できないと判明したら) | `define-requirements`, `slice-tdd`, 他 | `機能拡張`, `責務境界` | ふりかえり skill basic-design で派生 (2026-05-17) |
| 46 | main instruction のフェーズフローに「ふりかえり」を追加 (運用結果次第で着手) | `main-instructions` | `機能拡張`, `構造改修` | ふりかえり skill basic-design で派生 (2026-05-17) |
| 47 | (欠番、完了 2026-05-31 — PR #3 で `skill-design-style` skill に移行、改修フロー手順 1〜7 で action リズム化を達成) | — | — | — |
| 48 | (欠番、取り下げ 2026-05-31 — PR #3 で hook 不採用を確定、subagent ペアプロ (`skill-reviewer`) で代替。philosophy 象限 3「hook 不採用方針」と整合) | — | — | — |
| 49 | (欠番、完了 2026-05-31 — PR #3 で skill 設計関連 4 section を `skill-design-style` に統合・整理) | — | — | — |
| 50 | 公開 OSS リポジトリへの内部固有名詞 leak 防止機構 (commit / push 前 check の責務をどこに置くか + 仕組み) | `done-verifier`, `harness-repo` | `機能拡張`, `責務境界`, `リリース運用` | ふりかえり skill 由来の内部フィードバックを公開反映する際に必要、**Tier 1** |
| 51 | define-requirements skill に Constraints (制約) を input/output 両面で追加 (引き出し手順 + md セクション) | `define-requirements` | `機能拡張`, `構造改修` | レビューでの気づき (2026-05-20)、**Tier 1** |
| 52 | リリース時に `latest` タグを更新する仕組み | `harness-repo` | `リリース運用` | レビューでの気づき (2026-05-23)、**Tier 1** |
| 53 | (欠番、完了 2026-05-31 — PR #5 MERGED。`implementation` / `e2e-execution` skill 新設、slice-tdd per-step 参照、reviewer の Skill tool 連携で TODO 36 も消化) | — | — | — |
| 54 | retrospective skill の改善 (= Step 1 「skill / subagent 使用分析」+ Step 3 「分析の honesty 監査」追加) | `retrospective` | `機能拡張`, `方法論導入` | ふりかえりで気づき (2026-05-24)、**Tier 1** (今回セッションで実証済) |
| 55 | (欠番、完了 2026-06-07 — e2e 薄型化で APM 機構言及ごと本文を置き換え) | — | — | — |
| 56 | xp-harness 自身を worktree で並行開発できる環境整備 (改修者 dogfooding) | `harness-repo`, `scripts/setup-dev.sh` | `自己適用` | 利用者向け git-workflow worktree 化が本丸、改修者側は派生として保留 |
| 57 | dialogue-principles の発火判定を「自走モードでない限り発火」に反転 | `dialogue-principles`, `main-instructions` | `責務境界`, `機能拡張` | ふりかえり由来 (2026-06-11)、**Tier 2** (通常の開発フローでは起きにくい) |

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

### 現在の Tier 1 (着手対象、7 件)

選定軸: **「改善サイクルを回せるもの」** + **設計負債で依頼者が明示的に高優先指定したもの** + **ふりかえり由来の改善 (利用者影響なし)** + **公開 OSS リポジトリ運用上の機密性配慮**。
Tier 2 / Tier 3 は未確定 (痛みが顕在化してから棚卸し)。

| ID | TODO | 系統 |
|---|---|---|
| 31 | git-workflow 本文 APM 言及除去 | 設計負債 (`優先度高`) |
| 32 | slice-tdd 名前再検討 | 設計負債 (`優先度高め`) |
| 34 | slice-tdd 自走強化 (止まる条件精査 + 相談 subagent) | 自走モード強化 (依頼者 Tier 1 指定、「ユーザーに確認せず動く」目的) |
| 50 | 公開 OSS リポジトリへの内部固有名詞 leak 防止機構 | 公開 OSS 運用 (ふりかえり由来の内部フィードバックを公開反映する際に必要) |
| 51 | define-requirements skill に Constraints (制約) input/output 両面追加 | 設計負債 (要件定義 skill の Constraints gap、依頼者 Tier 1 指定) |
| 52 | リリース時に `latest` タグを更新する仕組み | リリース運用 (依頼者 Tier 1 指定) |
| 54 | retrospective skill の改善 (「skill / subagent 使用分析」+「honesty 監査」) | ふりかえり由来 (2026-05-24 セッションで実証済、harness 内部品質改善) |

**47/48/49 は PR #3 で決着済み (2026-05-31)**: ふりかえり.md (`docs/working/retrospective-skill/ふりかえり.md`) の root cause 分析「規律を判断軸として持っているだけで具体 action / 強制チェックポイントが無い + 規律間の関係性が整理されていない」への複合対応として、47 (action リズム化) / 49 (section 整理) を `skill-design-style` skill への移行で達成、48 (hook 自動チェック) は hook 不採用方針に従い `skill-reviewer` subagent ペアプロで代替 (取り下げ)。詳細は各 TODO の欠番記録を参照。

**完了で削除したもの (2026-05-17、ID は欠番として保持)**:
- **TODO 1** (self-host): 一時対応 (`scripts/setup-dev.sh` + symlink) で十分。本格対応は痛みが見えてから新規 TODO で起こす
- **TODO 25** (ふりかえり skill 新設): skill 本体 (2026-05-17 リリース済) で完了。開発中に出た派生課題は 45/46/47/48/49 として完全独立 TODO で追跡

**完了 / 取り下げ (2026-05-31、ID は欠番として保持)**:
- **TODO 44** (skill-reviewer 新設): PR #3 で完了
- **TODO 47** (規律の action リズム化) / **TODO 49** (規律 section 整理): PR #3 で `skill-design-style` skill への移行・統合で完了
- **TODO 48** (skill 編集 hook 自動チェック): PR #3 で取り下げ (hook 不採用、`skill-reviewer` subagent で代替)
- **TODO 53** (実装 / E2E実行 skill 新設): PR #5 MERGED で完了 (TODO 36 も消化)

**完了 / 取り下げ (2026-06-07、ID は欠番として保持)** — 規約探索型スキルへの薄型化 (`docs/working/規約探索型スキルへの薄型化/`) で一括消化:
- **TODO 7** (e2e-reviewer の規約言及除去): reviewer 疎結合化 (preload した skill から観点を導出) で完了
- **TODO 8** (e2e の framework 中立化) / **TODO 29** (description の具体名除去) / **TODO 55** (APM 機構言及の除去): e2e skill の探索型薄型化で完了
- **TODO 9** (思想と実装の分離): 取り下げ。「テストは仕様書」は BDD 由来の流儀であり XP そのものの関心ではないため、思想ごと配布既定から外しプロジェクト側に委ねる判断に確定
- **TODO 19** (テスト独立性 section 統合): 取り下げ。疎結合化で対象 section 自体が消滅
- **TODO 33** (slice-tdd の Playwright 記述除去): 抽象表現への訂正で完了

**Tier 1 に上げなかった改善サイクル系項目**:
- **TODO 12** (skill TDD/eval 方法論) / **TODO 14** (philosophy loading 仕組み): 「明確な課題が見えたら着手」軸で Tier 3 残留。バージョニング機構があるので壊れることよりリリース速度を優先、かつコーディングエージェント向け TDD 方法論自体が業界で確立していないため、xp-harness が先に整備するコストが高い (2026-05-14 判断)。

各 TODO の詳細は以下のセクション参照。

---

## TODO 1: (欠番)

完了として削除 (2026-05-17)。一時対応 (`scripts/setup-dev.sh` + symlink) で改修者の dogfooding ニーズは満たされた。本格的な `apm install` self-host が必要になったら新規 TODO で起こす。

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

## TODO 7: (欠番)

完了として削除 (2026-06-07)。規約探索型スキルへの薄型化で e2e-reviewer を「preload した skill とその案内先から観点を導出する」疎結合構造に書き換え、e2e skill 規約への言及とプロジェクト固有値 (specs/ 等) を除去した。「preload skill が変わったときに e2e-reviewer の文言を直さなくて済む状態」を達成。

---

## TODO 8: (欠番)

完了として削除 (2026-06-07)。e2e skill を探索型に薄型化し、Playwright 前提 (API 名・流儀) を配布既定から除去した。流儀はプロジェクト側で定義し、skill は触る範囲から探して従う入口になった。

---

## TODO 9: (欠番)

取り下げ (2026-06-07)。規約探索型スキルへの薄型化で逆方向に確定: 「テストは仕様書」は BDD / Specification by Example 由来の流儀であり XP そのものの関心ではないため、思想ごと配布既定から外しプロジェクト側に委ねる。XP の受け入れテスト規律は define-requirements (観測可能な Done) と slice-tdd (E2E を錨にした outside-in) が担い続ける。詳細は `docs/working/規約探索型スキルへの薄型化/要件定義.md`。

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

### 具体手法の実績 (2026-05-25、TODO 53 検証で実践)

**headless consumer-repo eval** を実践した: テスト用 consumer repo (xp-harness を install + 上書き skill を配置) で `claude -p --output-format stream-json --verbose` を回し、出力 / セッション transcript を grep して「どの skill が Skill tool で発火したか / Read されたか / subagent が名指し skill を辿ったか」を観測。**distinctive な目印規約** (例: 公開関数名 `<layer>__` プレフィックス、実行コマンド名) を skill に仕込むと、それがコード / レビューに現れるかで「skill が実際に効いたか」を判定できる。これを eval 手法の土台にできる。

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

## TODO 19: (欠番)

取り下げ (2026-06-07)。e2e-reviewer の疎結合化でハードコード観点 (テスト独立性の 2 section を含む) 自体が消滅した。

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

## TODO 25: (欠番)

完了として削除 (2026-05-17)。`retrospective` skill 本体と `pre-implementation-reviewer` の要件段階対応 (TODO 42) を含めて実装・リリース完了。docs/working/retrospective-skill/ に要件定義 / 基本設計 / ふりかえり.md を残す。開発中に出た派生課題は 42 / 43 / 44 / 45 / 46 / 47 / 48 / 49 として完全独立 TODO で追跡。

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

## TODO 29: (欠番)

完了として削除 (2026-06-07)。e2e skill の薄型化で description を抽象表現に書き換え、Playwright / test.use / getByRole / page.locator を除去した。

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

## TODO 33: (欠番)

完了として削除 (2026-06-07)。slice-tdd の該当記述を「`e2e` skill が、触る範囲に対応するプロジェクトの E2E の流儀の探し方を持っている」へ訂正した。e2e-reviewer 呼び出し section の「仕様書として読めるか」「`specs/` 配下」も同時に訂正。

---

## TODO 34: slice-tdd skill の自走強化 (止まる条件精査 + 相談 subagent の検討)

### 状況

上位の目的は **「main session (= 実装フェーズの Agent) が、依頼者に逐一確認を取らずに動けるようにする」**。現状の slice-tdd skill では止まる条件が広く、依頼者の手を頻繁に止めてしまう。Tier 1 に昇格 (2026-05-23、「ユーザーに確認せず動く」目的で再駆動)。

#### 現状の課題 (= 止まる条件が広め)

`.apm/skills/slice-tdd/SKILL.md` L264 / L270-290 に「自走をやめて依頼者に確認する」条件が複数列挙されている (詰まったら / 設計 md と矛盾する判断 / 設計に無いケース / スコープが想定より大きい / destructive 操作 / 複数アプローチで選択ミスると痛い)。**自走モード前提では基本的に自分で解決してほしい**。現状のリストは止まる条件が広めで、自走の意図と合っていない可能性がある。

「対話と自走の境界」は xp-harness 中核思想の一つでもあるので、philosophy / dialogue-principles 系との整合も必要。

#### 検討する手段 (= 並列、両方検討 or どちらか)

- **手段 A: 止まる条件の精査** — slice-tdd skill 内の「依頼者に確認する」条件を 1 つずつ「自走で進む / 止まる」に再分類し、「進む」側に倒した条件には判断軸 (= 自走時に何を根拠に判断するか) を skill 内に書く
- **手段 B: 相談用 subagent の新設** — main session が「自分で判断するには情報不足だが、依頼者を止めるほどではない」場面で呼び出せる **相談用 subagent** を用意する。subagent が独立視点で判断材料を返し、main がそれを使って自走を継続できる構造にする。既存 reviewer subagent 群 (skill-reviewer / code-reviewer 等) の「3 用途」(改修後最終レビュー / 設計中の壁打ち / 判断に迷ったときの第三者視点) のうち、**「判断に迷ったとき」専門の subagent** という位置づけ

両手段は排他ではない。A だけで足りるか / B が必要か / 両方やるか は、再開時に検討する。

### 再開時の起点

1. 上位目的 (= ユーザーに確認せず動く) を再確認し、両手段が目的にどう寄与するかを propose-options で整理
2. **手段 A 着手**: L264 / L270-290 の各条件を一覧し、「自走モードで本当に止まるべきか / 自分で判断して進むべきか」を判定
3. 「止まる」と判定したものは止まる理由を強化、「進む」と判定したものは判断軸 (どう判断して何を選ぶか) を skill 内に書く
4. **手段 B 検討**: 相談用 subagent の責務範囲 / 既存 reviewer 群との切り分け / preload skill 構成 / 呼び出しタイミングを define-requirements で固める
5. philosophy skill / dialogue-principles skill の「対話と自走の境界」記述と整合を取る
6. destructive 操作は止まる側で固定 (これは harness 安全規律として動かさない)

---

## TODO 35: (欠番)

完了として削除 (2026-05-24)。TODO 53 で `implementation` / `e2e-execution` skill を本実装し、slice-tdd 本文がそれらを直接参照するようにしたため、暫定指示 (「実装関連 skill があれば参照」) は不要になった。

---

## TODO 36: code-reviewer / e2e-reviewer に skill 動的発見・適用機構を追加 (tools 宣言修正 + 本文指示追加)

> **完了 (2026-05-24、TODO 53 で消化、PR レビューで整理)**: code-reviewer / e2e-reviewer の `tools:` に `Skill` を追加 (preload 外 skill を名指し発火できる能力)。名指し参照の案内は呼ぶ側 (reviewer 本文) でなく skill 本文側に集約 (DRY。reviewer は preload で規約を取得し、本文の案内に従って Skill tool で辿る)。done-verifier / pre-implementation-reviewer は当初 preload only 明示も検討したが、`tools:` で自明なため見送り。subagent の名指し発火は公式仕様で確認済 (code.claude.com/docs/en/sub-agents 409-426 行)、かつ probe テスト + consumer headless run で **実機の発火を確認済**。以下は検討時の記録。

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

## TODO 42: pre-implementation-reviewer を要件定義のみ段階でも呼べるよう description / 本文を明示改修

### 状況

`.apm/agents/pre-implementation-reviewer.md` の description (L3) には「要件定義.md と 基本設計.md が書き終わった段階で...」と AND で書かれており、本文 (L14-16) でも「呼び出される時点で、`docs/working/<title>/` ディレクトリに以下が揃っている前提」と両方揃え前提が明示されている。

ROADMAP TODO 25 (ふりかえり skill 新設) の要件定義段階で「要件のみで呼べるか」を試験した結果、**prompt で「基本設計はまだない、要件レベルの観点に絞ってレビューしてほしい」と状況明示すれば agent は要件のみで通常通りレビュー可能** と実証された (2026-05-15)。

ただし素朴に呼んだ場合 (= 状況明示なし) は agent が「両方揃え前提」と書いてある description / 本文を読んで手探りになるリスクが残る。description / 本文に **「要件のみ段階」「要件 + 基本設計両方揃った段階」の両モード対応を明示** する改善余地がある。

### 再開時の起点

1. description / 本文に両モードを明示する文言を追加 (例: 「要件定義.md が書き終わった段階 (基本設計はまだ書いていない場合も可、その場合は要件レベルの観点に絞る) / または要件定義 + 基本設計が揃った段階で呼ぶ」)
2. 本文の「レビューの観点」section に「要件のみ段階で呼ばれた場合は『設計判断の妥当性 / アーキ / データモデル / シーケンス』をスキップ」を明示
3. ROADMAP TODO 25 のレビュー実例を参考に、要件のみで呼ぶときの prompt 規約 (or main session の呼び方規約) も整理
4. 他 subagent (`code-reviewer`, `e2e-reviewer`, `done-verifier`) でも「両方揃え前提」のような暗黙の呼び出し前提が無いか並行確認

---

## TODO 43: xp-harness 既存 skill の description を公式推奨に短縮

### 状況

ROADMAP TODO 25 (ふりかえり skill) の basic-design 議論で claude-code-guide が調査した結果、Claude Code 公式 (<https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices>) の description ベストプラクティスは:

- third person のみ
- What + When の 2 層構成
- Key use case を最初に置く (skill 数が増えると character budget で末尾が切られるため)
- 最大 1,024 字、実質 200-300 字推奨 (短いほど発火精度高い)
- 具体ツール / API 名を避ける (framework-agnostic)

一方、xp-harness 既存 skill の description は 500-900 字台で公式推奨レンジから外れている (例: `define-requirements`, `slice-tdd`, `git-workflow`)。「9 割の skill 発火失敗は description の品質」と公式が明示する重要 field なので、skill 数が増えるほど効いてくる負債。CLAUDE.md の「Description の書き方 (公式推奨)」section と整合する形で短縮。

### 再開時の起点

1. 全 skill (`.apm/skills/*/SKILL.md`) の description を grep で列挙、各字数を測定
2. 公式推奨レンジ (200-300 字) から外れる skill を優先順位付け
3. 1 skill ずつ description を書き直す: What + When の 2 層構成 / Key use case を最初 / 具体名除去 / third person
4. 短くした description で発火サインが落ちないか実セッションで観察
5. 必要に応じて `when_to_use` frontmatter field (Claude Code 固有) を併用

---

## TODO 44: skill 編集レビュー subagent (skill-reviewer 仮称) の新設

> **完了 (2026-05-31、PR #3)**: `skill-reviewer` subagent を `.claude/agents/` に新設。preload skill は `skill-design-style` + `dialogue-principles`、3 用途 (改修後の最終レビュー / 設計中の壁打ち / 第三者視点) を統合、severity スコアなしの日本語の文章で対応必要性を伝える。以下は検討時の記録。

### 状況

ROADMAP TODO 25 (ふりかえり skill) の basic-design 議論で、main session の Claude が要件 → description の変換を機械的にやり、How が description に紛れ込む失敗を起こした。CLAUDE.md に原則 3 (description は発火条件、本文は振る舞い) を書いた直後の出来事。

根本原因の振り返りで、メタ認知 (= 「これは推論を要するタスクだ」と気づく起動トリガー) が弱く、specific なルールを書くだけでは「ルーチン処理に流れる癖」を抑えられないと判明した。

当面は CLAUDE.md の「出力前に立ち止まる」section (meta-level の trigger) で対策。これで効くか、まずは観察する。

それでも同じ失敗が再発するようなら、本格対策として skill 編集の都度に外部レビューを入れる仕組み (= 自己 check 不足を外部チェックで構造的に補う) が要る。本 TODO はその参照点。

### 再開時の起点

1. 「出力前に立ち止まる」section だけで効いているかを観察する期間を持つ (= 同じ失敗が再発するか)
2. 再発するなら本 TODO に着手:
   - 新規 subagent (`skill-reviewer` 仮称) を `.apm/agents/` に作成
   - 責務: skill SKILL.md (description / 本文) を読んで、CLAUDE.md の「skill 設計の境界原則」「Description の書き方」「出力前に立ち止まる」の各 section と照合してレビュー
   - 呼び出しタイミング: skill 新規作成 / 改修の直後、main session が自動で呼ぶ (定義は呼ぶ側の skill に書く、TODO 37 と同じ構造)
3. 既存 reviewer subagent (`pre-implementation-reviewer` / `code-reviewer` / `e2e-reviewer`) との責務切り分けを明確化
4. xp-harness の他改修 (TODO 36 / 42 / 43 等) と並走するときの影響範囲を確認

---

## TODO 45: ふりかえり skill 発火検知の既存 skill フック

### 状況

ROADMAP TODO 25 (ふりかえり skill) の basic-design で、ふりかえり skill の発火検知は **「main session が context (会話履歴 / docs/working/<title>/要件定義.md 等) から『セッション内のすべてのストーリーが完了した』と判断する」段階的観測モデル** を採用した。既存 skill (`define-requirements` / `slice-tdd` / 他) には今回フックを入れない (= 要件のスコープ外 #6 と整合)。

ただし、実運用で main session の文脈判断が安定せず「拾い損ね / 早すぎる発火」が発生する場合、既存 skill にフックを入れる選択肢が残る。本 TODO はその参照点。

### 再開時の起点

1. ふりかえり skill 運用結果を観察、main session の文脈判断で十分か / 不十分かを評価
2. 不十分と判明したら、フック方式を検討:
   - `define-requirements` でストーリー一覧を明示的な data として書き出す
   - `slice-tdd` のサイクル完了時にストーリー Done をマークする
   - その他観測手段
3. 既存 skill の責務範囲を超えないか確認 (= フックが skill の責務を膨らませないか)

---

## TODO 46: main instruction のフェーズフローに「ふりかえり」を追加

### 状況

`.apm/instructions/main.instructions.md` のフェーズフロー section は現在 **要件定義 → 基本設計 → 実装** で、ふりかえりが含まれない。

ROADMAP TODO 25 (ふりかえり skill 新設) で skill 自体は追加するが、main instruction の「フェーズフロー」section は今回触らない (= 要件のスコープ外 #6 と整合)。

ただし、ふりかえり skill の description だけでは main session の発火が不安定で、フェーズフロー section に明示する方が発火しやすい場合は、本 TODO で追加する。

### 注意: TODO 22 / 23 / 24 との関係

TODO 22 (フェーズフロー section の削除 or スリム化) / TODO 23 (各フェーズ振る舞いの skill 重複解消) / TODO 24 (main.instructions.md 全体の skill 重複洗い出し) と **方向性が衝突する可能性**。スリム化 (= section を削る) と「ふりかえりを追加」(= section に項目を増やす) は対立する。本 TODO に着手する前に、TODO 22 / 23 / 24 の方針が固まっているか確認、調整が必要。

### 再開時の起点

1. ふりかえり skill 運用結果を観察、main の発火が安定しているか評価
2. 不安定と判明したら、main instruction の方針整理 (TODO 22 / 23 / 24) と並走させながら、フェーズフロー section に「ふりかえり」を追加する判断
3. 追加する場合の書き方: 既存「要件定義 → 基本設計 → 実装」に「→ ふりかえり」を 1 行追加、または別 section として独立

---

## TODO 47: CLAUDE.md の規律を「判断軸」から「具体 action リズム」に書き直す

> **完了 (2026-05-31、PR #3)**: CLAUDE.md の skill 設計関連 section を `skill-design-style` skill に移行し、改修フローを手順 1〜7 の具体 action として書き直した (= action リズム化を達成)。以下は検討時の記録。

### セット対応の位置づけ

TODO 47 / 48 / 49 は **セットで対応する 1 つの改善** として扱う。共通の root cause は「規律を判断軸として持っているだけで具体 action / 強制チェックポイントが無い + 規律間の関係性が整理されていない」(`docs/working/retrospective-skill/ふりかえり.md` の深掘り 1 参照)。利用者影響なしの harness 内部改善なので、3 つ揃ったタイミングで実装する。

### 状況

CLAUDE.md の skill 設計関連 section (「skill のメンタルモデル」「skill 設計の境界原則」「Description の書き方 (公式推奨)」「出力前に立ち止まる」) は **判断軸 / 観点 / 概念** として書かれており、具体的な action 手順 (= 「N. 〜する」「M. 〜する」のチェックリスト) になっていない。

TDD は「テスト先書き → 最小実装 → リファクタ → コミット」の action リズムが揃っており、概念名だけで動く強制力を持つ。一方 xp-harness の skill 設計規律は判断軸のみで、main session の自発的チェックに依存している。結果として skill 改修時に「機械的処理に流れて立ち止まれない」失敗が再発した (= ふりかえり.md の深掘り 1 で顕在化)。

### 再開時の起点

1. 対象 section を特定: CLAUDE.md の「skill のメンタルモデル」「skill 設計の境界原則」「Description の書き方」「出力前に立ち止まる」
2. 各 section を「具体的な action 手順」として書き直す案を出す。例: 「skill 改修時のチェックリスト: (a) これは load 前か load 後か / (b) description / 本文 のどちらに書くか / (c) 他文書で既出か / (d) 抽象化レベルは適切か」を順に通す手順
3. TODO 49 (CLAUDE.md 規律 section 整理) と並走させ、整理した後に action リズム化するのか / action リズム化しながら整理するのか順序を決める
4. TODO 48 (skill 編集 hook) と接続: action リズムをチェックリスト化できれば hook 側の自動チェック項目に転写しやすい

---

## TODO 48: skill 編集時の hook ベース自動チェック

> **取り下げ (2026-05-31、PR #3)**: hook 不採用方針 (philosophy 象限 3) に従い、機械的 hook ではなく `skill-reviewer` subagent ペアプロ (= 案 c) で代替することを確定。skill 改修フロー手順 6 で skill-reviewer を必ず通す形で規律化。以下は検討時の記録。

### セット対応の位置づけ

TODO 47 / 48 / 49 セット対応の一部 (= TODO 47 のチェックリストを hook で自動化、TODO 49 で整理された規律を hook の参照対象にする)。

### 状況

skill 編集時の規律違反 (description に具体名 / 本文に発火条件 / 既出情報の二重書き 等) を main session の自発チェックだけに任せると、機械的処理に流れて違反が混入する。CLAUDE.md の「skill 設計の境界原則」「Description の書き方」「出力前に立ち止まる」は **判断軸として存在するが強制力が無い**。

外から見る (= 外部から自動的に止まる仕組み) を 1 段噛ませて、main session の judgement が起動しない場面でも違反を捕捉する。ふりかえり.md の深掘り 1 「強制チェックポイント (= 外から見る) が必要」への対応。

### 取り得るアプローチ

- **案 a: file edit hook** (`.claude/settings.json` 等で `.apm/skills/*/SKILL.md` への Edit / Write 後にチェックスクリプトを起動)
- **案 b: pre-commit hook** (skill ファイル変更時に lint 走らせる)
- **案 c: subagent 必須化** (TODO 44 の skill 編集レビュー subagent を skill 編集後に自動で呼ぶ)
- **案 d: skill eval セット** (TODO 12 と接続、skill 発火が期待通りかを機械的検証)

a / b は機械的 lint で安く速い、c / d は判断系で重いが精度高い。組み合わせも候補。

### 再開時の起点

1. チェック対象を具体化 (TODO 47 のチェックリストが入力になる): description 字数 / third person / 具体名 ban list / 本文の APM 機構言及 ban list / 既出情報の重複 etc
2. 案 a〜d を propose-options で比較、コスト / 精度 / 守備範囲で選定
3. TODO 44 / 12 と責務分担を整理 (= 機械的 lint と subagent レビューと eval の境界)
4. 選定案で実装、最初は warning ベースで運用して誤検知を減らしてから enforce に上げる

---

## TODO 49: CLAUDE.md の規律 section の整理

> **完了 (2026-05-31、PR #3)**: 分散していた skill 設計関連 4 section (「skill のメンタルモデル」「境界原則」「Description の書き方」「出力前に立ち止まる」) を `skill-design-style` skill に統合・整理し、single source of truth 化した。以下は検討時の記録。

### セット対応の位置づけ

TODO 47 / 48 / 49 セット対応の一部 (= 整理した後に TODO 47 で action リズム化、TODO 48 の hook 参照対象を確定)。3 つの中では最初に着手する候補 (= 整理が終わってから action リズム化 / hook 化の方が手戻りが少ない)。

### 状況

CLAUDE.md には skill 設計関連の規律が複数 section に分散している:

- 「skill のメンタルモデル」(skill の構造 / 動作フロー / 判断軸)
- 「skill 設計の境界原則」(原則 1 / 2 / 3)
- 「Description の書き方 (公式推奨)」
- 「出力前に立ち止まる」

これらは独立 section として並んでおり、規律間の関係 / 優先順位 / 統合された全体像が見えにくい。個別判断時に「まずどの規律を適用するか」が曖昧で、選択コストが上がる (= ふりかえり.md の深掘り 1「規律の数が多すぎ / 規律間の関係が見えない」への対応)。

### 再開時の起点

1. 各 section の規律を粒度を揃えて列挙 (= 規律のフラットなリスト化)
2. 似た規律を統合 (= 重複 / 近接の merge): 例えば「description には具体名を入れない」が原則 1 と「Description の書き方」両方にあれば single source of truth に
3. 規律間の関係を 1 つの図 / マップで明示 (= どの判断ステップでどの規律が効くか、依存関係)
4. 効いていない規律を削除 (= ふりかえり.md / 実運用で 1 度も発火していない規律があれば候補)
5. 整理した結果を TODO 47 (action リズム化) と TODO 48 (hook 自動チェック) の入力にする

---

## TODO 50: 公開 OSS リポジトリへの内部固有名詞 leak 防止機構

### 状況

xp-harness には ふりかえり skill (`.apm/skills/retrospective/`) があり、 改修セッション内で得た内部フィードバック (= 社内の運用観察、 別 consumer プロジェクトでの利用経験、 関係者からの指摘等) を ROADMAP / skill / docs に反映するワークフローが存在する。

この **「内部フィードバック → 公開リポジトリへの反映」 のステップ** で、 内部 consumer プロジェクト名 / 顧客名 / 社内組織名等が意図せず公開 git 履歴に混入するリスクがある。 現状は改修者本人 / main session の注意力に依存しており、 構造的なガードがない。

公開リポジトリの git 履歴は force-push しない限り遡れるため、 一度 commit に入った固有名詞は実質永久に残る。 ふりかえり skill が活用されるほど内部 → 公開の翻訳機会が増えるため、 翻訳ステップでの leak 防止機構を予防的に整備したい。

### 検討中の選択肢 (要 propose-options)

- **案 A**: `done-verifier` の責務を拡張し、 公開 OSS リポジトリでは commit / push 前に内部固有名詞の grep check を追加する
  - メリ: 既存 push 前 pattern を活用、 agent 追加コストなし、 self-host で動く
  - デメ: done-verifier の責務 (テスト再実行 / build / TODO 残検出) が肥大化する懸念
- **案 B**: hook (例: pre-commit hook) で機械的に grep check
  - メリ: 安く確実に止まる、 main session 介さず動く
  - デメ: 検知対象リストの保守が必要、 hook が consumer 環境にも入ると誤検知の元
- **案 C**: 新規 leak-check agent
  - メリ: 責務単一化、 明確
  - デメ: agent overhead が単一観点には大きすぎる

### 再開時の起点

1. 案 A / B / C を propose-options skill フォーマットで詰める (依頼者と認識合わせ)
2. 「公開 OSS リポジトリ」 の判定方法を決める (= xp-harness 固有 ON か、 `git remote -v` 自動判定か、 consumer に配布する場合は opt-in 設定か)
3. 検知対象の表現方法を決める (= 既知固有名詞リストを改修者の手元 (= リポジトリ外) で管理 + 汎用ツール (`gitleaks` 等) 再利用も検討)
4. 案 A の場合: done-verifier の責務マップが肥大化しすぎないか責務境界を確認 (= TODO 6 「done-verifier interface 純化」 と接続)
5. 関連 TODO: TODO 48 (skill 編集 hook 自動チェック) と機構が近いので共通化可能か検討

---

## TODO 51: define-requirements skill に Constraints (制約) を input/output 両面で追加

### 状況

define-requirements skill は現状、Goal (= ユーザーストーリー + Why) と Acceptance (= Done) を明示的に引き出すが、Constraints (= 守るべき条件全般) を input/output 双方で扱えていない。

Constraints は技術的なものに限らず、以下を含む広い概念として扱う:
- **技術的**: 採用フレームワーク・ランタイムの制限 (例: Cloudflare Workers のサイズ上限、Vercel Functions の実行時間)、既存仕様との互換、依存ライブラリ
- **非機能**: 性能 (response time / throughput)、可用性、運用負荷
- **セキュリティ・コンプライアンス**: 認証認可、個人情報、業界規制 (GDPR / 個人情報保護法等)
- **コスト**: API 呼び出し料金、infra 料金、人件費の上限
- **期限・納期**: ローンチ日、業務上の deadline (月末締め等)
- **組織・社内ルール**: コーディング規約、承認フロー、利用可能なツール / SaaS の制限
- **リソース**: 人員、開発期間、利用可能な権限

現状のギャップ:
- **Input 側**: skill 本文「やること」(1〜5) に Constraints を引き出す項目がない。「依頼者が**技術的**制約を持ち出してきた場合は要件定義に影響するので議論する」(`.apm/skills/define-requirements/SKILL.md:149`) と受け身に一文あるだけで、しかも対象が技術的制約に narrow されている
- **Output 側**: 要件定義.md テンプレート (4 セクション: 背景と動機 / ユーザーストーリー / Done / スコープ外) に Constraints セクションがない

スコープ外と Constraints は性格が違う:
- **スコープ外**: 「今回はやらない、後でやるかも」(交渉可能な除外)
- **Constraints**: 「絶対に踏み外せないルール」(非交渉)

結果、依頼者が制約を持ち出しても md に書き起こされず、基本設計フェーズで再発見するか実装中に気付く構造になっている。

### 背景

Anthropic 公式が Opus 4.7 (賢くなった上位モデル) 向けに「**Goal / Constraints / Acceptance criteria** の 3 要素を最初に与えれば、その後は LLM が自律的に調査・対話で残りを埋める」というプロンプト書式を提示している。この 3 要素を要件定義 skill に反映させたい、というのが Tier 1 指定の根拠 (依頼者の意向、2026-05-20 レビュー)。

3 要素を要件定義 skill に当てると、Goal (= ユーザーストーリー + Why) と Acceptance (= Done) は既存の skill 構造でカバーされているが、**Constraints の取り扱いが input/output 両方で抜けている**ことが判明した。

「LLM への初期入力 (= 依頼者からの最初の合意点)」と「調べた結果の共有 md (= 要件定義.md)」は別物で、Constraints は両側に必要、という整理。

### 再開時の起点

1. Constraints を input 側 (skill 本文「やること」) で引き出す手順を追加
2. Output 側 (要件定義.md テンプレート) に Constraints セクションを追加
3. Constraints の例 (技術 / 非機能 / セキュリティ・コンプライアンス / コスト / 期限・納期 / 組織・社内ルール / リソース) を skill 本文に列挙し、**技術的制約に閉じないことを明示**
4. 既存の `SKILL.md:149` の「技術的制約」表現を Constraints 全般に書き換え (技術以外も漏らさない)
5. スコープ外と Constraints の区別を skill 本文で明示
6. 常設セクションにするか optional にするか方針を決める (該当なしのときの書き方も含む)
7. basic-design skill 側との cascade 整理 (関連: TODO 28 「define-requirements / basic-design と dialogue-principles の重複整理」)

---

## TODO 52: リリース時に `latest` タグを更新する仕組み

### 状況

上位の目的は **「consumer が install 時に最新版を簡単に取れる」**。具体的には APM などの package manager で `xp-harness@latest` のような書き方をしたら最新リリースが解決される、というシナリオを成立させたい。

第一歩 (= 検証手段) として **git tag `latest` を毎リリースで最新 commit に付け替える運用** を試す。`@latest` 解決が tag ベースで動くかを実際に確認し、足りない部分があれば次の手段 (= GitHub Release マーカー / APM 側の version 解決ロジック / その他) を順に検討する。

関連: TODO 38 (GitHub Actions で release notes 自動化) と同じ「リリース運用」系統だが独立 TODO。release notes 自動化と一緒に整備すると Action が共通化できる可能性。

### 再開時の起点

1. git tag `latest` の付け替え方式を決める (= リリース時に手動 `git tag -f latest <commit>` + `git push -f origin latest` で運用するか、GitHub Actions で自動化するか)
2. force push を伴うので運用ルールを整理 (= `latest` tag は常に最新を指す移動 tag、固定 tag (`v0.x.x`) と運用責務を切り分ける)
3. consumer 側で `xp-harness@latest` が期待通り解決されるかを実環境で検証
4. 解決されない場合の次手 (= GitHub Release の "Latest" マーカー / APM 側の version 解決ロジック改修 / その他) を propose-options で整理
5. 関連 TODO: TODO 38 (release notes 自動化) と並走する場合は Action を共通化できないか検討

---

## TODO 53: 実装 skill / E2E実行 skill を MVP で新設 + slice-tdd から参照案内追加

> **完了 (2026-05-31、PR #5 MERGED)**: branch `feat/impl-e2e-exec-skills`。要件定義 / 基本設計は `docs/working/実装スキル-e2e実行スキル新設/`。`implementation` / `e2e-execution` skill を新設、slice-tdd が各 TDD ステップで両者を**呼ぶ** (per-step: E2E 段で e2e-execution / Green 段で implementation。冒頭まとめだと後の段で忘れられると判明したため per-step に修正)、code-reviewer に implementation を preload + Skill tool、e2e-reviewer に Skill tool (TODO 36 消化)、README に登録。TODO 35 は欠番化。**検証**: consumer 検証 repo で headless 実行し、main が各段で implementation/e2e-execution/architecture を Skill 発火 + 初版から命名規約を満たす + subagent の Skill 自律発火を確認 (手法は TODO 12 参照)。補助ファイル付き skill での発火は未検証。

### 状況

上位の目的は **「コード実装と E2E 実行に関する project 固有規約を、consumer が project 側で書き入れる空間を確保する」**。MVP リリース優先で、xp-harness としては薄いデフォルトを置き、consumer が `.apm/` で project 固有規約に上書きする想定 (= 既存 e2e skill と同じ「上書き前提」パターン)。

#### 新設する 2 skill

- **実装 skill (= 名前 TBD: implementation / coding / coding-rules 等)**
  - デフォルト中身は薄め: 「他に類似する skill (= 業界既存の同種 skill / consumer の project 固有 skill) があれば参照する」案内
  - 1 つだけ具体方針: **コメントは基本書かない (= コードを綺麗にして名前で意図を伝える)、コメントは Why のみ OK**
  - consumer は project 固有のコード規約 / architecture を上書きで埋める想定
- **E2E実行 skill (= 名前 TBD: e2e-execution / e2e-runner 等)**
  - デフォルト中身は超薄め: 「他に類似する skill があれば参照する」案内のみ
  - consumer は project 固有の E2E 実行手順 (= 環境セットアップ / 実行コマンド / CI 統合 / 失敗時手順等) を上書きで埋める想定
  - 既存 `e2e` skill (= E2E spec 規約 / 仕様書性 / セレクタ / ヘルパー) とは別 skill、責務切り分け

#### slice-tdd skill への参照案内追加

slice-tdd skill 本文に「実装 skill / E2E実行 skill を参照する」指示を追加。

#### 既存 TODO との関係

- **「E2E と対になる実装 skill の新設 (規約 + architecture 込み)」(= 既存 TODO 27)**: 方向性は同じだが本格作り込み版。本 TODO 53 は MVP 版で、規約 / architecture の充実は TODO 27 で別途、または本 TODO 53 が育って吸収する可能性
- **「slice-tdd skill に『実装関連 skill があれば参照する』指示を追加」(= 既存 TODO 35)**: 本 TODO 53 が新 skill を本実装するので、TODO 35 の暫定指示は不要になる可能性 (= 後で整理)

### 再開時の起点

1. skill 名を確定 (= propose-options で議論)
2. 実装 skill の最低限 SKILL.md を作成 (= 他 skill 参照案内 + コメント方針、consumer 上書き前提を本文で明示)
3. E2E実行 skill の最低限 SKILL.md を作成 (= 他 skill 参照案内のみ、既存 e2e skill との責務切り分けを description で明確化)
4. slice-tdd skill 本文に「両 skill を参照する」指示を追加
5. consumer 上書きパターンを README / instruction でも明示 (= 既存 e2e skill の上書きパターンと整合)
6. 既存 TODO 27 / 35 の整理判断 (= 重複部分の統廃合、本 TODO 53 で吸収された部分の欠番化検討)

---

## TODO 54: retrospective skill の改善 (= 「skill / subagent 使用分析」サブ step 追加 + 「分析の honesty 監査」追加)

### 状況

2026-05-24 のふりかえりで retrospective skill 自体に 2 つの欠落が実証された。今回のセッションでこの 2 つを補強したら原因の言語化が大幅に深まったので、skill 本体に組み込む価値あり。

#### 「skill / subagent 使用分析」サブ step が Step 1 に無い

現状の Step 1 (= 情報収集) は「よかった点 / 伸びしろ」をフラットに出すだけで、**skill 選択 / subagent 利用の妥当性** を見る視点が無い。harness の主要価値レバーは skill と subagent の選択 / 起動 / タイミングなのに、ふりかえりがそこを見ないと表面の伸びしろしか拾えない。

確認すべき項目:

- 利用可能だった skill / subagent
- 明示発火 / 起動した skill / subagent
- 「必ず発火」と書いてあるのに発火しなかった skill、呼ぶべきタイミングで呼ばなかった subagent
- 順序ミス / タイミングミス
- 暗黙適用で済ませた skill

今回のセッションで「skill 使用分析」を入れたら、表面の伸びしろが「skill 順序問題の現れ」として再分類され、根本原因の言語化が進んだ。同じ視点を subagent (= code-reviewer / e2e-reviewer / pre-implementation-reviewer / done-verifier / skill-reviewer) にも当てる必要あり (= subagent は Opus コストもかかるので、呼んだ / 呼ばなかったの判断軸の妥当性確認は価値が高い)。

#### 「分析の honesty 監査」が Step 3 に無い

現状の Step 3 (= 深掘り分析) は「main session が自己分析を出す」と書いてあるが、その自己分析が **後付けで捏造された因果連鎖** でないかを検証する仕組みが無い。

今回のセッションで main session は「もっともらしい原因」を 3 つ並べ、user の指摘 (= 「それぞれ本当か?」) を受けて初めて捏造に気付いた。skill 側に「分析の honesty 監査」(= 検証できる事実と推測を分けて書け / 内部状態の主張は推測と明示せよ / 綺麗な因果図には捏造のサインを疑え) が組み込まれていれば、user の指摘無しでも 1 段深く降りられる可能性。

### 再開時の起点

1. retrospective skill 本文の Step 1 に「skill / subagent 使用分析」サブ step を追加 (= 利用可能だった / 明示発火・起動した / 必ず発火と書いてあるのに発火しなかった skill, 呼ぶべきタイミングで呼ばなかった subagent / 順序・タイミングミス / 暗黙適用、の項目)
2. retrospective skill 本文の Step 3 に「分析の honesty 監査」を追加 (= 検証できる事実と推測を分けて書け / 内部状態の主張は推測と明示せよ / 綺麗な因果図には捏造のサインを疑え)
3. 既存 Step との統合の仕方を判断 (= サブ step として明示分離 / 既存 Step 内で項目追加)
4. retrospective skill の使用例として、今回セッションのふりかえり内容を本文の例に書き加えるか判断

---

## TODO 55: (欠番)

完了として削除 (2026-06-07)。e2e skill の薄型化で本文を全面置き換えし、APM 機構言及も消滅した。TODO 31 (git-workflow 本文の APM 言及除去) は引き続き未対応。

---

## TODO 56: xp-harness 自身を worktree で並行開発できる環境整備 (改修者 dogfooding)

### 状況

「git-workflow worktree 化」案件 (`docs/working/git-workflow-worktree/`) の主成果は **利用者向け** (consumer に配る git-workflow skill を worktree 化し、任意プロジェクトで Claude = worktree 側 / ユーザー = メイン側の並行作業を成立させる)。本 TODO はその派生で、**xp-harness 自身を worktree で並行開発できるようにする改修者側 (dogfooding) の環境整備**。

spike (`docs/working/git-workflow-worktree/worktree-scope-spike-メモ.md` の section 5) で判明した固有事情:

- xp-harness の worktree を作ると、`.claude/skills/` には改修者向けの実体ディレクトリ (philosophy / release / skill-design-style 等) だけが来て、**consumer 向け skill / agent の symlink (git-workflow 等) は来ない** (`.gitignore` 非追跡のため)
- worktree 内で `scripts/setup-dev.sh` を再実行すると symlink が復旧する (相対 symlink が worktree 内で解決することは実測済)
- → xp-harness 自身を worktree で動かすなら「worktree 作成後に setup-dev.sh 再実行で symlink 復旧」のステップが要る

過去の TODO 1 (self-host、2026-05-17 完了削除「本格対応は痛みが見えてから新規 TODO で起こす」) の系譜にある dogfooding 案件。

### 再開時の起点

1. xp-harness を worktree で並行開発する運用フローを定義 (worktree 作成 → setup-dev.sh 再実行 → 並行作業)
2. setup-dev.sh 再実行を worktree セットアップに自動で織り込めるか検討 (手動ステップを減らす)
3. 利用者向け git-workflow worktree 化 (本丸) の設計が固まってから、その knowhow を改修者側にも適用するか判断

---

## TODO 57: dialogue-principles の発火判定を「自走モードでない限り発火」に反転

### 状況

`git-workflow-worktree` 案件のふりかえり (2026-06-11) で、セッション序盤に `dialogue-principles` を一度も発火させないまま要件対話を進め、複数論点を 1 メッセージに詰め込む違反を出した事象を深掘りした。根本原因は「**自走モード以外は全部対話**」という境界が main session に無く、`dialogue-principles` の発火を「議論っぽい場面か?」と入力の**表面の形**で毎回判定して取りこぼしたこと。

今回の入り口は「@ファイルを見て、なにをやりたいか書いてある? 書いてないなら教えて」という read & report の形で、中身は要件定義の入り口 (Why の所在を問う + 共創の合図) だったが、形で「作業」と分類して対話と認識しなかった。同じ「形で分類して中身を見ない」型がセッション内で反復した (README を grep 断片で「書いてある」と早合点、done-verifier を「push 前に直したい」で「両方承認」と拡大解釈)。

対処の方向: `dialogue-principles` の発火条件 (description) の判定の向きを、「対話の場面で発火」(形ベースの列挙) から「**自走モード (実装フェーズ = slice-tdd の責務範囲) に入っている時以外は対話として発火する**」(デフォルト ON / 例外 OFF) へ反転させる。要件定義・基本設計・レビュー共有・判断相談・ふりかえりは自走でない限りすべて対話、という二値の境界にすれば、形での誤分類の余地が消える。

優先度: 通常の開発フロー (実装フェーズ中心) では起きにくく、対話フェーズの入り口という限られた場面の取りこぼしなので **Tier 2**。常時 context への埋め込みは採らない (自走モードでは対話規律は不要で context の無駄かつ自走の邪魔。philosophy / skill-design-style とは性質が違う)。詳細な経緯は `docs/working/git-workflow-worktree/ふりかえり.md`。

### 再開時の起点

1. `dialogue-principles` の description を「自走モードでない限り発火」のデフォルト ON / 例外 OFF の境界で書き直す (具体文言を詰める)
2. `main.instructions.md` の「議論・対話を進める場面で必ず dialogue-principles を発火」「違和感を感じたら再読」の記述と整合を取る (形ベースの判定を促す表現が残っていないか点検)
3. 「形で分類して中身を見ない」を一般原則として philosophy に昇格させるかは見送り済み (抽象規律は効きが不確かで規律装置最小注入に反する)。今回は発火境界の修正に閉じる

---

## このファイルの保守

新規 TODO を追加するときは、各項目に以下を含める:

- **状況**: 何の機能 / 改善か (1-2 段落)
- **再開時の起点**: 何から始めるか (具体的な action 1-3 個)

完了したら削除 or 「完了済」セクションに移す。優先順位は実運用での痛み・採用度・コストで都度見直し。
