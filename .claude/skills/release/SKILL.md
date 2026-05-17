---
name: release
description: xp-harness の version を上げて GitHub Release を作る開発者向け skill。現バージョン確認 → 次バージョン判定 (semver) → 変更内容のユーザー向け / 開発者向け分類 → tag + push → gh release create までの流れを定義。「リリースする」「タグを打つ」「v0.x.x をリリース」と明示されたときに発火。
---

# release skill

## なぜこの skill があるか

xp-harness のリリース (= 新 version tag + GitHub Release 作成) は手動運用。 手順を skill 化することで、 改修者間でリリースの流儀 / リリースノートのスタイルを揃える。 ROADMAP TODO 38 (GitHub Actions で release notes 自動化) が完了するまでは手動運用が続く想定。

## やること

skill が呼ばれたら以下の Step を順番に実行する。

### Step 1: 現状確認

- 現在の tag 一覧: `git fetch --tags origin && git tag -l | sort -V`
- origin/main の最新 commit: `git fetch origin && git log --oneline origin/main -5`
- 直前のリリース tag (= 最新の vX.X.X tag) を特定
- 現 branch が origin/main と同期しているか確認 (= リリース対象は main の最新)

### Step 2: 次バージョン判定 (semver)

変更内容に応じて semver で判定:

- **patch up** (= 0.x.X+1): バグ修正のみ
- **minor up** (= 0.X+1.0): 新機能追加、 後方互換あり
- **major up** (= X+1.0.0): 破壊的変更 / 後方互換なし

判定は変更内容 (= 前回 tag → 現在の commit 一覧) を main session が判断し、 依頼者と認識合わせしてから確定する。

### Step 3: リリースノート材料収集

- 前回 tag → 現在の commit 一覧: `git log --oneline <prev-tag>..origin/main`
- 過去のリリースノートのスタイルを参考に: `gh release view <prev-tag>` で前回の body を確認

### Step 4: リリースノート作成

リリースノートは **ユーザー向け / 開発者向けを明確に分ける**:

```markdown
<簡潔な 1 行サマリ>

## ユーザー向け (= xp-harness を使う人)

### Added
- ...

### Changed
- ...

## 開発者向け (= xp-harness を改修する人)

### Added
- ...

### Changed
- ...

## Install

(apm install コマンド)

## Note

(後方互換性 / 状態 note)
```

#### 分類の基準

- **ユーザー向け**: APM で consumer に配布される対象 (`.apm/skills/` / `.apm/agents/` / `.apm/instructions/`)、 README の install / 使い方
- **開発者向け**: xp-harness リポジトリ root のみで管理されるもの (CLAUDE.md / `scripts/` / ROADMAP / `.claude/skills/<開発者向け>/`)

迷ったら判断基準: 「**この変更は APM 経由で consumer に届くか?**」 → 届けばユーザー向け、 届かなければ開発者向け。

リリースノートは一時ファイル (例: `/tmp/release-notes-vX.X.X.md`) に書く。

### Step 5: main 最新化

```bash
git checkout main
git pull --ff-only origin main
```

リリース対象は origin/main の最新。 別 branch にいる場合は main を checkout する。

### Step 6: tag 作成 + push

```bash
git tag -a vX.X.X -m "<簡潔な概要 (= リリースタイトル相当)>"
git push origin vX.X.X
```

**annotated tag を使う** (= `-a` 付き)。 軽量 tag は使わない (= 後から release notes / 履歴を辿りにくくなるため)。

### Step 7: GitHub Release 作成

```bash
gh release create vX.X.X --title "vX.X.X — <概要>" --notes-file /tmp/release-notes-vX.X.X.md
```

完了したら一時ファイルを削除: `rm /tmp/release-notes-vX.X.X.md`

## 振る舞いのルール

### `gh` コマンドを使う (= git-workflow skill の override)

この release skill では `gh` コマンドを使う。 git-workflow skill のデフォルト「`gh` 使わない」を意図的に override する。 理由: GitHub Release 作成は Web UI でも可能だが、 リリースノートの一貫性 / 自動化のため CLI で実行する。

### バージョン判定は依頼者と認識合わせ

semver の判定 (= patch / minor / major) は影響度の解釈に依存する。 main session の判断を依頼者と認識合わせしてから tag を打つ。 一方的に決めない。

### リリースノートの分類は明確に

ユーザー向け / 開発者向けの分類は曖昧にしない。 各項目を分類した根拠 (= 配布先) を意識する。 分類が曖昧な項目は依頼者と認識合わせ。

### tag は main に打つ

tag を打つ対象は origin/main の最新 (= マージ済のすべての変更が含まれる commit)。 未マージの branch には tag を打たない。

## 成果物

- 新しい version tag (例: `v0.2.0`)、 origin に push 済
- GitHub Release ページ (= リリースノート付き)
