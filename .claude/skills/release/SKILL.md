---
name: release
description: xp-harness の version を上げて GitHub Release を作る開発者向け skill。現バージョン確認 → 次バージョン判定 (semver) → 変更内容のユーザー向け / 開発者向け分類 → tag + push → gh release create までの流れを定義。「リリースする」「タグを打つ」「v0.x.x をリリース」と明示されたときに発火。
---

# release skill

## なぜこの skill があるか

xp-harness のリリース (= 新 version tag + GitHub Release 作成) は手動運用。 手順を skill 化することで、 改修者間でリリースの流儀 / リリースノートのスタイルを揃える。 「GitHub Actions で release notes 自動化」 (kanban backlog の項目) が完了するまでは手動運用が続く想定。

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

````markdown
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

## Install (新規 consumer 向け)

(apm install コマンド)

## Update (既存 consumer 向け、 <前 version> → <新 version>)

`apm.yml` の依存指定を新バージョンに書き換える:

```diff
 dependencies:
   apm:
-  - sei-newbear/xp-harness#<前 version>
+  - sei-newbear/xp-harness#<新 version>
```

そのあと:

```bash
apm install --target claude
# Content hash mismatch が出たら (= APM のサプライチェーン検出機構、想定挙動)
apm install --update --target claude
```

詳細は README "Update" セクション参照。

## Note

(後方互換性 / 状態 note)
````

#### `## Update` セクションが必要な理由

APM 0.12.x はタグを跨いだ更新コマンド (npm でいう `npm install pkg@latest`) を持たない。 既存 consumer は `apm.yml` を手で書き換える必要があり、 リリースノートに手順がないと「`apm install --update` で上がるはず」と試してハマる (= v0.2.0 アップデート時に別 consumer プロジェクトで実際に発生)。

#### 分類の基準

- **ユーザー向け**: APM で consumer に配布される対象 (`.apm/skills/` / `.apm/agents/` / `.apm/instructions/`)、 README の install / 使い方
- **開発者向け**: xp-harness リポジトリ root のみで管理されるもの (CLAUDE.md / `scripts/` / `kanban/` / `.claude/skills/<開発者向け>/`)

迷ったら判断基準: 「**この変更は APM 経由で consumer に届くか?**」 → 届けばユーザー向け、 届かなければ開発者向け。

#### 内容の書きっぷり: ユーザー向けは「観測可能な挙動の変化」で書く

分類 (= どこに置くか) とは別に、**各項目の書き方**を間違えない。**ユーザー向けの項目は、consumer が実際に観測する挙動の変化で書く** (= その skill / 機構が今後どう振る舞うようになったか)。**内部の実装 how (どう書き直したか・リファクタ詳細・行数・用語統一など) はユーザー向けに書かない** (= consumer の挙動に直接効かないため)。書きたければ開発者向けへ。

- ✗ 「`slice-tdd` skill をゼロベースで書き直し、用語を統一、重複を single-source 化 (365→227 行)」 (= 内部の how)
- ○ 「`slice-tdd`: outside-in が実装の各層に届くようになった。実装エージェントが各層でも "その層が外に見せる契約" を先に決めて内側を surface する方向に進む」 (= consumer が観測する挙動)

判断軸: 「この項目を読んだ consumer が、**自分の作業で何が変わるか** を掴めるか?」 掴めなければ内部の how に寄っているサイン。

リリースノートは一時ファイル (例: `/tmp/release-notes-vX.X.X.md`) に書く。

### Step 5: main 最新化

```bash
git checkout main
git pull --ff-only origin main
```

リリース対象は origin/main の最新。 別 branch にいる場合は main を checkout する。

### Step 6: README のバージョン参照を新バージョンに更新 + commit + push

README には install / migrate / Update セクションの例に `sei-newbear/xp-harness#vX.Y.Z` 形式のバージョン参照が複数箇所ある。 **tag を打つ前に** これらを新バージョンに揃える (= 新規 consumer が README をコピペしたら新バージョンが入る状態にする、 既存 consumer 向けの Update 例も最新の migration を示す)。

