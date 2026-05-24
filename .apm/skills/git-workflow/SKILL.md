---
description: |
  コード変更を伴う依頼 / セッション開始 / Git 操作の話題、いずれかに該当したら他より先に必ず最初に使う skill。

  (1) コード変更を伴う依頼: 機能追加・バグ修正・UI 調整・リファクタ・CSV / 帳票 / ロジック修正など、ファイルを 1 行でも書き換える前に。「〜したい / 〜直したい / 〜追加したい / 〜整えてほしい / 〜変えたい」など Git に無関係に見える依頼でも例外なし。

  (2) セッション開始 / 作業再開: `/clear` 直後、新セッション最初のメッセージ、「今日もよろしく」「何から始めよう」「前回の続き」「戻ってきた」「状況把握から」など具体タスクが固まっていない場面でも必ず発火。

  (3) Git 操作の話題: branch 作成・命名、pull / rebase、conflict 解決、push、PR 作成依頼、remote 同期確認、commit リズム、`gh` 不使用ルール。

  役割: 現 branch / remote 同期 / working tree の確認、新 branch 提案、push 規律、`gh` 禁止、consumer 自前 instruction での部分上書き対応。

  発火しない: コードを読むだけの info 質問、Git / tool の概念学習質問、doc のサマリ依頼。
---

# Git Workflow — branch 運用と Git 操作規律

## なぜこの skill があるか

開発タスクの開始から push まで、Git 操作はあらゆる skill の context で発生する。各 skill に Git ルールを重複させると DRY 違反になり、project 固有の override も難しい。

この skill は Git 運用全般のデフォルト動作と override 機構を 1 か所に集約する。各 skill は自分の責務に集中し、Git 操作はこの skill に従う。

## 中核哲学

- **守備範囲は `git push` まで**: PR 作成・merge は依頼者の責務。あなたが PR を立てたり merge したりしてはいけない
- **branch 運用がデフォルト**: 新規 task は branch を切ってから進める (高頻度 commit / push が安全に成立する前提)
- **Project 固有ルールで override 可能**: trunk-based 開発など、現場ルールが違えば consumer の自前 instruction (`.apm/instructions/<own>-git-rules.md` 等) が優先

## セッション開始時の同期確認

新セッション / `/clear` 直後 / user の最初の依頼を処理する前に必ず実行:

1. `git fetch origin` — 副作用なし、必ず最初に叩く（remote の差分が見えるだけ）
2. `git branch --show-current` — 現 branch
3. `git status` — working tree
4. `git log --oneline origin/main..main main..origin/main` — 同期差分

`git status` の "up to date with origin/main" は前回 fetch 時点での比較。**fetch しないと古い情報のまま** "up to date" を返すので信用できない。fetch を先に叩く理由はそこ。

### 結果を user に簡潔に共有

確認結果を 1 メッセージにまとめる:

- 現 branch
- remote との同期状況 (N commit ahead / behind / 同期済)
- modified の有無
- untracked のサマリー (件数 + 代表的なファイル名、長ければ "他 N 件")

### state を変える git 操作 (pull / checkout / rebase / merge) の前に手元を整理する

remote が進んでいて pull したい場合、**手元を先に整理する**。理由:

- pull で conflict 起きたら resolve が面倒
- `git pull --autostash` などで逃がすと stash の履歴が残らず、戻すのが大変
- 履歴に残る形（commit）か、意図ある形（明示 stash + 名前）にしておくと事故ったとき復旧できる

具体的な振る舞い:

- **modified ファイルあり** → user に提案: commit する (推奨) / `git stash push -m "<intent>"` で明示 stash する / どちらか
- **untracked のみ** → サマリー報告だけして pull に進んで OK（untracked は通常 pull に影響しない）
- **remote と同期済** → そのまま元依頼に進む

整理が終わってから pull、その後元依頼に進む。

## ブランチ運用 (デフォルト動作)

branch 作成判断は **必ず `AskUserQuestion` ツールで選択肢を提示**して、user の affirmative な選択を取る。チャットで「〜で切ります、違ったら教えてください」のように書いて即 `checkout -b` するのは禁止 — 沈黙を同意と扱うと、user が想定しない branch / タイミング / base から branch ができて事故る。**`auto mode` でも例外なし** (branch 作成は routine decision ではなく state-changing operation)。

### セッション開始時 — 現 branch にかかわらず必ず確認

新セッション / `/clear` 直後の同期確認 (上記 §セッション開始時の同期確認) の後、必ず `AskUserQuestion` を出す。**別 branch にいるからといって skip しない** — 前 session の続きか / 新 task か / 違うことやりたいか、user に確認しないと事故る (過去の作業途中の branch にそのまま積み増してしまう、等)。

