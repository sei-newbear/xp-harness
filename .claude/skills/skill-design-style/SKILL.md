---
description: xp-harness の skill / agent に関する作業 (新規作成 / 設計 / 改修 等) で必ず発火させる、skill 設計の流儀 (構造 / 境界原則 / description の書き方) と判断軸。
---

# skill 設計の流儀 — skill / agent の新規作成・改修時の流儀

## なぜこの skill があるか

xp-harness の harness 機構 (= skill / agent / CLAUDE.md) を改修者が改修するとき、規律 / 判断軸 / 改修フローが散在していると、改修者 (main session) が機械的処理に流れて失敗する。本 skill は改修者向けの規律 / 判断軸 / 改修フローを単一の出典 (= single source) として集約する。

## 中核哲学 (= 改修者の方向性)

### 依頼者の真のゴール: 自走

改修者が「やりたいこと」を伝えたら、main session (コーディング Agent) が harness 機構に適切に落とし込めるよう、ある程度自走して任せられる状態を実現する。本 skill はその自走を支える規律集。

「依頼者から都度説明を受けないと整理できない」状態を解消し、`.apm/` 配下 (= 利用者向け本題) の改修を進められる状態にする。

### xp-harness の中核思想

- **規律装置最小注入**: 規律は最小限の文書で注入する。重複させない、肥大化させない
- **ペアプロ哲学**: 機械的なチェックよりも subagent / 改修者によるペアプロでの捕捉が筋
- **単一責任 (= SRP)**: 各 skill / agent / instruction は単一の責任を持つ

### harness 機構の E2E テスト枠組みは未確立

skill / CLAUDE.md / subagent の harness 機構には E2E テスト枠組みが未確立。改修の Done は事前縛りを最小化し、事後評価を許容する。投資フェーズの仕組み作りでは、運用コスト最適化より価値命題の充実を優先する。

### subagent はペアプロ的な第三者として 3 用途

reviewer 系の subagent (code-reviewer / e2e-reviewer / pre-implementation-reviewer / done-verifier / skill-reviewer) は、強制 gate ではなくペアプロの相手としての第三者:

- **改修後の最終レビュー** (= 必須)
- **設計中の壁打ち / 議論** (= 任意・対話的、何度でも)
- **判断に迷ったときの第三者視点** (= 任意、依頼者に確認する前のステップとして気軽に呼ぶ)

## スコープ境界の判別 (= 利用者向け vs 改修者向け)

xp-harness は OSS として skill / agent / instruction を配布する harness。改修対象が「利用者向け」か「改修者向け」かを必ず判別する。

| カテゴリ | パス | 配布 | 改修方針 |
|---|---|---|---|
| **利用者向け** | `.apm/skills/*` / `.apm/agents/*` / `.apm/instructions/*` および `.claude/` 配下の対応 symlink (= `.apm/` と同じ実体) | APM 経由で配布 | 慎重に、scope 外なら触らない |
| **改修者向け** | `CLAUDE.md` (project root) / `.claude/skills/philosophy/` / `.claude/skills/release/` / `.claude/skills/skill-design-style/` / `.claude/agents/skill-reviewer.md` (それぞれ git tracked、symlink でない) | 非配布 | philosophy skill と同じパターン、`.claude/` 配下に直接コミット |

判別法: `ls -la` で symlink でないことを確認。symlink なら `.apm/` 配下と同じものなので利用者向け、symlink でなく直接コミットされていれば改修者向け。

新規 skill / agent を改修者向けで作るときは、必ず `.claude/` 配下に直接コミット (= `.apm/` には置かない)。

## skill 改修フロー (= 改修者が読んで自走する手順)

skill / agent を新規作成・改修するときは、以下の手順を順に通す。

### 手順 1: 何を / どこに書くか判断 (= 4 軸で位置づける)

skill / description / 本文 / 要件定義.md / 他 skill / CLAUDE.md のどこに書くべきか、以下 4 軸で位置づける:

1. **いつ読まれるか**
   - 常時 context に乗る: CLAUDE.md / 全 skill の description / main instruction
   - 発火時読み込み: skill 本文 / reviewer agent の本文
   - 特定タスクで参照: `docs/working/<title>/要件定義.md`, `基本設計.md`
2. **誰が読むか**
   - main session (Claude) / reviewer agent / 改修者 / consumer
3. **既出か**
   - 他文書で既に書いてあるなら、重複させない (= 二重課金 / 内容のずれリスク回避)
4. **抽象化レベル**
   - 抽象 (= 何をするか / 発火条件 / interface): description / 要件
   - 具象 (= どう振る舞うか / 実装): 本文 / 基本設計

4 軸で位置づけてから書く。一つでも答えに詰まったら、書く場所を再考する。

### 手順 2: skill / agent の構造を踏まえる

skill / agent は 2 層構造:

