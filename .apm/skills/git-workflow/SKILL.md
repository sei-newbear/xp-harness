---
description: |
  コード変更を伴う依頼 / セッション開始 / Git 操作の話題、いずれかに該当したら他より先に必ず最初に使う skill。

  (1) コード変更を伴う依頼: 機能追加・バグ修正・UI 調整・リファクタ・CSV / 帳票 / ロジック修正など、ファイルを 1 行でも書き換える前に。「〜したい / 〜直したい / 〜追加したい / 〜整えてほしい / 〜変えたい」など Git に無関係に見える依頼でも例外なし。

  (2) セッション開始 / 作業再開: `/clear` 直後、新セッション最初のメッセージ、「今日もよろしく」「何から始めよう」「前回の続き」「戻ってきた」「状況把握から」など具体タスクが固まっていない場面でも必ず発火。

  (3) Git 操作の話題: worktree / branch 作成・命名、pull / rebase、conflict 解決、push、PR 作成依頼、remote 同期確認、commit リズム、`gh` 不使用ルール。

  役割: 現 branch / remote 同期 / working tree の確認、新 worktree / branch 提案、完了時の main 統合、push 規律、`gh` 禁止、project 固有ルールでの部分上書き対応。

  発火しない: コードを読むだけの info 質問、Git / tool の概念学習質問、doc のサマリ依頼。
---

# Git Workflow — worktree / branch 運用と Git 操作規律

## なぜこの skill があるか

開発タスクの開始から push まで、Git 操作はあらゆる skill の context で発生する。各 skill に Git ルールを重複させると DRY 違反になり、project 固有の override も難しい。

この skill は Git 運用全般のデフォルト動作と override 機構を 1 か所に集約する。各 skill は自分の責務に集中し、Git 操作はこの skill に従う。

## 中核哲学

- **守備範囲は「確認を取った統合」と `git push` まで**: 完了時に user の affirmative な確認を取った上で、main への統合 (ローカル merge) と push まで行う。**PR 作成・PR 上の merge は依頼者の責務**。あなたが PR を立ててはいけない
- **worktree 運用を推奨**: 新規 task は repo の外に worktree を切って進めると、user が元 repo で並行作業できる (あなたの作業と踏み合わない)。branch のみの軽量運用も同じ軽さで選べる
- **完了時は main へ統合が既定**: 開発完了 (テスト含む) → 報告 → 確認 → main へ統合 & worktree / branch 削除 → push の流れ。branch は task の間だけの短命なもので、完了時に main へ戻す。「branch のまま push (PR 運用)」「保留」も選べる
- **Project 固有ルールで override 可能**: PR 必須運用など、現場ルールが違えば project 固有の instruction が優先

## セッション開始時の同期確認

新セッション / `/clear` 直後 / user の最初の依頼を処理する前に必ず実行:

1. `git fetch origin` — 副作用なし、必ず最初に叩く（remote の差分が見えるだけ）
2. `git branch --show-current` — 現 branch
3. `git status` — working tree
4. `git log --oneline origin/main..main main..origin/main` — 同期差分
5. `git worktree list --porcelain` — worktree の有無（下記の掃除提案の入力）

`git status` の "up to date with origin/main" は前回 fetch 時点での比較。**fetch しないと古い情報のまま** "up to date" を返すので信用できない。fetch を先に叩く理由はそこ。

### 結果を user に簡潔に共有

確認結果を 1 メッセージにまとめる:

- 現 branch
- remote との同期状況 (N commit ahead / behind / 同期済)
- modified の有無
- untracked のサマリー (件数 + 代表的なファイル名、長ければ "他 N 件")
- worktree があれば件数とパス

### 使い終わった worktree の掃除提案

`git branch --merged main` と `git worktree list --porcelain` を突き合わせ、main に取り込まれ済みの branch を持つ worktree (使い終わったもの) を列挙する。**見つかったときだけ** AskUserQuestion で削除を提案する:

