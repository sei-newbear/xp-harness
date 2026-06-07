---
description: このプロジェクトの api/ 配下のコード (HTTP API・ビジネスロジック・永続化) を書く・変更するときに発火させる api 領域の実装規約。レイヤ分離・型定義・コメント・エラー処理の規約を扱う。
---

# api の実装規約

- routes / services / repositories の 3 レイヤに分離する（ルートハンドラにビジネスロジックを書かない）
- 型定義は `type` エイリアスを使う（`interface` は使わない）
- 公開関数には 1 行の JSDoc コメントを必ず書く
- ビジネスロジック層はエラーを throw せず戻り値で返し、ルートハンドラ層で HTTP status に変換する
- 永続化は repositories 層に隔離する（services から直接ファイルや DB を触らない）