- **frontmatter (interface 層)**: `name` / `description` / その他 metadata。常時 context に乗り、main session が「この skill を呼ぶか」を判断するための signal。抽象表現で書く
- **本文 (実装層)**: SKILL.md の Markdown 部分。skill 発火時に読み込まれ、main session が呼ばれた後どう振る舞うかをガイドする。具体表現で書く

skill 全体は「interface + 実装」のセット。「skill = description」「skill = 本文」のいずれかと同視するのは取り違え。

#### skill の動作フロー (= 時系列)

1. **起動時**: Claude Code 起動時に、全 skill の frontmatter が main session の context に metadata として読み込まれる。skill 本文はまだ読み込まれない
2. **判断時**: main session が会話文脈から「ある skill の description にマッチする状況」と認識したら、その skill を呼ぶか判断する
3. **(任意) 提案時**: 場合により main が依頼者に「やりますか?」と提案する (= 自発的に促す skill のパターン)。この時点で skill 本文はまだ読み込まれていない
4. **発火時**: main session が skill 本文を読み込む (依頼者の承認 or 自動)
5. **振る舞い時**: main session が本文の指示に従って動く
6. **完了時**: skill タスクが終わり、main session が次のタスクに移る

「呼ばれる前」と「呼ばれた後」を区別する: 起動 / 判断 / 提案 は呼ばれる前 (= description が効く)、発火 / 振る舞い / 完了 は呼ばれた後 (= 本文が効く)。

### 手順 3: 境界原則に沿う

skill / agent を作る・改修するときの境界原則。

#### 原則 1: skill の frontmatter `description` は interface — 具体の話 / 内部情報を入れない

- description は呼び出し側 (main session) に対する interface。発火条件と責務を抽象レベルで宣言する場所
- NG 例:
  - **具体名**: framework 名 (`Playwright`, `Cypress`)、API 名 (`getByRole`, `test.use`, `page.locator`)、ツール名 (`gh`, `gh cli` 等)
  - **配布・管理の内部情報**: 「CLAUDE.md から参照される」「規律 source として機能する」「consumer 配布対象外」「改修者向け」等 (= main session は判断時に知る必要なし)
  - **他 skill / agent との連携詳細**: 「skill-reviewer に preload される」「dialogue-principles を参照」等 (= interface 層で他 skill への依存を明示しない、連携詳細は本文で書く)
  - **冗長表現**: 「集約する」「扱う」「提供する」等、skill 自体を再説明する語彙 (= skill はそもそも集約したもの、頭痛が痛い)
  - **本質外の補足**: 別 skill に集約された規律を再掲しない (= 例: 「出力前に立ち止まる」が他 skill に集約されているなら description に書かない、重複)
- OK 例: 一般概念 (E2E テスト、commit、branch、push、pull、rebase、conflict 等 — エコシステム共通の語彙)、その skill の核となる責務 (= What) と発火タイミング (= When)
- 判断軸: 「main session が『この skill を呼ぶか』判断するために必要な情報か」を毎回問う。配布・管理・連携・冗長表現は不要

#### 原則 2: skill 本文は展開後 (consumer の `.claude/skills/` 等に deploy された状態) でも自然に読めること

- skill が APM 経由で consumer に配布されると、`.apm/` / `apm compile` / consumer といった APM 機構の語彙はもはや関係なくなる
- NG 例: `.apm/instructions/<x>.md`, `apm compile`, "consumer の自前 instruction", "last-installed-wins 機構" のような APM 機構固有の言及を skill 本文に直書きすること
- 正しい場所: APM 機構の話は README / apm.yml / APM 側 instruction (`.apm/instructions/`) に書く。skill 本文は APM 非依存の汎用表現で書く
- override の話を skill 本文に残したいなら「project 固有のルールで override 可能 (override 方法はインストール先 agent の仕様に従う)」程度の抽象表現にとどめる

#### 原則 3: description は発火条件、本文は発火後の振る舞いを書く

- skill の発火は Claude Code の skill 機構によって決まる: frontmatter `description` を main session が読み、文脈にマッチしたら skill 本文が読み込まれる。発火を決めるのは description であって、本文ではない
- 本文は発火後の振る舞いガイド: skill が呼ばれた後の対話進行・規律・成果物の書式などを書く場所
- NG 例: 「main session がいつ skill を呼ぶか」「どの観測サインで呼ぶか」のような発火条件を本文側に書く。逆に「発火後の対話手順」「成果物の書式」を description 側に書く
- 判断軸: 「これは skill が呼ばれる前に効く話か (= description)、呼ばれた後に効く話か (= 本文)」を区別する

#### 原則 4: 他 skill を参照させるときは「効く場所」で「呼ぶ」

skill 本文から別の skill を使わせるときの 2 点 (実装 / E2E実行 skill の検証で確立):

