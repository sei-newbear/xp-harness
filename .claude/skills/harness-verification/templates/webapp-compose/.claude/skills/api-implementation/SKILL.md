---
description: このプロジェクトの api/ 配下のコード (HTTP API・ドメイン/ユースケース・永続化) を書く・変更するときに発火させる api 領域の実装規約。クリーンアーキテクチャのレイヤ分離・依存の向き・テスト戦略・型定義・エラー処理の規約を扱う。
---

# api の実装規約（クリーンアーキテクチャ）

## レイヤ構成（`src/` 配下）

内側から外側へ 4 レイヤに分離する。**依存の向きは常に外→内**（外側が内側を知る。内側は外側を知らない）:

- **domain/**: エンティティと、それ自体で完結するドメインのルール。外部依存なし（DB も HTTP も知らない）。例: `Task` 型、優先度の順序（high > mid > low）の比較ルール
- **usecase/**: アプリケーションのユースケース。ドメインを使い、処理を束ねる。永続化は **repository のインターフェース越し** に使う（実装は知らない）
- **gateway/**: repository インターフェースの実装。永続化（PostgreSQL）を担う
- **route/**: HTTP のハンドリング（Hono）。usecase を呼び、結果を HTTP に変換する

repository のインターフェースは usecase 側が要求する形で定義し（例: `usecase/ports.ts`）、gateway がそれを実装する（依存性の逆転）。

## テスト戦略

- **ロジックのある内側（domain / usecase）はユニットテストで駆動する**（`*.test.ts` を対象ファイルの隣に置く、`npm test` = vitest）。usecase のテストでは repository インターフェースをモックに差し替え、ロジックだけを検証する
- **gateway（DB アクセス）と route（HTTP 配線）は E2E で担保する**（薄い配線・永続化はユニットテストを書かず、フルスタック E2E がカバーする）

## その他

- 型定義は `type` エイリアスを使う（`interface` は使わない）
- 公開関数には 1 行の JSDoc コメントを必ず書く
- エラーは内側の層で throw せず戻り値で返し、route 層で HTTP status に変換する
- 永続化先は PostgreSQL。接続は `src/db.ts` の `pool` を使う（env `DATABASE_URL`、`pool.query(...)`）。SQL を書くのは gateway だけ
