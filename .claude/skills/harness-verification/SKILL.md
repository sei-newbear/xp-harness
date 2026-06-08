---
description: xp-harness の skill / subagent の改修が実際に効いているか (発火するか・意図どおり振る舞うか) を、sandbox 環境での実走と transcript 解析で事実確認する検証手順。skill / subagent を改修した後に動作検証したいとき、「検証したい」「発火するか確かめたい」と言われたときに発火させる。発火・振る舞いの事実確認に限定 (良し悪しの測定・評価・ベンチマークはしない)。
---

# harness 検証 — skill / subagent の発火・振る舞いの事実確認

## なぜこの skill があるか

skill / subagent を改修しても、それが実際に発火するか・意図どおり振る舞うかは transcript を観測しないと分からない。この検証のやり方 (sandbox の作り方、起動の仕方、transcript の場所と解析方法) はノウハウの塊で、skill 化しないと検証のたびにゼロから再発明することになる。

ここで言うのは「検証」= 仕組みが意図どおり動いたかの事実確認 (起きた / 起きていないの二値)。「評価」= 出来の良し悪しの測定 (スコアリング・比較) は扱わない。

## 検証の構造 (全部これの同型)

**状態を仕込む → 改修者が Claude Code を起動して走らせる → transcript を解析して発火・振る舞いを観測 → 後片付け**

仕込む状態の大きさが検証の目的で変わるだけ。skill の連鎖発火だけならプローブ一式、実フェーズの振る舞いなら要件定義・基本設計 md を置いた途中状態を仕込む。

## 鉄則: 自分で headless 起動しない

**`claude -p` を自分で叩かない** (2026-06-15 から従量課金)。検証セッションの起動は必ず改修者にやってもらう。あなたの仕事は「起動ディレクトリ」と「貼り付け用プロンプト」を提示し、走り終わった transcript を解析すること。

## 手順

### 1. 検証目的を確認する

どの skill / subagent の、どの発火・振る舞いを確認したいかを特定する。確認したい事実を先に言語化する (例:「main が slice-tdd を Skill tool で発火するか」「code-reviewer が preload された skill の指示で動くか」)。目的が曖昧なまま走らせると、transcript を見ても判定できない。

### 2. 状態を仕込む

**sandbox の用意** — 新規に作るなら:

```bash
.claude/skills/harness-verification/scripts/setup-sandbox.sh <名前>          # 既定: front/api 分離の Web アプリ構成
.claude/skills/harness-verification/scripts/setup-sandbox.sh <名前> --bare   # 最小構成 (git repo + apm install のみ)
```

`<xp-harness の親ディレクトリ>/xp-harness-test/<名前>/` に git repo + apm install 済の sandbox ができる (改修中の xp-harness をローカル依存で deploy)。既存 sandbox の使い回しでよいかは改修者と判断する。**改修内容を sandbox に反映するには、改修を commit してから sandbox で `apm install` し直す** (apm はローカル依存でも git の内容を見る)。

既定の構成は front (Vite + React) / api (Hono) / e2e (Playwright、webServer で両サーバ自動起動、スモーク spec つき) の分離構成で、探索型スキル (implementation / e2e / e2e-execution) が探し当てる先として以下を同梱する:

- **領域別スキル**: `front-implementation` / `api-implementation`。わざと対照的な規約 (front: interface のみ + コメント禁止、api: type のみ + JSDoc 必須) にしてあり、領域をまたぐ実装で規約の混線が起きたか grep で観測できる (例: api 配下に `interface` が出たら混線)
- **front E2E 流儀スキル**: `e2e-playwright-front` (探索の「スキルなら呼ぶ」枝の対象)
- **実行手順ドキュメント**: `e2e/README.md` (探索の「スキルでないファイルは読む」枝の対象)

同梱スキルは配布物ではなく、consumer プロジェクトが持つ固有スキルの形を模した検証材料 (配布側の e2e skill と sync させる対象ではない)。「検証材料である」という注記を template 側の SKILL.md に書かないのは意図的 — sandbox に複製されて検証セッション自身が読むため、観測を汚す。同梱スキルが探索型スキルに実際に探し当てられるかは検証ランで観測して確定する (同形の構成で探索発火・混線ゼロの実績あり)。