main / master にいる場合の例:

```
question: "main にいます。この session どう進めますか？"
header:   "Branch"
options:
  - "提案名 `feat/<inferred>` で新 branch 切る (推奨) "
    description: "rebase pull で main 最新化してから新 branch 作成"
  - "そのまま main で作業"
    description: "branch 切らず続行 (commit / push 注意)"
  - "違う branch 名で切る"
    description: "選んだら branch 名をチャットで教えてください"
```

別 branch にいる場合の例:

```
question: "現 `<branch>` にいます。この session どう進めますか？"
header:   "Branch"
options:
  - "そのまま `<branch>` の作業を続ける"
    description: "前 session の続き"
  - "新 branch を切る (新 task)"
    description: "違う task を始める。提案名: `feat/<inferred>`"
  - "違う branch 名で切る"
    description: "選んだら branch 名をチャットで教えてください"
```

「違う branch 名で切る」が選ばれたら、チャットで branch 名を聞く。

### セッション中の task 切り替え

セッション中に user が新 task を切り出したとき:

- **main / master にいる場合**: 同じ AskUserQuestion パターンで提案 (上記の main 用)
- **すでに別 branch にいる場合**: 何もしない (user の意図を尊重、現 branch で続行)

### branch 名の生成

依頼の core から推測する。規約:

- prefix: `feat/` (新機能)、`fix/` (バグ修正)、`chore/` (定型作業)、`docs/` (文書)、`refactor/` (リファクタ)
- 名前: 依頼の core を English ケバブケース、5-7 単語以内
- 例: `feat/dialogue-principles`、`fix/login-redirect`、`refactor/extract-validators`

### State を変える git 操作も同じ規律

branch 作成だけでなく **pull / checkout / rebase / merge / push / cherry-pick / force push** など state を変える操作も、user の affirmative な選択を取ってから実行する。沈黙 / 「違ったら言って」形式は禁止。

## Push リズム

- commit は高頻度 OK (TDD サイクル毎の commit は実装 skill の責務)
- push は最終形に到達してから (push 前 done-verifier 通過必須)
- push したら依頼者に以下を伝える:

```
push 完了 (branch: <branch-name>)
PR 作成は依頼者にお願いします。
```

## 一般 Git 規律

### `gh` コマンドは使わない

明示的に `git` CLI を使う。`gh` は入っていない環境もあり、認証や引数で失敗することが多い。挙動の安定性を優先して `git` で統一。

例:
- ✗ `gh pr create ...` (やらない)
- ✗ `gh pr view ...` (やらない)
- ✓ `git push origin <branch>`
- ✓ `git log --oneline`
- ✓ `git diff main...HEAD`

### コーディングエージェントの system prompt 上書き

多くのコーディングエージェントの system prompt は「commit は明示依頼まで作らない」がデフォルト。**このプロジェクトでは上記ルールで override する** (project の CLAUDE.md と skill が system prompt のデフォルトより優先)。「commit は user の依頼を待つべきでは」と迷ったら、この明示ルールが上書きしていることを思い出す。

## Project 固有ルールでの上書き

Project 固有の Git 運用ルール (branch protected、commit message 規約、push 禁止 branch、trunk-based 開発など) は、consumer 側の自前 instruction (`.apm/instructions/<own>-git-rules.md` 等) に書く。`apm compile` で CLAUDE.md に bundle され、git-workflow skill は CLAUDE.md の該当 section を読んで動作を切り替える。

**書かれた部分だけ上書き、書かれていない部分はこの skill の既定動作に従う** (部分上書きが標準)。

例: consumer の `.apm/instructions/git-rules.md` に「ブランチ戦略」だけ書かれていれば、ブランチ戦略は project ルール、commit / push / 一般規律はこの skill の既定で動く。

consumer がより強い override (skill 全体を再定義) を必要とする場合は、APM の last-installed-wins 機構 (`.apm/skills/git-workflow/SKILL.md` を consumer 側で書く) も技術的に可能。ただし harness update への追従負担が増える trade-off があるため、標準では推奨しない。

## 動作しないとき

- 「protected branch かどうか」の判定が曖昧 → user に確認 (例: develop は protected か?)
- branch 作成中に conflict → user に状況を共有してから判断 (rebase 続行 / abort / 別アプローチ)
- push に失敗 → 原因を user に伝えてから対処 (黙って force push しない、destructive 操作は明示確認)