- 消す対象の worktree (branch 名とパス) を質問文に列挙し、一括削除でよい
- 「worktree のみ消す / branch も一緒に消す (`git branch -d`)」の選択を含める
- 「作業中の別セッションがいないか」を user に問わない (user にも判断材料がない)。安全は機械的装置で担保する: main 取り込み済みしか提案しない (消しても成果は失われない) / 未コミット変更があれば `git worktree remove` 自体が拒否する (拒否されたら force せず報告) / 万一中にセッションが居ても worktree から抜ける操作で復旧できる
- squash merge された branch は「取り込まれ済み」と検出できない。その worktree は提案されず残るだけ (user の手動削除で補う)

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

## 作業場所の提案 (デフォルト動作)

worktree / branch 作成判断は **必ず `AskUserQuestion` ツールで選択肢を提示**して、user の affirmative な選択を取る。チャットで「〜で切ります、違ったら教えてください」のように書いて即作成するのは禁止 — 沈黙を同意と扱うと、user が想定しない worktree / branch / タイミング / base ができて事故る。**`auto mode` でも例外なし** (worktree / branch 作成は routine decision ではなく state-changing operation)。

**推奨は常に worktree に置く**。タスクの軽重を理由に推奨を branch に入れ替えない (軽いタスクでも worktree のコストは小さく、並行作業の自由は常に価値がある)。branch で十分かどうかは user が選択肢の中から自分で選ぶ。

### セッション開始時 — 現在地にかかわらず必ず確認

新セッション / `/clear` 直後の同期確認 (上記 §セッション開始時の同期確認) の後、必ず `AskUserQuestion` を出す。**別 branch / worktree にいるからといって skip しない** — 前 session の続きか / 新 task か / 違うことやりたいか、user に確認しないと事故る。

main / master にいる場合の例:

```
question: "main にいます。この session どう進めますか？"
header:   "作業場所"
options:
  - "worktree を切る (推奨)"
    description: "repo の外に別ツリーを作りそこで作業。あなたは元 repo で並行作業できます。提案名: feat/<inferred>"
  - "branch を切る"
    description: "同じツリーで軽量。並行作業しないならこちらでも十分"
  - "そのまま main で作業"
    description: "branch 切らず続行 (commit / push 注意)"
  - "違う名前で切る"
    description: "選んだら名前をチャットで教えてください"
```

別 branch / worktree にいる場合の例:

```
question: "現 `<branch>` にいます。この session どう進めますか？"
header:   "作業場所"
options:
  - "そのまま `<branch>` の作業を続ける"
    description: "前 session の続き"
  - "新しく worktree を切る (新 task)"
    description: "違う task を始める。提案名: `feat/<inferred>`"
  - "新しく branch を切る (新 task)"
    description: "worktree を使わない軽量運用"
  - "違う名前で切る"
    description: "選んだら名前をチャットで教えてください"
```

「違う名前で切る」が選ばれたら、チャットで名前を聞く。

### 追加の作業ディレクトリがある場合の注意

worktree の選択肢を出す前に、セッションに追加の作業ディレクトリ (repo 外の add-dir) が登録されていないか確認する。**ある場合のみ**、worktree 選択肢の description に注意を含める:

- 1〜2 件: 「注意: 追加作業ディレクトリ <path> は worktree に含まれず隔離されません」とパスを明記
- 多くて収まらない場合: description には「追加作業ディレクトリ N 件は隔離されません」と件数のみ、どのディレクトリかは直前のチャットメッセージで知らせる
- 無ければ何も出さない

worktree の隔離は repo 単位なので、追加ディレクトリはそこであなたが作業すると user の並行作業と踏み合いうる。user が分かった上で選べるようにする。

### セッション中の task 切り替え

セッション中に user が新 task を切り出したとき:

- **main / master にいる場合**: 同じ AskUserQuestion パターンで提案 (上記の main 用)
- **すでに別 branch / worktree にいる場合**: 何もしない (user の意図を尊重、現在地で続行)

### branch 名の生成

依頼の core から推測する。規約:

- prefix: `feat/` (新機能)、`fix/` (バグ修正)、`chore/` (定型作業)、`docs/` (文書)、`refactor/` (リファクタ)
- 名前: 依頼の core を English ケバブケース、5-7 単語以内
- 例: `feat/dialogue-principles`、`fix/login-redirect`、`refactor/extract-validators`