プローブによる連鎖発火確認などアプリが不要な検証は `--bare` で安く作る。

**途中状態の仕込み** — 目的に応じて選ぶ:

- skill の連鎖発火だけ安く確認したい (preload → Skill tool 呼び出しの連鎖など):

  ```bash
  .claude/skills/harness-verification/scripts/setup-probe.sh <sandbox パス>
  ```

  合言葉 `PROBE_TARGET_FIRED_OK` を出させるプローブ一式 (検証用 subagent + skill 2 つ) が配置される。配置内容と起動プロンプト例はスクリプトが出力する

- 実フェーズの発火・振る舞いを確認したい (実装フェーズで slice-tdd → implementation → reviewer の流れ等): sandbox の `docs/working/<title>/` に要件定義.md・基本設計.md を置き、「実装フェーズの続き」という途中状態を作る。md はこの main session が書いてよい (ここはコストがかからない)

### 3. 改修者に起動してもらう

起動ディレクトリと貼り付け用プロンプトをセットで提示する。形式:

```
検証の準備ができました。以下で検証セッションを起動してください:

  cd <sandbox パス> && claude

起動したら、このプロンプトを貼ってください:

  <検証目的に合わせたプロンプト>

走り終わったら教えてください。transcript を解析します。
```

プロンプトには「どの状態から始まるか」(例: docs/working/<title>/ に要件定義.md と基本設計.md がある、実装フェーズの続き) と「自走してよい範囲」(branch 作成の承認等、確認で止まらないための前置き) を含める。

### 4. transcript を解析する

```bash
.claude/skills/harness-verification/scripts/analyze-session.py <sandbox パス>
```

最新セッションの発火事実 (main の Skill 発火・subagent 起動の時系列、各 subagent 内の Skill 発火、SKILL.md を Read しただけのケース) が一覧で出る。`--list` でセッション一覧、`--session <ID>` で指定、`--grep <文字列>` で合言葉等の出現確認。

読むときの観点:

- **Skill tool で発火したか、Read で済まされたか**: SKILL.md を Read しただけの場合、補助ファイルを取りこぼす失敗モード。⚠ 表示が出たら発火失敗を疑う
- **main と subagent のどちらが呼んだか**: 「subagent に発火させたい skill を main が読んでしまった」は別物。出力の section 分けで区別できる
- **期待した振る舞いの痕跡**: 確認したい事実 (手順 1 で言語化したもの) が transcript 上で観測できたか。コマンド実行の痕跡は `--grep` や sandbox の `git status` / `git diff` (初期 commit との差分) でも観測できる
- **出力に出ないことは「起きなかった」と断定しない**: スクリプトは主要な事実だけ抽出する。疑わしいときは transcript (`~/.claude/projects/` 配下の jsonl、subagent は `<session>/subagents/agent-*.jsonl`) を直接読む
- **集計を真と扱わない (= 肯定的事実も生データで裏を取る)**: スクリプトが「発火した」「N 件」と出していても、それを鵜呑みに「確認できた」と報告しない。発火・引用・振る舞いといった肯定的事実こそ、生 transcript で tool_use を確認してから事実として報告する (上の「断定しない」が不在側、これが存在側の対)

解析結果は事実 (起きた / 起きていない) として改修者に報告する。発火しなかった場合の原因究明と改修は、この skill の外 (通常の skill 改修フロー) で行う。

### 5. 後片付け

- プローブを配置した場合は必ず削除する:

  ```bash
  .claude/skills/harness-verification/scripts/setup-probe.sh <sandbox パス> --clean
  ```

- 検証セッションが sandbox に生成した成果物 (実装コード等) を残すか消すかは改修者と判断する (再検証でクリーンな状態が要るなら初期 commit に戻す: `git reset --hard` + `git clean -fd`)
- sandbox 自体の削除は改修者の判断。基本は残す (次回の検証で使い回せる)
