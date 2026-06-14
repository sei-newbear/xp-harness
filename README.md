# xp-harness

Claude Code に XP スタイルの開発リズムを注入する harness。新機能を依頼すると「なぜ作るのか」から確認し、要件定義 → 基本設計 → 実装フェーズを明示的に踏んで進む。実装フェーズは TDD サイクルで自走し、レビュー系 subagent がペアプロ相手として独立した視点を与える。

現状 **Claude Code 専用**。APM (Microsoft Agent Package Manager) で配布。

## Install

APM CLI 未 install の場合は [公式 Quickstart](https://microsoft.github.io/apm/quickstart/) を参照。

```bash
apm install sei-newbear/xp-harness#v0.5.0 --target claude
```

Claude Code は instruction を `.claude/rules/` から直接読むため、**`apm install` だけで完結する**。`apm compile` は不要。

### 既存 CLAUDE.md について

`apm install` は consumer のルート `CLAUDE.md` を **触らない**。xp-harness の運用ルールは `.claude/rules/main.md` に deploy され、Claude Code が起動時に `CLAUDE.md` と並べて読む。自分の `CLAUDE.md` はそのまま持っていてよい。

## インストール後の体験

Claude Code を起動して普通に話しかけると以下が起きる:

- **新機能・変更を依頼する** → `define-requirements` が発火し「なぜ作るのか / Done の条件 / スコープ」を引き出してから実装に入る
- **「実装して」と言う** → `slice-tdd` が TDD サイクルを回し、Red → Green → Refactor → commit を自走する
- **セッション開始時** → `git-workflow` が fetch・状態確認・worktree 提案を自動で行い、終了時に main への統合まで案内する
- **Refactor 前** → `code-reviewer` subagent がペアプロ相手として独立視点でコードレビューを行う

スキルの発火は Claude Code の自動判断。`/define-requirements` のように直接呼んで上書きすることもできる。

## プロジェクト向けのセットアップ

install 直後はデフォルトの動作で動く。プロジェクト固有のルールや規約を持ち込む方法はスキルの種類によって異なる。

### Git 運用ルールを変えたい

`git-workflow` はデフォルトで worktree 運用・高頻度 commit・main への直接統合で動く。PR 必須運用・trunk-based 開発など、チーム固有のルールがある場合は `.apm/instructions/` 配下にファイルを作って書く。`apm install` で `.claude/rules/` に deploy され、Claude Code が起動時に読む。

```
.apm/instructions/git-rules.md  ← 自由な名前でよい
```

中身の例:

```
PR 必須。main への直 push 禁止。branch のまま push して PR を作る。
```

`git-workflow` は Claude Code のコンテキストに入ったこのルールを読んで動作を調整する。

### コード規約・アーキテクチャ方針を入れたい

`implementation` / `e2e` / `e2e-execution` は探索型のデフォルトとして配信されており、触る領域に対応するスキルやドキュメントを自動で探して従う。プロジェクト固有の規約を入れる方法は 2 通りある。

**方法 1: 丸ごと置き換える（より確実）**

`implementation` / `e2e` / `e2e-execution` を同名スキルで全体置換し、「api/ を触るときは `api-implementation` を呼ぶ」のように明示的に書く。LLM の探索判断に頼らないため安定する。

```
.apm/skills/implementation/SKILL.md   # harness の implementation を置き換え
```

中身の例:

```markdown
## 実装規約の探し方

触る領域によってスキルを呼び分ける:
- `api/` 配下: `api-implementation` スキルを呼ぶ
- `front/` 配下: `front-implementation` スキルを呼ぶ
```

`e2e` / `e2e-execution` も同様に置き換えて、使うフレームワークや領域を明示できる。harness の更新への追従は自己管理になる。

**方法 2: プロジェクト側スキルを追加する（手軽）**

harness スキルはそのままに、領域別スキルを `.apm/skills/` に追加する。harness の探索型スキルが自動で発見して呼び出す。

```
.apm/skills/api-implementation/SKILL.md   # API 層の規約
.apm/skills/front-implementation/SKILL.md # フロント層の規約
.apm/skills/e2e-playwright-front/SKILL.md # front の E2E 規約
```

発見の保証はなく、複数領域が混在するプロジェクトでは意図しないスキルが選ばれる可能性がある。シンプルな構成なら十分。`code-reviewer` subagent は `implementation` を preload するため、規約が実装とレビューの両方に効く。

## スキル・subagent 一覧

### 配信されるスキル

| skill | 責務 | 発火タイミング |
|---|---|---|
| `define-requirements` | 要件定義フェーズ (Why / Done / スコープ引き出し) | 新規・変更・削除・改善要望 |
| `basic-design` | 基本設計フェーズ (アーキ / ER / シーケンス / 論理設計) | 要件確定後、「設計を進めて」 |
| `slice-tdd` | 実装フェーズ全般 (TDD 規律、Red→Green→Refactor→Commit) | コードを書く / テスト / リファクタ / バグ修正 |
| `story-slicing` | ユーザーストーリー INVEST 点検 + 分割 | 要件定義完成直後 |
| `propose-options` | 複数案 + メリデメ + 推奨を提示 | 設計判断 / ライブラリ選定が複数ありえる場面 |
| `dialogue-principles` | 対話の進め方 (共創 / 健全コンフリクト / 段階的開示) | 議論・対話全般 |
| `git-workflow` | worktree / branch 運用・完了時の main 統合・push 規律 | コード変更 / セッション開始 / Git 操作 |
| `implementation` | コード規約の探索型入口 (領域別スキルを発見して従う) | 実装フェーズでコードを書く / 構造を決める |
| `e2e` | E2E 流儀の探索型入口 (領域別スキルを発見して従う) | E2E spec を書く / 編集する |
| `e2e-execution` | E2E 実行手順の探索型入口 (実行手順ドキュメントを発見して従う) | E2E を動かす / 環境構築 |

### 配信される subagent

| subagent | 役割 |
|---|---|
| `pre-implementation-reviewer` | 要件 + 基本設計の第三者レビュー |
| `code-reviewer` | コード変更のペアプロレビュー (`implementation` preload) |
| `e2e-reviewer` | E2E spec のペアプロレビュー (`e2e` + `slice-tdd` preload) |
| `done-verifier` | 完了宣言の証拠検証 (Done 達成の実行確認) |

## Update

```bash
# 新 version 確認
apm outdated
```

タグを跨いだ更新 (例: v0.4.0 → v0.5.0) は **`apm.yml` を手で書き換える** 必要がある。`apm install --update` / `apm deps update <pkg>` / `apm install <pkg>#vX.Y.Z --force` のいずれも `apm.yml` の `#vX.Y.Z` pin を書き換えない (= APM 0.12.x 時点の仕様)。

```bash
# 1. apm.yml の dependencies.apm の該当行を編集
#    - sei-newbear/xp-harness#v0.4.0
#    + sei-newbear/xp-harness#v0.5.0

# 2. install 実行
apm install --target claude
```

`Content hash mismatch` が出る場合は lockfile に旧バージョンの hash が残っているため。`--update` を付けて再実行:

```bash
apm install --update --target claude
```

### skill 削除があった version の対応

APM はディレクトリ自動削除を拒否する。harness の version で skill が削除された場合は手動で削除する:

```bash
rm -rf .claude/skills/<deprecated-skill-name>/
```

削除すべき skill は [GitHub Releases](../../releases) の各 version の release notes に明示される。

## 対象と制約

- **対応エージェント**: Claude Code のみ。cross-agent 対応 (Cursor / Copilot 等) は将来 TODO ([ROADMAP](./ROADMAP.md) #3)
- **想定利用者**: 依頼者本人・同チームメンバーの cross-account portability とチーム共有を主目的とした個人 OSS。外部利用は自由だが SLA なし・サポート対象外。issue / PR は歓迎、対応は任意
- **成熟度**: work in progress。breaking change は release notes に記載する

## 改修・コントリビューション

harness 本体 (skill / agent / instruction) を改修したい場合は [CONTRIBUTING.md](./CONTRIBUTING.md) を参照。

## License

[MIT](./LICENSE)
