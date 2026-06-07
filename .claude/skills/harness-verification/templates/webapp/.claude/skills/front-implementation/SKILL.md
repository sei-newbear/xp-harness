---
description: このプロジェクトの front/ 配下のコード (React コンポーネント・UI ロジック) を書く・変更するときに発火させる front 領域の実装規約。コンポーネント設計・型定義・export・API 呼び出しの規約を扱う。
---

# front の実装規約

- コンポーネントは関数コンポーネントのみ。ファイル名・コンポーネント名は PascalCase
- 型定義は `interface` を使う（`type` エイリアスは使わない）
- export は named export のみ（default export は使わない。Vite のエントリポイント等、ツールが要求する場合だけ例外）
- コメントは書かない。名前とコードで意図を伝える
- 状態管理は React hooks のみ（外部状態管理ライブラリを入れない）
- API 呼び出しは `front/src/api/` 配下の client 関数に集約する（コンポーネントから fetch を直接呼ばない）
