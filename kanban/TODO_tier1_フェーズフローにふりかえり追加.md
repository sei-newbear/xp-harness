# main instruction のフェーズフローに「ふりかえり」を追加

## 背景 / Why

`.apm/instructions/main.instructions.md` のフェーズフロー section は現在「要件定義 → 基本設計 → 実装」で、ふりかえりが含まれない。ふりかえり skill の description だけでは main session の発火が不安定な場合、フェーズフロー section に明示する方が発火しやすい (機能拡張 / 構造改修)。

## 状況

`.apm/instructions/main.instructions.md` のフェーズフロー section は現在 **要件定義 → 基本設計 → 実装** で、ふりかえりが含まれない。

ふりかえり skill 新設で skill 自体は追加するが、main instruction の「フェーズフロー」section は今回触らない (= 要件のスコープ外 #6 と整合)。

ただし、ふりかえり skill の description だけでは main session の発火が不安定で、フェーズフロー section に明示する方が発火しやすい場合は、本 TODO で追加する。

## 注意: 重複削減系の項目との関係

「フェーズフロー section の削除 or スリム化」「各フェーズ振る舞いの skill 重複解消」「main.instructions.md 全体の skill 重複洗い出し」と **方向性が衝突する可能性**。スリム化 (= section を削る) と「ふりかえりを追加」(= section に項目を増やす) は対立する。本 TODO に着手する前に、これら重複削減系の方針が固まっているか確認、調整が必要。

## 再開時の起点

1. ふりかえり skill 運用結果を観察、main の発火が安定しているか評価
2. 不安定と判明したら、main instruction の方針整理 (上記重複削減系の項目) と並走させながら、フェーズフロー section に「ふりかえり」を追加する判断
3. 追加する場合の書き方: 既存「要件定義 → 基本設計 → 実装」に「→ ふりかえり」を 1 行追加、または別 section として独立