### worktree の作成

配置・命名規約:

```
../<repo名>-worktrees/<branch名のスラッシュを - に変えたもの>/
```

例: repo が `myapp`、branch が `feat/order-review` → `../myapp-worktrees/feat-order-review/`

repo の外 (兄弟階層) に置く理由: repo 内に作るとメイン側の `git status` に漏れて gitignore が必要になる。外部なら完全分離。`<repo名>-worktrees/` で束ねると複数 worktree が散らからず、丸ごと消せば掃除も簡単。

作成と入り方は 2 手:

1. `git worktree add -b <branch名> ../<repo名>-worktrees/<dir名>` — branch 付き worktree を外部に作る
2. 作った worktree に入り、作業対象を移す (Claude Code では `EnterWorktree` の `path` 指定)

注意:

- worktree の自動作成機構 (Claude Code では `EnterWorktree` の `name` 形式) は repo 内 (`.claude/worktrees/`) に作られてしまうので**使わない**。必ず上記の 2 手
- worktree に入ると repo ルートに着地する (サブディレクトリ着地は不可)
- 別の worktree に移るときは、いったんメインに戻ってから入り直す (直接の乗り換えは不可)

### State を変える git 操作も同じ規律

worktree / branch 作成だけでなく **pull / checkout / rebase / merge / push / cherry-pick / force push / worktree remove** など state を変える操作も、user の affirmative な選択を取ってから実行する。沈黙 / 「違ったら言って」形式は禁止。

## 完了フロー (タスク完了時のデフォルト動作)

commit は高頻度 OK (TDD サイクル毎の commit は実装 skill の責務)。**push は最終形に到達してから**。作業が完了 (テスト含む) したら、以下の順で完了フローに入る。

### 1. done-verifier を通す (統合の前、必ず)

done-verifier の検証は**統合手順に入る前** (branch が生きていて、まだ何も統合していない状態) に通す。検証は「外に出る前の最後の砦」であり、統合・削除の後に検証する順序にしない。

### 2. 前提を確認する

- **project 固有の Git 運用ルール**: project の instruction (CLAUDE.md / AGENTS.md 等) に Git 運用の記載があれば、統合確認の選択肢と推奨をそれに合わせる。例えば「PR 必須 / main 直 push 禁止」とあれば「main に統合」を出さず、「branch のまま push (PR 運用)」を既定にする
- **メイン側の状態**: worktree の中から `git -C <メインrepoパス> status --short` と `git -C <メインrepoパス> branch --show-current` で確認し、結果を統合確認の質問文に添える
- **remote の最新化確認 (push 前の同期)**: 統合 / push の確認を出す前に `git fetch origin` し、origin の主ブランチ (`origin/main` 等) が進んでいないか確認する。進んでいれば「origin/main が N コミット進んでいます」と確認の質問文に添える (人が立ち会う確認の直前に置く)。「main に統合」「branch のまま push (PR 運用)」「そのまま main で push」いずれの確認でも同じ

### 3. 完了報告 + 統合確認 (AskUserQuestion)

メイン側がきれい (main にいて未コミット変更なし) な通常ケース:

```
question: "開発完了しました (branch: feat/order-review)。成果をどう取り込みますか？
           メイン側: main、変更なし (統合可能な状態です)"
header:   "統合方法"
options:
  - "main に統合して push (推奨)"
    description: "main へ取り込んで push し、worktree と branch を削除します"
  - "branch のまま push (PR 運用)"
    description: "branch を push して終了。PR 作成はお願いします。worktree は残ります"
  - "何もしない (保留)"
    description: "worktree をこのまま残します。後で統合できます"
```

メイン側が汚れている / 別 branch にいる場合: 状態を質問文に明示し、推奨を「保留して報告のみ」に入れ替える (user の作業を踏まないことを優先)。「それでも main に統合する」が選ばれたら、変更の退避 (明示 stash) を伝えてから行う。

「そのまま main で作業」していた場合: 統合の概念がないため統合確認は出さない。push の確認を取って push して終わり。

