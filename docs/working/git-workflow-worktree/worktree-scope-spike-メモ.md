# git-worktree 並行作業環境 spike — 調査レポート(別セッション引き継ぎ用)

> sandbox(`xp-harness-sandbox/`)での実走 spike の記録。
> **凡例**: 【実測】= 実際に試して確認した事実 / 【未確認】= 試していない・確定していない論点。
> 推測は【未確認】に分類している。

---

## 1. 何を調査していたか(ゴール / 痛み)

**並行作業環境づくりのゴール**:
- Claude が自走で作業している間、ユーザーが同じマシンで別作業をする
- 2 つの作業の git を混ぜず、きれいに隔離したい

**分担**: Claude = worktree 側 / ユーザー = メインの git。同じ repo、`.git` は共有、作業ツリーとブランチだけ分離。

**解こうとしている痛み**: 1 つの working tree を共有していると、Claude の作業とユーザーの作業が踏み合う(ブランチ切替・作業中ファイル・index の衝突)。worktree で物理的に作業ツリーを分ければ踏み合わない。

**この調査の上位の狙い**: `git-workflow` skill を「ブランチ作成」から「worktree 作成」へ変えること(別セッションで define-requirements から進める。`申し送り.md` 参照)。

---

## 2. worktree 機構の実測事実

### git worktree add 【実測】
- `git worktree add -b <branch> <path>` で worktree 作成。repo 全体をブランチ単位で checkout したもの
- **repo 内**(例 `.claude/worktree/`)に作ると、メイン側 `git status` に `?? .claude/` として**漏れる** → gitignore 必須
  - `/.claude/worktree/` を gitignore に入れると `git check-ignore` でマッチ確認でき、メイン status はクリーン
- **repo の外**(兄弟ディレクトリ)に作ると、メイン側 status は**完全にクリーン(漏れゼロ)**
- repo 内 worktree でも `.claude/` 自体は未コミットなら worktree に再帰コピーされない(無限ネストしない)

### EnterWorktree(Claude Code 固有ツール)【実測】
- `EnterWorktree(name: X)` → `<repo>/.claude/worktrees/X`(複数形)に新規 worktree 作成、新ブランチ `worktree-X`、セッションの cwd をそこへ切替
  - 作成先 repo は **Bash cwd が属する repo**(セッションの primary ではなく現在地の repo)
  - 置き場所は `.claude/worktrees/` 固定(引数で変えられない)
- **必ず worktree のリポジトリルートに着地する**。サブディレクトリ(例 `app/hoge`)から呼んでもルートに入る。サブディレクトリ着地は不可
- `EnterWorktree(path: <既存worktree>)` → 既存 worktree に入る。`path` は **`git worktree list` に出る登録済み worktree** のみ受理。**外部ディレクトリの worktree も受理する**(実測で外部に入れた)
  - **サブディレクトリを `path` に渡すと拒否**(`not a registered worktree`)
- 入ると cwd が worktree になり、Read / Write / Edit が worktree パスに効く(通常セッションで外部 worktree を触ると出る working-dir 境界問題が、入ることで解消)

### ExitWorktree 【実測】
- `ExitWorktree(keep)` → worktree をディスクに残し、セッションを元の dir に戻す
- `ExitWorktree(remove)` → worktree とブランチを削除(未コミット/未マージがあると拒否、`discard_changes` で強制)
- `path` で入った(EnterWorktree が作っていない)worktree は remove 対象外 → `keep` で戻る

### cwd の移動 / git の混ざり方 【実測】
- EnterWorktree でセッション cwd が worktree に**完全移動**。元 repo はデフォルトの視界(cwd 基準の検索・操作)から外れる。戻るには ExitWorktree
- worktree は `.git`(オブジェクト・refs・config・stash)を共有し、**作業ツリー + index + ブランチ**だけ分離
- worktree でのコミットは worktree のブランチに乗り、メイン側のブランチ / HEAD は無傷
- worktree から push 可能(ローカル bare remote へ push 成功)
- 同一ブランチを 2 つの worktree で同時 checkout は不可(git が禁止)。`git branch -vv` で別 worktree が checkout 中のブランチに `+` が付く

