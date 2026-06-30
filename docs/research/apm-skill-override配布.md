# APM skill override 配布の検証記録

**問い**: 組織が xp-harness の上書き前提 skill (`implementation` / `e2e-execution` 等) を、
APM パッケージで一括差し替えして各リポジトリに配れるか。version は統一できるか / 各リポジトリ自由にできるか。

**位置づけ**: xp-harness を APM 配布する際の運用知見の調査記録（改修者向け）。consumer 向け配布ガイドにする場合は別途要約を起こす。

**検証**: APM CLI 0.16.0 / GitHub CLI 2.92.0 / `--target claude` / 2026-06 / 実機(local path + GitHub ref)
再現 artifact は git 管理外の sandbox (`xp-harness-sandbox/`) にある（末尾の対応表参照）。

---

## 結論

1. **配れる。** 組織は「override skill を持つパッケージ」を作り、各リポジトリに install すればよい。
2. **version 統一も、リポジトリ自由も、どちらも選べる。** 技術的な壁はない（運用方針の選択）。
3. **本命は「git リポジトリとして配る」。** `apm pack` で固める配布だと override が消える(後述)。
4. APM 以外に **gh skill** でも override 配布できる（skill 単位・クロスエージェント）。Claude Code の plugin/marketplace は override 不可。

---

## 組織への推奨: 2つの配り方から選ぶ

### 方式①: version 統一（推奨・シンプル）

組織パッケージが **xp-harness を内包**する。各リポジトリは 1 行・1 コマンド。

```yaml
# 組織パッケージ org-overrides の apm.yml
dependencies:
  apm: [ sei-newbear/xp-harness#v0.3.0 ]   # ← 組織が version を固定
# org-overrides/.apm/skills/ に上書きしたい skill だけ置く
```
```bash
# 各リポジトリ
apm install <org>/org-overrides --target claude   # force 不要・これだけ
apm compile --target claude
```
- ✅ force 不要 / install 1 コマンド / `apm install` 一発で再現できる
- ⚠️ xp-harness の version は組織が握る（各リポジトリは選べない）

### 方式②: リポジトリが version 自由

組織パッケージは override skill **だけ**(xp-harness 非依存)。各リポジトリが xp-harness を直接指定。

```yaml
# 各リポジトリの apm.yml
dependencies:
  apm: [ sei-newbear/xp-harness#v0.2.0, <org>/org-overrides-skillonly ]
```
```bash
# install は必ず 2 段（順序が重要）
apm install sei-newbear/xp-harness#v0.2.0 --target claude         # 先に harness
apm install <org>/org-overrides-skillonly --target claude --force # 後で override(force必須)
apm compile --target claude
```
- ✅ 各リポジトリが xp-harness の version を自由に選べる
- ⚠️ install が 2 段 + `--force` 必須 / `apm install` 一発では override が効かない

> **選択の指針**: 組織で version を揃えたい → 方式①。各リポジトリの自由を優先 → 方式②。
> 両方残したいなら、同じ override skill から「内包版」と「skillだけ版」の 2 パッケージを用意する。

---

## なぜ方式①は force 不要で、方式②は force 必須なのか

APM の同名衝突は **deploy 順** で決まる（apm.yml の記載順では決まらない）。

```
deploy 順:  .claude 直書き  →  自分の .apm/skills  →  direct 依存  →  transitive 依存

force なし → 先に置かれた方が勝つ（後から来たら skip）
force あり → 後に置かれた方が勝つ（後から来たら上書き）
```

- **方式①**: org(direct) が先、内包 xp-harness(transitive) が後 → force なしで org が勝つ。
- **方式②**: 両方 direct で xp-harness が後に deploy され勝ってしまう → force で順序を覆す必要がある。

---

## アップデート運用（更新時の手順）

方式①で配った後、組織が override skill を更新したときの各リポジトリ側の更新。

```bash
# 組織側: org-overrides を更新して version を上げ、再タグ・push

# 各リポジトリ側: apm.yml の org-overrides#v0.1.0 → #v0.2.0 に書き換えてから
apm update --yes              # ← 素の apm install ではなくこれを使う
apm compile --target claude
```

検証で確定したこと:
- **更新に force は不要**。override skill の持ち主(owner)は org パッケージで、更新は「持ち主が自分の skill を新しくする」動き。異パッケージの衝突ではないので force 不要。
- **override してない skill は無事**。force を使わないので、xp-harness の他 skill を巻き込まない。
- ⚠️ **既存 install の上に素の `apm install` を更新目的で重ねると、deploy 順が乱れて override が壊れる**ことがある（implementation が harness 版に戻る事象を観測）。APM の「idempotent な再 install が乱れる」癖。更新は必ず `apm update`（または apm.yml の pin を上げて `apm install --update`）を使う。

---

## 効く手段 / 効かない手段（一覧）

