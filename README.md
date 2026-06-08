# xp-harness

XP の価値共有で AI コーディングエージェントを動かすハーネス。

要件定義 → 基本設計 → 実装の段階駆動スキルで対話・自走を切り替え、サブエージェントはペアプロ相手として独立視点を与える。「価値で導きつつ、失敗モードが大きい部分にだけ装置を注入する」が中核思想。

現状は Claude Code 対応 (cross-agent 拡張は将来 TODO)。APM (Microsoft Agent Package Manager) で配布。

## Status

**personal harness, work in progress**。

依頼者本人と同チームメンバーの cross-account portability + チーム共有を目的とした個人 OSS。完成度を求める「公式 OSS」段階ではない。外部利用は自由だが、サポート対象外。

## Layout

```
xp-harness/
├── README.md                            # このファイル
├── LICENSE                              # MIT
├── ROADMAP.md                           # 将来 TODO (改修者向け)
├── apm.yml                              # APM manifest
│
├── .apm/                                # ★ APM 配信対象 (一般 user に届く)
│   ├── skills/<...>/SKILL.md
│   ├── agents/<...>.md
│   └── instructions/main.instructions.md
│
└── .claude/                             # ★ APM 管理外、harness 改修者用 (git clone した人だけ使う)
    └── skills/
        └── philosophy/SKILL.md
```

- `.apm/` 配下は APM 配信対象。一般利用者の `apm install` で `.claude/skills/`, `.claude/agents/`, `.claude/rules/` に deploy される
- `.claude/` 配下 (philosophy skill) は **APM 管理外**、配信されない。harness 改修者が git clone して直接利用する

## Install

