# main.instructions.md の各フェーズの振る舞い section の skill 重複解消検討

## 背景 / Why

各フェーズ (要件定義 / 基本設計 / 実装) の振る舞いは対応する skill 側に既にあるはずで、重複していると context 二重課金 + drift リスクになる (重複削減)。

## 状況

`.apm/instructions/main.instructions.md` の「各フェーズの振る舞い」section は、各フェーズ (要件定義 / 基本設計 / 実装) の振る舞いを記述しているが、これらは対応する skill (`define-requirements`, `basic-design`, `slice-tdd` 等) 側に既にあるはず。重複していると context 二重課金 + drift リスク。

## 再開時の起点

1. main.instructions.md の「各フェーズの振る舞い」section と、対応 skill 本文を突き合わせて重複箇所を識別
2. 重複しているなら main 側を削除し、skill 側を single source of truth にする
3. instruction 側に残すべき責務 (フェーズ横断のルール、phase switching の判断軸 等) と、skill 側に委譲すべき責務 (各フェーズ内の振る舞い詳細) の境界を再定義