---

## 3. 環境づくりとして検討・試行したこと

### worktree の配置 【実測】
- `.claude/worktree(s)/`(内部)→ 漏れる、gitignore 必須(トリッキー)
- 外部兄弟ディレクトリ → 漏れゼロ・gitignore 不要・完全分離 → **こちらを採用方向**

### worktree を「動く状態」にするセットアップ
- 【実測】外部 worktree に `EnterWorktree(path:)` で入ると、そこが cwd になり file tools が効く = 動く状態になる
- 【実測】xp-harness 自身を worktree にする場合、`scripts/setup-dev.sh` の再実行が要る(section 5 参照)

### 元 repo とユーザー / worktree と Claude を混ぜない運用
- 【実測】cwd 分離(視界ベース)で達成。EnterWorktree 後、Claude の既定の作業対象は worktree、元 repo は cwd の外
- 【実測/前提】保護は**権限の壁ではなく視界の分離**。auto mode では権限が開いており、明示的に元 repo を指せば書けてしまう(ユーザー談 + 交絡により厳密未検証、section 4 参照)

### add-dir でスコープ(無関係 dir を除外)を試行
- 【実測】`/add-dir <相対パス>` の永続化は **絶対パスに変換** され `settings.local.json`(非追跡)に保存 → worktree に**追従しない**
- 【実測】add-dir は足し算で引き算できない → 無関係 dir(fuga 等)を**除外できない**。EnterWorktree がルート入りなので worktree セッションは全ツリーが見える(検索で fuga まで出ることを確認)
- 【未確認】committed な相対 `additionalDirectories` を手書きした場合に worktree ルート基準で再解決されるか(セッション制約で実測できず)

### worktree の配置・命名規約
- 【未確認】試した名前(`flow-iso` / `spike-iso` / `iso-ext`、dir 名 `*-wt` / `*-flowtest` / `*-iso`)はあるが、**規約は未確立**。consumer 環境で一貫する命名・配置規約は設計事項

### symlink / setup スクリプトの扱い
- section 5 にまとめた(xp-harness 固有)

---

## 4. 詰まった点・地雷・未解決の論点

### 地雷(設計で潰す)
1. 【実測】**EnterWorktree は Claude Code 固有ツール** → skill 本文に直書きできない(skill-design-style 原則 2: 本文は agent 非依存)。「worktree を切る / 入る」を agent 非依存に表現する必要
2. 【前提】**git-workflow は consumer 配布スキル** → worktree 化が全 consumer に及ぶ。既定にするか opt-in / project override にするか
3. 【前提】**philosophy で「自動 worktree」はスコープ外扱い**(4 象限の「痛み未明確 / Git 運用が固まってから」)→ 上書きする Why が要る、philosophy 更新も検討
4. 【実測】**「branch でなく worktree」ではなく「branch + worktree」** → worktree は必ずブランチを伴う(`worktree add -b`)。既存のブランチ提案ロジックと統合する形
5. 【未確認】worktree の**配置・命名規約**が未確立

### 未解決の論点(未確認)
- 【未確認】スコープ(fuga 除外)と隔離の両立:
  - Read deny ルール(`Read(/fuga/**)`、project-root アンカー)が worktree に追従するか → **未検証**(この spike で一度 deny を置いたが、相対 settings に切り替えた際に削除したため検証していない)
  - sparse-checkout で worktree の中身を関連 dir だけにする案 → **未検証**(候補として挙げたのみ)
  - worktree/app/hoge を起点に**新規起動**すれば scope は得られるはず → **未検証**(EnterWorktree を使わない別フロー)
- 【未確認】元 repo への**書き込み遮断**(隔離の権限面)→ auto mode かつ調査セッションが親 dir を working dir に持つ交絡で、クリーンに検証できていない。素のセッション(repo だけで起動)で要確認

---

## 5. xp-harness 固有の事情(setup-dev.sh の symlink 構成 × worktree)【実測】