APM CLI 未 install の場合は [公式 Quickstart](https://microsoft.github.io/apm/quickstart/) を参照。

```bash
# xp-harness を取り込む (skill / agent / instruction が .claude/ 配下に deploy される)
apm install sei-newbear/xp-harness#v0.4.0 --target claude
```

Claude Code は instruction を `.claude/rules/` から直接読むため、**`apm install` だけで完結する**。`apm compile` は不要 (compile はルート単一ファイル `AGENTS.md` / `GEMINI.md` への集約を要する Codex / Gemini 等のための工程。Claude には `.claude/rules/` という native な置き場があるので回さない)。

### 既存 CLAUDE.md について

`apm install` は consumer のルート `CLAUDE.md` を **触らない**。xp-harness の運用ルールは `.claude/rules/main.md` に deploy され、Claude Code が起動時に `CLAUDE.md` と並べて読む。consumer は自分の `CLAUDE.md` をそのまま持っていてよい (退避・移動は不要)。

## Audience and supported agents

### 想定利用者
- 依頼者本人と同チームメンバー (cross-account portability + チーム共有)
- 組織内で興味を持った人 (許容、サポート対象外)
- 外部 OSS user (許容、サポート対象外)

### 対応エージェント
- **Claude Code のみ** (skill / subagent 機構を前提とした設計)
- cross-agent 対応 (Cursor / Copilot 等) は将来 TODO ([ROADMAP](./ROADMAP.md) #3)

## Skills and agents

### 配信される skill (`.apm/skills/`)

| skill | 責務 | 発火タイミング |
|---|---|---|
| `define-requirements` | 要件定義フェーズ (Why / Done / スコープ引き出し) | 新規・変更・削除・改善要望 |
| `basic-design` | 基本設計フェーズ (アーキ / ER / シーケンス / 論理設計) | 要件確定後、「設計を進めて」 |
| `slice-tdd` | 実装フェーズ全般 (TDD 規律、Red→Green→Refactor→Commit) | コード書く / テスト書く / リファクタ / バグ修正 |
| `story-slicing` | ユーザーストーリー INVEST 点検 + 分割 | 要件定義完成直後 |
| `propose-options` | 複数案 + メリデメ + 推奨を提示 (責務適合性で推す) | 設計判断 / ライブラリ選定が複数ありえる場面 |
| `dialogue-principles` | 依頼者との対話の進め方 (共創 / 健全コンフリクト / 段階的開示) | 議論・対話を進める場面全般 |
| `git-workflow` | branch 運用 / push 規律 / 一般 Git 規律 | コード変更 / セッション開始 / Git 操作 |
| `e2e` | E2E テストの流儀 (触る範囲の流儀を探して従う) | E2E spec を書く / 編集する |
| `implementation` | 実装の規約 (コードの書き方・アーキ・命名・コメント) | 実装フェーズでコードを書く / 構造を決める |
| `e2e-execution` | E2E の実行手順 (環境構築・実行コマンド・CI) | E2E を動かす / 実行環境を用意する |

> `implementation` / `e2e` / `e2e-execution` は **薄いデフォルト**として配信され、触る範囲に対応するプロジェクトの規約・流儀・実行手順を探して従う探索型の入口になっている。プロジェクト固有の規約を持っている場合、領域別のスキル (例: front 用 / api 用) を登録すればこれらの既定が触る範囲に応じて振り分けるほか、同名で置き換えることもできる (置き換え方は下記 [Skill management](#skill-management) を参照)。`slice-tdd` が実装フェーズでこれらを参照し、`code-reviewer` は `implementation` を preload するので、規約が実装とレビューの両方に効く。

### 配信される subagent (`.apm/agents/`)

| subagent | 役割 | preload skill |
|---|---|---|
| `pre-implementation-reviewer` | 要件 + 基本設計の第三者レビュー | なし |
| `code-reviewer` | コード変更のペアプロレビュー | `slice-tdd` + `implementation` |
| `e2e-reviewer` | E2E spec のペアプロレビュー | `e2e` + `slice-tdd` |
| `done-verifier` | 完了宣言の証拠検証 (Done 達成の実行確認) | なし |

### 配信される instruction (`.apm/instructions/`)

- `main.instructions.md`: xp-harness の core 運用ルール (XP discipline / phase-driven skill / pair-programming subagent / 横断ルール / 対話の型 / 実装中のルール)。`apm install` で `.claude/rules/main.md` に deploy され、Claude Code が起動時に読む

### 配信されない (改修者用、`.claude/skills/`)

- `philosophy`: harness を改修するときの判断軸 (価値で導きつつ規律装置最小注入 / ペアプロ哲学 / 中央集権より decentralized / outside-in 例外なし / 対話と自走の境界 / INVEST の取捨 / 共創を目指す対話)。harness 改修者が `.claude/skills/philosophy/` を git clone してきた状態で Claude Code が認識する

## Skill management

consumer 側で skill を増やす 2 通り:

### 1. APM 管轄外 (既存運用との共存)
```
project-root/
└── .claude/skills/<your-skill>/SKILL.md   # 直接書く
```
- `apm install` で touch されない、`apm.lock.yaml` にも track されない
- 既存の `.claude/skills/` 運用を続けたい consumer 向け

### 2. APM 管轄内 (APM 流儀で管理)
```
project-root/
└── .apm/skills/<your-skill>/SKILL.md      # APM 配下に書く
```
- `apm install` で `.claude/skills/<your-skill>/` に deploy される
- `apm.lock.yaml` に track される (再現性 / バージョン管理)

### 同名衝突時の挙動

consumer の `.apm/skills/<harness-skill>/` に harness と同名 skill を置くと **「last-installed-wins」** で override される (warning 表示)。**ファイル全体置換**、partial / section 単位の override は不可。

consumer が部分的にカスタマイズしたい場合は、別 skill 名で新規作成するか、`.apm/instructions/<custom>.md` で追加ルールを書く (`apm install` で `.claude/rules/<custom>.md` に deploy される)。

## Update

```bash
# 新 version 確認
apm outdated
```

タグを跨いだ更新 (例: v0.3.0 → v0.4.0) は **`apm.yml` を手で書き換える** 必要がある。`apm install --update` / `apm deps update <pkg>` / `apm install <pkg>#vX.Y.Z --force` のいずれも `apm.yml` の `#vX.Y.Z` pin を書き換えない (= APM 0.12.x 時点の仕様。これらは「`apm.yml` の ref 制約 *内* での latest 追従」しかしない)。

```bash
# 1. apm.yml の dependencies.apm の該当行を編集
#    - sei-newbear/xp-harness#v0.3.0
#    + sei-newbear/xp-harness#v0.4.0

# 2. install 実行
apm install --target claude
```

このとき `Content hash mismatch ... This may indicate a supply-chain attack.` が出る場合がある (lockfile に旧バージョンの hash が残っているため)。 これは APM のサプライチェーン攻撃検出機構が正しく働いている挙動。 手元で `apm.yml` を書き換えたのが原因と分かっていれば、 メッセージ通り `--update` を付けて再実行:

```bash
apm install --update --target claude
```

`apm install` が更新分を `.claude/` 配下に再 deploy するので、これで完了 (`apm compile` は不要)。

### skill 削除があった version の対応

APM はディレクトリ自動削除を拒否する (`Refused to remove directory entry`)。harness の version で skill が削除された場合、consumer は **手動で削除する必要がある**:

```bash
rm -rf .claude/skills/<deprecated-skill-name>/
```

削除すべき skill は [GitHub Releases](../../releases) の各 version の release notes に明示される。

## Development setup

harness を改修するための前提:

- **公式 skill-creator skill** (Anthropic 提供) が consumer の `~/.claude/skills/` 等に install 済であること
- xp-harness の philosophy skill (`.claude/skills/philosophy/`) と公式 skill-creator が並行発火する流れで skill を改修する
- xp-harness を改修したい場合は git clone する (APM の `apm install` 経由ではなく、改修対象の repo を直接編集する)

### harness 改修者の作業フロー

```bash
cd /path/to/xp-harness
bash scripts/setup-dev.sh             # 初回 / skill 追加時に叩く (冪等)
claude                                # philosophy + .apm/ 配下の skill / agent / main instruction が認識される
# .apm/ 配下を編集 (skill / agent / instruction)
# 改修した skill / agent は Claude Code 再起動 (or /skills) で即時反映
```

`scripts/setup-dev.sh` が `.apm/skills/<x>` → `.claude/skills/<x>` / `.apm/agents/<x>.md` → `.claude/agents/<x>.md` の symlink を作る。`.apm/instructions/main.instructions.md` は CLAUDE.md からの `@` transclusion で取り込まれる。philosophy skill (`.claude/skills/philosophy/`) は APM 管理外で git tracked、symlink 対象外。

正式な self-host (`apm install . --target claude`) は **APM の循環依存検出により実現不可** ([ROADMAP](./ROADMAP.md) #1)。上記の symlink 方式は Stage 0 の dogfooding 用 暫定対応。

## Roadmap / TODO

将来 TODO は [ROADMAP.md](./ROADMAP.md) を参照。優先度上位:

- self-host (dogfooding) の実現
- `.apm/instructions/main.md` の section 分割精査
- cross-agent 対応 (Cursor 等への移植)

## License

[MIT](./LICENSE)
