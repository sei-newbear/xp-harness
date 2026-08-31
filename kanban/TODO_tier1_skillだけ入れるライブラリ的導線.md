# skill だけ入れるライブラリ的導線 (ルールなし配布)

## 背景 / Why

xp-harness は現状、運用ルール (instruction) と skill 群と subagent をセットで配る「チームを提供するフレームワーク」の形をしている。任せて自走させるケースには合うが、アジャイルの練度が高いチームや、人間とペアプロする場面では過剰になる。

過剰さの中心は instruction。フェーズ駆動の型と subagent 呼び出しの規律が常時注入され、呼んでいない skill が勝手に発火する。一方 skill 自体は練度が高くても価値がある (E2E の流儀、ストーリー分割の判定軸など)。要らないのは skill ではなく instruction、という切り分け。

「要件定義と対話の原則だけ入れれば事足りる」ようなケースが実際にある、というのが出発点。

## 状況

実現可能性は調査済み (2026-08-29 実機確認)。

**APM 経由では instruction をオフにできない**:

- `includes` は pack (配布物の作成) の話で、install 時の deploy には効かない。明示パスリストにしても空リストにしても instruction は deploy された
- deploy 後に `.claude/rules/main.md` を手で消しても、次の `apm install` で戻る
- `apm uninstall` はパッケージ単位で、primitive 単位では外せない

**`gh skill install` なら実現する**:

- skill 単位で入り、instruction は最初から来ない (sandbox で 1 skill だけ入れて確認)
- ローカルディレクトリからも GitHub リポジトリからも入る。Claude Code 以外のエージェントにも配れる
- 配布 skill は補助ファイルを持たず SKILL.md 単体で完結するので、取りこぼしが起きない

**副作用**:

- `gh skill` は skill しか扱わないので subagent が配られない
- 1 コマンドで全 skill をまとめて入れる形式はなく、skill 名を 1 つずつ指定する

## 決めること

1. **subagent が配られないことをどう扱うか** (諦める / 別導線を用意する)。人間がペアプロ相手ならレビュアーは呼ばなくてよいという話もあり、必ずしも欠損とは限らない
2. **どの skill の組み合わせを推奨として示すか**。skill 間に依存があり、単体で立つものと他の skill を呼ぶものが分かれる
   - 単体で立つ: `e2e` / `e2e-execution` / `git-workflow` / `handoff-docs` / `implementation` / `propose-options` / `story-slicing`
   - 他の skill を呼ぶ: `slice-tdd` / `define-requirements` / `basic-design` / `retrospective` / `research-spike` / `dialogue-principles`

## 再開時の起点

上の 2 つを決めてから README に導線を書く。

順序について: 別カード「要件定義のスタンスと聞く深さの分離」が先という議論をしている。instruction を外しても、`define-requirements` が依頼を仮説として扱うスタンスは skill 本体から来るので残るため。ルールなし導線だけ先に用意しても、過剰さは半分しか消えない。