### 構成
- `scripts/setup-dev.sh` は `.apm/skills/*` と `.apm/agents/*.md` を `.claude/skills/<x>` / `.claude/agents/<x>.md` への**相対 symlink**(`../../.apm/...`)として作る。冪等。philosophy は対象外(git tracked 実体)
- `.gitignore` で `.claude/skills/*` と `.claude/agents/*` は**非追跡**。例外 un-ignore は改修者向けの実体ディレクトリのみ(`philosophy/` `release/` `skill-design-style/` `harness-verification/` `skill-reviewer.md`)
- → consumer 向け skill / agent の symlink(`git-workflow` 等)は **git 非追跡**(`git ls-files` に出ない)

### worktree での挙動(実測)
- xp-harness の worktree を作ると、`.claude/skills/` には**改修者向けの実体ディレクトリだけ**が来る(`harness-verification` `philosophy` `release` `review-recording` `skill-design-style`)。**consumer 向け symlink(git-workflow 等)は来ない**(非追跡なので)
- `.apm/skills/`(全 skill の実体)と `scripts/setup-dev.sh` は worktree に**ある**(追跡されている)
- worktree 内で `setup-dev.sh` を**再実行すると symlink が復旧**。相対パス `../../.apm/...` は worktree 内で解決し、SKILL.md も読める(実測で確認)

### 含意
- **xp-harness 自身を worktree で動かすなら、worktree 内で `scripts/setup-dev.sh` の再実行が必要**(でないと consumer 向け skill / agent が認識されない)
- git-workflow を worktree 化する設計では、この「worktree セットアップ後に symlink 復旧ステップが要る」点を考慮する必要がある
- 【未確認】consumer 環境では symlink 機構が xp-harness と異なる(APM が deploy する)ので、consumer 側 worktree でのセットアップ手順は別途検討が必要

---

## 関連ファイル
- `申し送り.md`(同ディレクトリ): 設計論点を絞った要約版。本レポートが詳細版
- sandbox に spike の実物が残置(`worktree-verify*` / `monorepo-spike*` の各 worktree / 疑似 remote)

---

## 6. 後始末（削除）の実測

> sandbox の `monorepo-spike` + 使い捨て worktree で実施。**【実測】= 試した事実 / 【未確認】= 試していない**。
> 前提（前回確認済）: `ExitWorktree(remove)` は `path` で入った worktree には効かない → 削除は手動 `git worktree remove`。

### 6.1 worktree の中にいる状態で自分を消せるか 【実測】

- EnterWorktree(path:) でその worktree に入った状態(cwd が worktree 内)で `git worktree remove <自分の絶対パス>` → **git は拒否せず削除する(exit 0)**。「現在の working tree だから」という拒否はしない(main working tree は拒否されるが、linked worktree は自分が中にいても消せる)
- 結果、ディレクトリが足元から消え、**シェルの cwd が宙吊り**になる → 以降のコマンドが `fatal: Unable to read current working directory: No such file or directory` で全滅
- **復旧可能**: `ExitWorktree(keep)` でセッションを元 repo に戻し、有効パスへ cd すれば健全に戻る。worktree 登録は綺麗に解除される(stale 登録は残らない)
- 含意: 「中から自分を消す」は事故的に成功してセッションを壊す → **削除は worktree の外(メイン repo)から行うべき**

### 6.2 抜けてから消せるか + セッション健全性 【実測】

- `ExitWorktree(keep)` でメイン repo に戻った後、同じセッションから `git worktree remove <path>` → **成功する**
- 未コミット/untracked があると拒否(`fatal: '...' contains modified or untracked files, use --force to delete it`、exit 128)→ `--force` で削除
- **削除後のセッション健全性: 問題なし**。EnterWorktree で working dir 登録していたパスを削除しても、ExitWorktree(keep) 後は現 working dir でないため、その後の Bash(pwd / ls / git status)も **Read ツール**(メイン repo の README.md を Read 成功)も正常
- 含意: **「ExitWorktree(keep) → メインから `git worktree remove`」が安全な削除フロー**

### 6.3 別セッションが中にいる worktree を消すと 【未確認 + 推論】

