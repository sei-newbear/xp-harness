# xp-harness — このリポジトリで作業するときの working rules

このファイルは **xp-harness 本体を改修するとき** に守るべき改修者向け instruction。consumer に配布される skill / instruction ではない (= project root の `CLAUDE.md` は consumer 配布対象外)。

---

## 依頼者の真のゴール (= 改修者の方向性)

改修者が「やりたいこと」を伝えたら、main session (= コーディング Agent、現時点では Claude Code 等) が xp-harness の harness 機構 (= skill / CLAUDE.md / subagent) に適切に落とし込めるよう、**ある程度自走して任せられる状態** を実現する。

改修者が都度説明しないと整理できない状態が続くと、`.apm/` 配下 (= 利用者向け本題) の改修が全く進まない。本リポジトリの改修者向け装置 (= 本 `CLAUDE.md` / `.claude/skills/philosophy/` / `.claude/skills/skill-design-style/` / `.claude/agents/skill-reviewer.md`) はすべて、その自走を支えるためのもの。

---

## xp-harness の中核思想

- **規律装置最小注入**: 規律は最小限の文書で注入する。重複させない、肥大化させない
- **ペアプロ哲学**: 機械的なチェックよりも subagent / 改修者によるペアプロでの捕捉が筋
- **decentralized**: 規律 / 責務は分散して持つ、1 箇所に集約しすぎない
- **harness 機構の E2E テスト枠組みは未確立** → harness 改修の Done は事前縛り最小化、事後評価許容
- **投資フェーズの仕組み作り** では運用コスト最適化より価値命題の充実を優先

詳細な中核思想は `.claude/skills/philosophy/SKILL.md` に集約。常時 context に乗せる:

@.claude/skills/philosophy/SKILL.md

詳細な規律 / 判断軸 / 改修フローは `.claude/skills/skill-design-style/SKILL.md` に集約されている (= 下記の埋め込み参照を参照)。

---

## スコープ境界の判別 (= 利用者向け vs 改修者向け)

xp-harness は OSS として skill / agent / instruction を配布する harness。改修対象が「利用者向け」か「改修者向け」かを必ず判別する。

| カテゴリ | パス | 配布 |
|---|---|---|
| **利用者向け** | `.apm/skills/*` / `.apm/agents/*` / `.apm/instructions/*` および `.claude/` 配下の対応 symlink (= `.apm/` と同じ実体) | APM 経由で配布 |
| **改修者向け** | `CLAUDE.md` (project root) / `.claude/skills/philosophy/` / `.claude/skills/release/` / `.claude/skills/skill-design-style/` / `.claude/agents/skill-reviewer.md` (= それぞれ git tracked、symlink でない) | 非配布 |

判別法: `ls -la` で symlink でないことを確認。symlink なら `.apm/` 配下と同じものなので利用者向け、symlink でなく直接コミットされていれば改修者向け。

新規 skill / agent を改修者向けで作るときは、必ず `.claude/` 配下に直接コミット (= `.apm/` には置かない)。philosophy skill / skill-design-style / skill-reviewer と同じパターン。

---

## 機械的処理に流れる失敗の認識 (= 方向性)

main session (= 改修者の役) が **機械的処理に流れる失敗** は、改修品質を直接損なう。「これはルーチン作業」「決まったパターンの繰り返し」と分類した瞬間に **立ち止まる**。

具体的な自己観察項目 (= 自分の発想軸 / 確認 skip / 省略 / 英語混じり / 即同意 / 機械的処理 の 6 項目) は `skill-design-style` skill 本文に集約されている。対話の場面では `dialogue-principles` skill にも同じ規律が書かれている (= 対話時の core)。skill / agent 改修と対話は同時に起きるので、両方の skill を併用する。

---

## skill 設計の流儀 (= `skill-design-style` skill に集約)

skill / agent (`.apm/skills/<name>/SKILL.md` / `.apm/agents/<name>.md` / `.claude/skills/<name>/SKILL.md` / `.claude/agents/<name>.md`) を新規作成・改修するときの規律 / 判断軸 / 改修フローは、`.claude/skills/skill-design-style/SKILL.md` に集約されている。改修時は必ずこの skill を発火させる (= description の発火条件で自動発火する設計)。

含む内容:

- skill / agent の構造 (= 2 層構造、動作フロー)
- 境界原則 3 つ (= description は interface / 本文は consumer 展開後も自然 / 発火条件と振る舞いを混ぜない)
- description の書き方 (= 公式推奨、third person / What+When / Key use case 最初 / 文字数推奨)
- 出力前に立ち止まる (= 機械的処理に流れる失敗の認識)
- skill 改修フロー (= 4 軸判断 → 構造踏まえる → 境界原則 → description → 立ち止まる → skill-reviewer に通す → 対話なら dialogue-principles)
- 既存 reviewer subagent との責務切り分け

@.claude/skills/skill-design-style/SKILL.md

---

## skill-reviewer (= 改修フローのペアプロ相手)

skill / agent の改修後は、必ず `skill-reviewer` subagent をペアプロ相手として呼ぶ。skill-reviewer は skill-design-style と dialogue-principles を preload skill として読み込み、その規律 / 判断軸に照らしてレビューする。出力は severity スコアなしの日本語の文章で、対応必要性を文脈で伝える。

呼ぶタイミングと 3 用途 (= 改修後の最終レビュー / 設計中の壁打ち / 判断に迷ったときの第三者視点) の詳細は `.claude/skills/skill-design-style/SKILL.md` の「skill-reviewer の使い方」section を参照 (= main session は skill-design-style 発火中に本文 load 済)。

---

## git-workflow の改修者向け上書き

xp-harness の改修者環境では、`git-workflow` skill (= 配布側 skill) の以下のデフォルトを **上書き** する (= project の CLAUDE.md が skill のデフォルトより優先、`git-workflow` skill 本文の「Project 固有ルールでの上書き」section と整合):

- **`gh` コマンドの使用を許容する** (= デフォルトの「`gh` 不使用」を上書き)。改修者環境では `gh` がある前提
- **Push / PR 作成は依頼者に確認を取ってから動く**。改修者 Agent が Push / PR 作成まで無断で自走しない。「Push してよいか」「PR 作成してよいか」を依頼者に確認してから実行する

この上書きは改修者向けのみ (= 本 `CLAUDE.md` は consumer 配布対象外)。配布側 skill (`.apm/skills/git-workflow/SKILL.md`) のデフォルトは変えず、consumer 環境では従来通り「PR 作成は依頼者の責務」「`gh` 不使用」が効く。

---

## Main instruction の取り込み (= self-host / dogfooding)

xp-harness 本体の main instruction (= consumer に配信される運用ルール) を改修者環境でも有効にするため、起動時に取り込む。改修者は `.apm/instructions/main.instructions.md` を直接編集すれば、Claude Code を再起動するだけで反映される (= build step なし)。

`.apm/skills/` の各 skill と `.apm/agents/` の各 subagent は `scripts/setup-dev.sh` が `.claude/skills/<x>` / `.claude/agents/<x>.md` への symlink を作って認識させる。以下は **symlink でなく直接 git tracked** で対象外:

- `.claude/skills/philosophy/` (= 中核思想 skill、改修者向け)
- `.claude/skills/release/` (= リリース手順 skill、改修者向け)
- `.claude/skills/skill-design-style/` (= skill 設計の流儀、改修者向け)
- `.claude/agents/skill-reviewer.md` (= skill レビュー subagent、改修者向け)

@.apm/instructions/main.instructions.md