- **置き場所**: その skill が効く具体的な手順 (TDD の各ステップ等) に案内を置く。冒頭のまとめ section に置くと、skill 発火時に 1 回消費されて後の段で忘れられる (実証: slice-tdd 冒頭に「実装規約を呼べ」と置いたら、直後の E2E 段の skill は発火したが、後の実装段の skill が再トリガーされず漏れた)
- **動詞**: 「参照する」でなく「**呼ぶ**」と書く。「参照」は main にファイルを Read させ、skill の補助ファイルを取りこぼす。「呼ぶ」は skill として発火させ、補助ファイルも含めて効かせる (subagent でも Skill tool で名指し skill を発火できることは検証済)

### 手順 4: description / name の書き方 (公式推奨)

skill の frontmatter `description` は「9 割の skill 発火失敗は description の品質に起因」(Claude Code 公式) と言われる重要 field。以下を守る:

- third person のみ (「I can」「You can」禁止)
- What (何をするか) + When (いつ使うか) の 2 層構成
- Key use case (What) を最初に置く (= skill 数が増えると character budget で末尾が切られるため)
- 最大 1,024 字、実質 200-300 字推奨 (= 短いほど発火精度高い)
- 具体ツール / API 名を避ける (= 原則 1 と整合): framework 非依存な表現で書く
- description が短く済まない場合、`when_to_use` frontmatter field を使う選択肢もある (Claude Code 固有)

`name` フィールドの扱い (= 公式 docs に基づく):

- **skill** (`.apm/skills/<dir>/SKILL.md` / `.claude/skills/<dir>/SKILL.md`): `name` は **省略する** (= ディレクトリ名がデフォルトで使われる、明示は重複管理になる)
- **subagent** (`.apm/agents/<file>.md` / `.claude/agents/<file>.md`): `name` は **必須** (= 公式 docs で required、ファイル名と一致させる必要はないが明示する)

Good 例:

    description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data.

Bad 例:

    description: Use openpyxl to process spreadsheets

参考: <https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices>

### 手順 5: 出力前に立ち止まる (機械的処理に流されない)

skill / description / 本文 / 要件 → description の変換などを書くとき、出力前に必ず立ち止まる:

- 要件 → description の変換は **抽象化作業**。機械的にコピーしない (= 要件は具体を含むのが正しい、description は抽象が正しい、性質が違う)
- 各文を「これは抽象か / 具体な How か」「description に書くか / 本文に書くか」と都度問う
- 既存例 (xp-harness 既存 skill 等) の見た目に引っ張られない。ルールが先、例は参考
- 「ルーチン作業」と分類しそうな瞬間こそ要注意 (= そこで推論を起動する)

#### 機械的処理に流れる失敗の認識 (= dialogue-principles に集約)

「これはルーチン作業」「決まったパターンの繰り返し」と分類した瞬間に立ち止まる。具体的な自己観察項目 (= 省略しない / 英語混じり禁止 / 即同意しない / 別角度から発想する / 機械的処理に流れない の 5 項目) は dialogue-principles skill 本文の「出力の規律」section に集約されている。

skill 改修中も対話と同じ規律が効くので、dialogue-principles を必ず参照する (= 重複させない、single source として dialogue-principles を読む)。

### 手順 6: skill-reviewer に必ず通す (= 改修後の最終レビュー)

skill / agent の改修が一段落したら、**必ず skill-reviewer を呼ぶ** (= 改修フローの最後の step として規律化、呼び忘れない)。skill-reviewer は本 skill (skill-design-style) を preload skill として context に注入された状態で動き、改修内容を規律に照らしてレビューする。

出力フォーマットは日本語の文章 (= severity スコアなし、対応必要性は文章の文脈で伝える)。

### skill-reviewer の使い方 (= main session 向け、3 用途)

skill 設計 / 改修フェーズ中に skill-reviewer を呼ぶタイミングは 3 用途。手順 6 (= 改修後の最終レビュー、必須) に加えて、設計中も任意で呼べる:

- **改修後の最終レビュー** (= 必須): 改修が一段落したら呼ぶ。手順 6 で規律化されている (= 呼び忘れない)
- **設計中の壁打ち / 議論** (= 任意・対話的): 設計中に「これでいいか」を skill-reviewer に壁打ちする。何度かやり取りしてよい
- **判断に迷ったときの第三者視点** (= 任意): main session が依頼者に確認する前に、skill-reviewer に独立視点を取りに行く (= 依頼者の作業時間を圧迫しない)

呼ばれたときの skill-reviewer の振る舞い詳細 (= 各用途で何をするか) は skill-reviewer 本文の「3 用途の使い分け」section を参照 (= subagent 自身の context、main session は直接読まないが、skill-reviewer が用途別に振る舞う前提)。

### 手順 7: 対話する場面では dialogue-principles を読む

skill / agent 改修中に依頼者と対話・議論する場面が出る。対話の規律は dialogue-principles skill に集約されている (= 省略しない / 番号で参照しない / 英語混じり禁止 / 即同意しない / 別角度から発想する / 機械的処理に流れない)。

skill 改修と対話は同時に起きるので、両方の skill を併用する: skill-design-style (= 本 skill) + dialogue-principles。