- 2 つの Claude セッション同時は今回実行できず **【未確認】**
- 6.1 からの推論: **git は「プロセスが cwd として中にいる」ことを検出しない**(6.1 で自分のシェルが中にいても remove が成功した)。git が見るのは未コミット/untracked と worktree lock のみ
- → 別セッション X が中にいる worktree を別の場所から `git worktree remove`(clean なら無印 / dirty なら `--force`)すると、**成功し、セッション X の cwd が宙吊りになる**と推測【未確認】
- dirty worktree の remove 挙動は **【実測】**: 未コミット/untracked あり → `--force` 必須(6.2 と同じ)

### 6.4 branch の merge 済み判定 + stale worktree 列挙 【実測】

- `git branch --merged main` で main に取り込み済みの branch を列挙(未 merge の branch は出ない)
- `git worktree list --porcelain` で各 worktree と branch を取り、`--merged main` と突き合わせれば **stale worktree(merge 済み branch の worktree)を機械的に列挙できる**
- 実コマンド例:

```bash
git worktree list --porcelain \
| awk '/^worktree /{wt=$2} /^branch /{b=$2; sub("refs/heads/","",b); print wt"\t"b}' \
| while IFS=$'\t' read -r wt br; do
    git branch --merged main --format='%(refname:short)' | grep -qx "$br" \
      && [ "$br" != main ] && echo "STALE: $wt ($br)"
  done
```

- **注意(重要)**: `--merged main` は「branch の tip が main から到達可能」を意味する。明示的な merge commit が無くても、branch が main の祖先なら「merged」と出る。実測で、一度も明示 merge していない worktree(branch tip が main の祖先)も「merged」判定された。stale 検出としては妥当(未取り込みの作業が無い)だが「merge commit があった」とは限らない
- **branch は remove で消えない** 【実測】: `git worktree remove` は worktree(ディレクトリ + 登録)だけ消す。branch は残る → 完全削除には別途 `git branch -d/-D <branch>`

### 設計への含意(git-workflow worktree 化の基本設計向け)

- **stale 検出**: 6.4 のコマンドで「merge 済み branch の worktree」を列挙 → 削除提案
- **削除フロー**: メイン repo から `git worktree remove`(中からはやらせない、6.1)。dirty なら `--force`(依頼者確認の上)。branch も消すなら `git branch -d` を併記
- **セッション安全**: 削除対象に別セッションが入っていても git は止めない(6.3 推論)→ 提案時に「その worktree に入っているセッションが無いか」は git 任せにできず、別途配慮が要る

---

## 7. EnterWorktree の乗り換え（複数 worktree の行き来）【実測】

- **複数回の乗り換えは可能**（`path` で既存 worktree に切替）。ただし worktree に入っている間は次の制約（実測）:
  - **`name`（新規作成）は不可** → `Already in a worktree session. Pass path to switch ... or use ExitWorktree to leave this one before creating a new worktree`。新規を作るには一度 `ExitWorktree` で抜ける
  - **`path` の切替先は `<repo>/.claude/worktrees/` 配下（Claude Code 管理）に限定** → **外部 worktree への*直接*切替は拒否**（`... is not under .../.claude/worktrees. Switching from this session is limited to worktrees managed by Claude Code`）
- **ただし外部 worktree も「メイン経由」なら行き来できる**【実測】: `worktree → ExitWorktree(keep) でメイン → EnterWorktree(path: 外部 worktree)` は成功する（メインからの初回入場は外部 OK のため。実測で外部 A → Exit → 外部 B に入れた）
- 「外部」の定義: `<repo>/.claude/worktrees/` 配下でないもの。クリーン案の「外部」= repo の作業ツリーの外（兄弟ディレクトリ）

### 含意（基本設計）

- 外部（repo の外）worktree でも、**1 セッションで複数を渡り歩ける**（各移動の間に `ExitWorktree` を 1 回挟むだけ）。前に書いた「外部だと複数を渡り歩けない／詰まる」は**誤りだったので訂正**
- `.claude/worktrees/` 配下の利点は「**Exit なしで直接連続切替できる**」点のみ（その代わり git status に漏れて gitignore が要る）。トレードオフは小さい
- （`.claude/worktrees/` 配下だけ直接連続切替を許す理由は未調査・スコープ外）