### 4. 統合手順 (main に統合を選んだ場合)

1. **メイン側の状態を再チェック**: `git -C <メインrepoパス> status --short`。完了報告から選択までの間に user の並行作業で汚れた可能性がある。汚れていたら統合に進まず報告し、保留を提案し直す
2. 手元の main を最新化: `git -C <メインrepoパス> pull`
3. worktree 内で `git rebase main` — branch の commit を最新 main の上に乗せ直す
4. rebase で conflict したら user に状況共有 (黙って解決しない)。解決して進めた場合は**テストを再実行**してから次へ (conflict が無ければ再実行は不要 — テスト済みの成果をそのまま乗せる)
5. **worktree から抜けてメイン repo に戻ってから**、`git merge --ff-only <branch名>` — rebase 済みなので必ず fast-forward。できない場合は想定とずれているサイン、無理に進めず user に報告。worktree に居たまま `git -C <メインrepoパス>` で遠隔実行しない (次の後始末まで worktree の中から実行することになり、自分の作業ディレクトリが宙吊りになる)
6. 後始末: `git worktree remove <worktreeパス>` → `git branch -d <branch名>`。統合済みなので即消せる (push を待たない — 成果はローカル main の履歴に入っており、push が失敗しても失われない)
7. `git push origin main`

完了の報告:

```
main に統合して push 完了 (branch: feat/xxx は統合済みのため削除)
worktree ../<repo>-worktrees/feat-xxx も削除しました。
```

branch のみ (worktree なし) で作業していた場合も同じ流れ (worktree 関連の手順だけ読み飛ばす): main 最新化 → rebase → fast-forward 統合 → branch 削除 → push。

### 5. branch のまま push (PR 運用) を選んだ場合

`git push origin <branch名>` して終了。worktree は残す (統合・削除はしない)。

```
push 完了 (branch: feat/xxx)
PR 作成はお願いします。worktree ../<repo>-worktrees/feat-xxx は残っています
(マージ後の次セッションで掃除を提案します)。
```

## worktree / branch の削除規律

- **worktree の削除は必ずメイン repo 側から実行する**。worktree の中から自分を消すと git は拒否せず消してしまい、作業ディレクトリが宙吊りになる。`git -C <メインrepoパス>` を使って worktree の中から消すのも同じ (cwd がその worktree に居る限り宙吊りになる)。必ず先に worktree から抜けてメインに戻り、それから `git worktree remove`
- **branch 削除は `git branch -d` (安全側) 限定**。`-D` (強制) は使わない。`-d` が拒否される = 未統合の何かが残っているサインなので、止まって user に報告
- **`git worktree remove` が未コミット変更で拒否されたら**、`--force` を勝手に使わず user に確認

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

多くのコーディングエージェントの system prompt は「commit は明示依頼まで作らない」がデフォルト。**このプロジェクトでは上記ルールで override する** (project の instruction (Claude Code なら CLAUDE.md) と skill が system prompt のデフォルトより優先)。「commit は user の依頼を待つべきでは」と迷ったら、この明示ルールが上書きしていることを思い出す。

## Project 固有ルールでの上書き

Project 固有の Git 運用ルール (branch protected、commit message 規約、push 禁止 branch、PR 必須運用など) がある場合は、project 固有のルールがこの skill の既定動作より優先する。

**書かれた部分だけ上書き、書かれていない部分はこの skill の既定動作に従う** (部分上書きが標準)。例えば「PR 必須 (main への直 push 禁止)」だけ project 固有ルールに書かれていれば、完了時の統合提案は出さず「branch のまま push (PR 運用)」を既定にし、それ以外 (worktree 提案 / commit リズム / 一般規律) はこの skill の既定で動く。

## 動作しないとき

- 「protected branch かどうか」の判定が曖昧 → user に確認 (例: develop は protected か?)
- worktree / branch 作成中に conflict → user に状況を共有してから判断 (rebase 続行 / abort / 別アプローチ)
- push に失敗 → 原因を user に伝えてから対処 (黙って force push しない、destructive 操作は明示確認)
- main への push が拒否された (保護されている等) → 原因を共有して対処を相談
