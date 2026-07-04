# E2E の実行手順

このプロジェクトの E2E (Playwright) を動かす手順。E2E は **docker-compose で起動したフルスタック (db + api + front) に対して** 実行する。

## 初回セットアップ

```bash
cd e2e
npm install
npx playwright install chromium
```

## 実行

```bash
cd e2e
npm run e2e
```

`npm run e2e` (run-e2e.sh) が次を行う:

1. `docker compose up -d --build --wait` で db + api + front を起動（初回はイメージビルドがあり時間がかかる）
2. Playwright を実行
3. 終了時に `docker compose down` で後片付け

単一 spec の実行（スタックが既に上がっているとき）:

```bash
cd e2e
npx playwright test specs/<対象>.spec.ts
```

スタックだけ手動で上げ下げする場合はリポジトリ直下で:

```bash
docker compose up -d --build --wait   # 起動
docker compose down                   # 停止
```

## 失敗時の対処

- `e2e/test-results/` のトレース・スクリーンショットを確認する
- コンテナのログ: `docker compose logs api` / `docker compose logs front` / `docker compose logs db`
- スタックの状態: `docker compose ps`
- DB を作り直したいとき: `docker compose down -v`（ボリューム削除 → 次回起動で init.sql が再実行される）
