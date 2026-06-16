# skill 開発の TDD / eval 方法論導入

## 背景 / Why

harness の skill を変更したとき「期待通りに発火するか / 想定通りに動くか」を機械的に検証する方法論が無い。現状は実 session で動かして観察する手動検証のみ。skill 発火と挙動を eval セットで検証する業界先行事例を参考に、skill TDD の方法論導入を検討する。

## 状況

harness の skill を変更したとき「期待通りに発火するか / 想定通りに動くか」を機械的に検証する方法論が無い。現状は実 session で動かして観察する手動検証のみ。

skill 発火と挙動を eval セットで検証する業界先行事例を参考に、skill TDD の方法論導入を検討する。

## 取り組む内容

- 失敗するシナリオ (skill が発火しないクエリ / 誤発火するクエリ) を eval セットとして用意
- skill 変更時に eval を回して挙動差分を確認
- skill description の発火精度を機械的にチューニング

## 再開時の起点

1. チーム配布が見えてきたか確認
2. 中間案 (簡易 eval 習慣) を先に導入するか議論
3. 業界の skill eval 方法論を参考に harness 用に翻訳

## 具体手法の実績 (2026-05-25、実装 / E2E実行 skill 新設の検証で実践)

**headless consumer-repo eval** を実践した: テスト用 consumer repo (xp-harness を install + 上書き skill を配置) で `claude -p --output-format stream-json --verbose` を回し、出力 / セッション transcript を grep して「どの skill が Skill tool で発火したか / Read されたか / subagent が名指し skill を辿ったか」を観測。**distinctive な目印規約** (例: 公開関数名 `<layer>__` プレフィックス、実行コマンド名) を skill に仕込むと、それがコード / レビューに現れるかで「skill が実際に効いたか」を判定できる。これを eval 手法の土台にできる。
