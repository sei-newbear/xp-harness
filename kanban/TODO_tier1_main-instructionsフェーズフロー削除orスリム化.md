# main.instructions.md のフェーズフロー section の削除またはスリム化

## 背景 / Why

`.apm/instructions/main.instructions.md` のフェーズフロー section が context に乗る重量に対して、得られる価値が見合わない可能性。なくすか、もっとスリムにできないか検討する (重複削減)。

## 状況

`.apm/instructions/main.instructions.md` のフェーズフロー section が context に乗る重量に対して、得られる価値が見合わない可能性。なくすか、もっとスリムにできないか検討する。

「section 分割精査」の項目とは別の観点 — そちらは「分割で Distribution Score 最適化」、こちらは「そもそも要らない section を削る」。

## 再開時の起点

1. 現フェーズフロー section の中身を読み返し、main session が実運用で参照する場面があるか確認
2. 同等の情報が skill 側 (`define-requirements`, `basic-design`, `slice-tdd` 等) でカバーされていないか照合
3. 削除 / スリム化の方針を決める (全削除 / 見出しだけ残す / 半分削る 等)