| 手段 | override | メモ |
|---|---|---|
| `.claude/skills/` に直書き | ◎(force なし) | 最強だが force install で消える。配布は手動同期(APM 外) |
| 自リポジトリの `.apm/skills/` | ○ | 確実だが各リポジトリで毎回用意が要る |
| 組織パッケージが xp-harness 内包(方式①) | ◎ | **推奨**。force 不要 |
| 両パッケージ並列 + 逐次install(方式②) | ○ | force 必須・install 2段 |
| 両パッケージ並列 + `apm install` 一発 | ✗ | force でも負ける |
| `apm pack` の bundle/plugin に焼き込む | ✗ | pack は "first writer wins" で xp-harness が勝つ |
| `includes` で依存 skill を除外 | ✗ | allow-list only、`exclude:` 構文が無い |
| `devDependencies` に置く | ✗ | dependencies と同挙動、利点なし |
| `apm uninstall` で個別 skill 削除 | ✗ | パッケージ単位、skill 単位は不可 |
| 組織の運用ルール(instruction)を**追加** | ○ | `.claude/rules/` に併存 deploy。override ではなく追加 |

---

## APM 以外の配布経路

xp-harness は APM 配布だが、skill は最終的に `.claude/skills/` に置かれる。同じ場所を狙う別経路も検証した。

| 経路 | override 可否 | 粒度 | 性質 |
|---|---|---|---|
| **APM**（方式①内包） | ◎ force 不要 | パッケージ単位 | apm.yml 宣言・version 統一・再現性高 |
| **gh skill** | ○ `--force` で上書き | **skill 単位** | GitHub repo から install・`--pin`・provenance を frontmatter 注入・**クロスエージェント**(claude/copilot/cursor 等) |
| **Claude Code plugin/marketplace** | ✗ 不可 | plugin 単位 | skill が **namespace 分離**(`/plugin:skill`)され共存のみ。override には使えない（追加配布向き） |

- **gh skill**: `gh skill install <repo> <skill> --agent claude-code` で `.claude/skills/` に入る。既存があると force なしは skip、`--force` で上書き。1 つの skill を 1 回書くだけなので force=確定（APM の deploy 順問題は無い）。Claude Code 以外のエージェントにも同じ skill を配れるのが強み。
- **plugin/marketplace**: plugin の skill は必ず namespace 付きで提供されるため、APM 配布の同名 skill を上書きできない（別物として共存）。

---

## 落とし穴（必読）

- **`apm pack` 配布は override を焼き込めない**。bundle/plugin 化すると xp-harness 版が入る（pack の collision は "first writer wins" で xp-harness が勝つ）。組織 override は **pack せず git source のまま配る**こと。
- **`--force` は APM 管轄外の直書きファイルも消す**。リポジトリが `.claude/skills/` に手書きしたカスタマイズは force install で上書きされる。方式②(force 運用)はこの危険を抱える。
- **更新は `apm update` を使う**。既存の上に素の `apm install` を重ねると override が壊れることがある（上記アップデート運用参照）。
- **deploy 順の規則(direct>transitive 等)は docs に明文化されていない実装挙動**。APM をアップデートしたら再検証する前提で運用する。

---

## 付録

### APM の前提知識（検証で確定したもの）
- **install ソース**: `owner/repo#ref`(GitHub) / git URL / local path / `.tar.gz`(bundle) / marketplace ref。bare local git repo は非対応。local path は `apm pack` 不可(dev 専用)。
- **APM に override 制御フィールドは無い**: apm.yml に npm の `overrides` / yarn の `resolutions` 相当が無い。公式に保証される優先は「local project files always win」の 1 つだけ。
- **CLAUDE.md は transclusion 構造**: compile 後の CLAUDE.md は依存側の CLAUDE.md を `@参照`するだけ。
- 上書きは**同名 skill ディレクトリの全ファイル置換**（部分上書き不可、`description` ごと差し替え）。

### 未検証
- `apm publish` での実レジストリ / marketplace 配布（今回は local path + GitHub ref のみ）。
- APM と gh skill を混在させたときの相互作用（gh skill で上書き後に `apm install` を流すと APM 版に戻るか）。

### 再現 artifact（git 管理外の `xp-harness-sandbox/` 内）
| ディレクトリ | 示すもの |
|---|---|
| `org-overrides/` | 方式①: xp-harness 内包 + override skill |
| `consumer-org/` | 方式①: install 一発で override 成立(force なし) |
| `org-overrides-skillonly/` | 方式②: xp-harness 非依存の override skill だけ |
| `consumer-b-sequential/` | 方式②: 逐次install で override 成立(version 自由と両立) |
| `consumer-b/` | 反例: 方式② を `apm install` 一発にすると override が負ける |
| `consumer-beta/` | `.claude` 直書きの挙動(force なしで生存 / force で消える) |
| `consumer-update/` 他 | アップデート挙動(apm update なら org 版維持 / 素の再 install で壊れる) |
| `consumer-ghskill/` | gh skill で APM 配布 skill を override(force 上書き) |
| `consumer-bundle/` + `org-overrides/build/` | 反例: pack bundle 配布は override が焼き込まれない |
| `demo-2-self-override/` | 自リポジトリ `.apm/skills/` で override |
| `dummy-pkg/` `demo-1-dep-override/` | 補足検証(両パッケージ並列の素の挙動) |
