#!/usr/bin/env bash
# E2E をフルスタック (docker compose: db + api + front) に対して実行する。
# compose を起動 → Playwright 実行 → 後片付け。引数はそのまま playwright に渡す。
set -euo pipefail

cd "$(dirname "$0")"
COMPOSE="docker compose -f ../docker-compose.yml"

echo "[e2e] compose 起動中 (db + api + front のビルド・起動を待つ)..."
$COMPOSE up -d --build --wait

cleanup() {
  echo "[e2e] compose 停止中..."
  $COMPOSE down
}
trap cleanup EXIT

echo "[e2e] Playwright 実行..."
npx playwright test "$@"
