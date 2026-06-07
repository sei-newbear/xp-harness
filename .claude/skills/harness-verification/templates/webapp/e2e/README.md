# E2E の実行手順

このプロジェクトの E2E (Playwright) を動かす手順。

## 初回セットアップ

```bash
cd e2e
npm install
npx playwright install chromium
```

## 実行

```bash
cd e2e
npm test
```

Playwright の webServer 設定が api (port 3001) と front (port 5173) を自動起動するので、手動でサーバを立てる必要はない。

単一 spec の実行:

```bash
cd e2e
npx playwright test specs/<対象>.spec.ts
```

## 失敗時の対処

- `e2e/test-results/` のトレース・スクリーンショットを確認する
- ポート 3001 / 5173 に前回のプロセスが残っていないか確認する (`lsof -i :3001 -i :5173`)
- api 単体の動作確認: `cd api && npm run dev` して `curl http://localhost:3001/health`
