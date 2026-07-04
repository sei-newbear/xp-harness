#!/usr/bin/env bash
# 検証用 sandbox 環境を構築する。
# Usage: setup-sandbox.sh <sandbox-name> [--bare|--wiremock|--compose]
#   既定: front / api 分離の Web アプリ構成 (実行基盤 + 領域別スキルつき)。
#         探索型スキル (implementation / e2e / e2e-execution) の検証前提。E2E は軽量 (Playwright webServer)。
#   --bare: アプリなしの最小構成 (git repo + apm install のみ)。
#           プローブによる連鎖発火確認など、アプリが不要な検証用。
#   --wiremock: 外部 API モック構成 (api + WireMock(Docker))。
#           外部 API をモックする E2E で「モック検証の厳密さ」を確認する検証用。
#           緩い既存テスト + 「全パラメータ検証」規約スキル + 仕様書を同梱 (= 検証材料)。
#           docs/working/ にサンプルの要件/設計を同梱。実際の検証では筋書きを差し替えること。
#   --compose: front / api / PostgreSQL の docker-compose フルスタック構成。
#           api 規約が route/service/repository の 3 層分離を必須にし、repository は実 DB (postgres) を触る
#           (= 層が実体を持つ)。E2E は compose で起動したフルスタックに対して実行するため「重い」
#           (= E2E 実行の重さに関わる振る舞いの検証用)。docker が必要。
# 作成先: <xp-harness の親ディレクトリ>/xp-harness-test/<sandbox-name>/
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 <sandbox-name> [--bare|--wiremock|--compose]" >&2
  exit 1
fi

NAME="$1"
case "${2:-}" in
  "")         MODE=webapp ;;
  --bare)     MODE=bare ;;
  --wiremock) MODE=wiremock ;;
  --compose)  MODE=compose ;;
  *) echo "Usage: $0 <sandbox-name> [--bare|--wiremock|--compose]" >&2; exit 1 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/../templates"
HARNESS_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"
SANDBOX_PARENT="$(dirname "${HARNESS_ROOT}")/xp-harness-test"
SANDBOX="${SANDBOX_PARENT}/${NAME}"

if [ -e "${SANDBOX}" ]; then
  echo "ERROR: ${SANDBOX} は既に存在します。別名にするか、既存 sandbox を使い回してください。" >&2
  exit 1
fi

mkdir -p "${SANDBOX}"
cd "${SANDBOX}"

git init -q

cat > apm.yml <<EOF
name: ${NAME}
version: 1.0.0
description: xp-harness 動作検証用 sandbox (${NAME})
author: $(git config user.name 2>/dev/null || echo "xp-harness")
targets:
- claude
dependencies:
  apm:
  - ${HARNESS_ROOT}
  mcp: []
includes: auto
scripts: {}
EOF

cat > .gitignore <<'EOF'
# APM dependencies
apm_modules/

node_modules/
dist/
test-results/
playwright-report/
EOF

apm install

