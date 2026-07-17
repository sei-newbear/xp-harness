# slice-tdd skill の名前再検討

## 背景 / Why

`slice-tdd` という skill 名が、この skill が担う役割の広さに対して適切かを再検討したい。skill 名は呼び出し側に対する interface (description と並ぶ重要な signal) なので、責務と一致しないとミスマッチが起き続ける。

## 優先度メモ (2026-07-18 backlog へ降格)

当初は依頼者明示で tier1 だったが、実運用で slice-tdd が **ちゃんと発火している** ことを確認 (依頼者観測)。名前と責務のミスマッチが実害 (発火漏れ) として顕在化していないため、backlog へ降格。名前の違和感自体は残るので廃棄はしない。発火漏れが観測されたら tier1 に戻す。

## 状況

`slice-tdd` という skill 名が、この skill が担う役割の広さに対して適切かを再検討したい。現在の skill description は「コード書く / テスト書く / リファクタ / バグ修正 / E2E spec 追加 / 既存仕様への小さな修正 / 実装フェーズの作業など、コードに触る作業すべて」と広い。一方で名前は「slice (分割) + TDD」と TDD リズム寄りで、責務範囲を狭く見せている。

skill 名は呼び出し側に対する interface (description と並ぶ重要な signal) なので、責務と一致しないとミスマッチが起き続ける (ただし現時点で発火漏れは観測されておらず、上記メモの通り backlog 扱い)。

## 再開時の起点

1. この skill の本当の責務範囲を 1 文で書き出す (TDD リズム + 分割 + 実装フェーズ全般 のどこまでか)
2. 候補名の発散 (例: `implementation`, `tdd-cycle`, `incremental-implementation`, `dev-loop` 等) — `propose-options` で議論
3. 名前変更に伴う他箇所の更新範囲を見積もる (instruction / 他 skill から `slice-tdd` を参照している箇所、subagent の preload `skills:`、`code-reviewer.md` の preload 等)