```bash
# 1. 全箇所を grep して把握
grep -n "sei-newbear/xp-harness#v" README.md

# 2. 該当箇所を新バージョンに編集
#    - Install セクション (install コマンド)
#    - 初回 install 前の migrate 手順内の install コマンド
#    - Update セクションの diff 例 (= 直前リリース → 今回リリース に揃える)

# 3. commit + push to main
git add README.md
git commit -m "README: install / migrate / update 例のバージョン参照を vX.Y.Z に更新"
git push origin main
```

tag を打つ前に README を更新しておくことで、 tag が指す commit に正しいバージョン参照が含まれ、 consumer が tag で取得した README にも新バージョンが反映される。

#### なぜ手動更新が必要か (= latest float を採らない理由)

APM (0.12.x 時点) は **タグ pin を推奨**しており、 `sei-newbear/xp-harness` のようにバージョン無指定で書くと「default branch (main) の HEAD」 を取得する (= unreleased な作業中 commit も pull される)、 加えて APM 自体が `[!] 1 dependency unpinned: ... add #tag or #sha to prevent drift` の warning を出す。 また semver range syntax (`^v1`, `~v1.0` 等) も公式 docs にサポート記載がない。 そのため xp-harness の README は具体 tag で pin し、 release ごとに手動同期する運用を取る (= kanban backlog の「GitHub Actions で release notes 自動化」 と合わせて将来自動化対象)。

### Step 7: tag 作成 + push

```bash
git tag -a vX.X.X -m "<簡潔な概要 (= リリースタイトル相当)>"
git push origin vX.X.X
```

**annotated tag を使う** (= `-a` 付き)。 軽量 tag は使わない (= 後から release notes / 履歴を辿りにくくなるため)。

### Step 8: GitHub Release 作成

```bash
gh release create vX.X.X --title "vX.X.X — <概要>" --notes-file /tmp/release-notes-vX.X.X.md
```

完了したら一時ファイルを削除: `rm /tmp/release-notes-vX.X.X.md`

### Step 9: かんばん同期 (= リリースに含む改修をバックログに反映)

リリースは「shipped した」の曖昧さのない節目。作業に没頭するとバックログの現実同期が抜け落ちる (= 完了・リリースまで行ってカードを動かさない失敗が実際に起きた)。**リリースの締めで必ず `kanban` skill を呼び、リリースに含む改修をバックログに反映する**。何をどうカード化 / DONE 化するか (= 独立項目か付随か・ファイル名規約・DONE カードの中身・完了済みの直接記録) は `kanban` skill の流儀に従う (= この Step の責務は「リリースの節目で必ず同期する」の規律化で、カード化の判断と操作は `kanban` skill が single source として持つ)。

## 振る舞いのルール

### `gh` コマンドを使う (= git-workflow skill の override)

この release skill では `gh` コマンドを使う。 git-workflow skill のデフォルト「`gh` 使わない」を意図的に override する。 理由: GitHub Release 作成は Web UI でも可能だが、 リリースノートの一貫性 / 自動化のため CLI で実行する。

### バージョン判定は依頼者と認識合わせ

semver の判定 (= patch / minor / major) は影響度の解釈に依存する。 main session の判断を依頼者と認識合わせしてから tag を打つ。 一方的に決めない。

### リリースノートの分類は明確に

ユーザー向け / 開発者向けの分類は曖昧にしない。 各項目を分類した根拠 (= 配布先) を意識する。 分類が曖昧な項目は依頼者と認識合わせ。

### リリースノートには具体 version を埋める

テンプレ内の `<前 version>` / `<新 version>` placeholder は **実リリースノートでは具体 version (例: `v0.1.0` / `v0.2.0`) に置き換える**。 placeholder のまま公開しない。 リリース時点で前バージョン (= 直前の tag) と新バージョン (= これから打つ tag) は両方確定しているので、 具体 version を書いた方が consumer は「自分のバージョンから上げる diff」 を直接読めて親切。

### tag は main に打つ

tag を打つ対象は origin/main の最新 (= マージ済のすべての変更が含まれる commit)。 未マージの branch には tag を打たない。

## 成果物

- README のバージョン参照 (install / migrate / Update 例) が新バージョンに更新された commit、 origin/main に push 済
- 新しい version tag (例: `v0.2.0`)、 origin に push 済 (= README 更新済 commit を指す)
- GitHub Release ページ (= リリースノート付き)
- リリースに含む改修が `kanban` バックログに反映済