case "${MODE}" in
  webapp)
    # front / api 分離の Web アプリ構成 + 領域別スキルを複製する
    cp -a "${TEMPLATES_DIR}/webapp/." "${SANDBOX}/"
    echo ""
    echo "依存をインストールしています (api / front / e2e)..."
    (cd api && npm install --silent)
    (cd front && npm install --silent)
    (cd e2e && npm install --silent)
    (cd e2e && npx playwright install chromium 2>&1 | tail -1)
    echo "スモーク E2E で実行基盤を確認しています..."
    if (cd e2e && npm test > /tmp/sandbox-smoke.log 2>&1); then
      echo "スモーク E2E: green"
    else
      echo "WARNING: スモーク E2E が失敗しました。/tmp/sandbox-smoke.log を確認してください。" >&2
    fi
    ;;
  wiremock)
    # 外部 API モック構成 (api + WireMock(Docker)) を複製する
    cp -a "${TEMPLATES_DIR}/wiremock-api/." "${SANDBOX}/"
    echo ""
    echo "依存をインストールしています (api)..."
    (cd api && npm install --silent)
    echo "WireMock イメージを取得しています..."
    docker pull wiremock/wiremock:latest > /dev/null 2>&1 || echo "WARNING: docker pull に失敗。docker が使えるか確認してください。" >&2
    echo "既存テストで実行基盤を確認しています..."
    if (cd api && npm test > /tmp/sandbox-wiremock.log 2>&1); then
      echo "既存 E2E: green"
    else
      echo "WARNING: 既存 E2E が失敗しました。/tmp/sandbox-wiremock.log を確認してください。" >&2
    fi
    ;;
  compose)
    # front / api / postgres の docker-compose フルスタック構成を複製する
    cp -a "${TEMPLATES_DIR}/webapp-compose/." "${SANDBOX}/"
    echo ""
    echo "依存をインストールしています (api / front / e2e、ホスト側)..."
    (cd api && npm install --silent)
    (cd front && npm install --silent)
    (cd e2e && npm install --silent)
    (cd e2e && npx playwright install chromium 2>&1 | tail -1)
    echo "スモーク E2E で実行基盤を確認しています (compose ビルド・起動を含むため時間がかかる)..."
    if (cd e2e && npm run e2e > /tmp/sandbox-compose-smoke.log 2>&1); then
      echo "スモーク E2E: green (フルスタック compose 起動 → Playwright → 停止)"
    else
      echo "WARNING: スモーク E2E が失敗しました。/tmp/sandbox-compose-smoke.log を確認してください (docker が使えるか含めて)。" >&2
    fi
    ;;
  bare)
    : # 最小構成、追加の複製なし
    ;;
esac

git add -A
case "${MODE}" in
  webapp)   git commit -q -m "sandbox 初期状態 (apm install 済、front/api 分離構成 + 領域別スキル)" ;;
  bare)     git commit -q -m "sandbox 初期状態 (apm install 済、最小構成)" ;;
  wiremock) git commit -q -m "sandbox 初期状態 (apm install 済、外部 API モック構成 + WireMock)" ;;
  compose)  git commit -q -m "sandbox 初期状態 (apm install 済、docker-compose フルスタック構成 + postgres)" ;;
esac

echo ""
echo "sandbox 構築完了: ${SANDBOX}"
case "${MODE}" in
  webapp)
    echo "構成: front (Vite+React) / api (Hono) / e2e (Playwright、webServer で両サーバ自動起動)"
    echo "領域別スキル: front-implementation / api-implementation (対照規約: interface vs type、コメント禁止 vs JSDoc 必須) / e2e-playwright-front"
    echo "E2E 実行手順: e2e/README.md (スキルでない規約ファイルとして「読む」枝の探索対象)"
    ;;
  wiremock)
    echo "構成: api (Hono) + WireMock(Docker) で外部 API をモックする E2E"
    echo "検証材料: 緩い既存テスト (api/test) + 規約スキル e2e-api-wiremock (モックは全パラメータ検証) + 外部 API 仕様書 (api/docs)"
    echo "docs/working/ はサンプル筋書き。実際の検証対象に合わせて筋書きを差し替え、ノーヒント原則で点検してから走らせること (使い方の詳細は harness-verification skill 本文)。"
    ;;
  compose)
    echo "構成: front (Vite+React) / api (Hono) / db (PostgreSQL) の docker-compose フルスタック"
    echo "領域別スキル: front-implementation / api-implementation (route/service/repository 3層分離、repository は実 postgres を触る) / e2e-playwright-front"
    echo "E2E 実行手順: e2e/README.md (compose 起動を含む重い実行。'cd e2e && npm run e2e')"
    echo "DB シード: db/init.sql (tasks テーブル + サンプル行)。層が実体を持ち、E2E が compose 起動で重い構成。"
    ;;
esac
echo "deploy された skill / agent:"
ls .claude/skills/ 2>/dev/null | sed 's/^/  skill: /'
ls .claude/agents/ 2>/dev/null | sed 's/^/  agent: /'
