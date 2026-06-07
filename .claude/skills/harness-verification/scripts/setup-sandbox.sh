#!/usr/bin/env bash
# 検証用 sandbox 環境を構築する。
# Usage: setup-sandbox.sh <sandbox-name> [--bare]
#   既定: front / api 分離の Web アプリ構成 (実行基盤 + 領域別スキルつき)。
#         探索型スキル (implementation / e2e / e2e-execution) の検証前提。
#   --bare: アプリなしの最小構成 (git repo + apm install のみ)。
#           プローブによる連鎖発火確認など、アプリが不要な検証用。
# 作成先: <xp-harness の親ディレクトリ>/xp-harness-test/<sandbox-name>/
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 <sandbox-name> [--bare]" >&2
  exit 1
fi

NAME="$1"
BARE=false
if [ "${2:-}" = "--bare" ]; then
  BARE=true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../templates/webapp"
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

if [ "${BARE}" = false ]; then
  # front / api 分離の Web アプリ構成 + 領域別スキルを複製する
  cp -a "${TEMPLATE_DIR}/." "${SANDBOX}/"

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
fi

git add -A
if [ "${BARE}" = true ]; then
  git commit -q -m "sandbox 初期状態 (apm install 済、最小構成)"
else
  git commit -q -m "sandbox 初期状態 (apm install 済、front/api 分離構成 + 領域別スキル)"
fi

echo ""
echo "sandbox 構築完了: ${SANDBOX}"
if [ "${BARE}" = false ]; then
  echo "構成: front (Vite+React) / api (Hono) / e2e (Playwright、webServer で両サーバ自動起動)"
  echo "領域別スキル: front-implementation / api-implementation (対照規約: interface vs type、コメント禁止 vs JSDoc 必須) / e2e-playwright-front"
  echo "E2E 実行手順: e2e/README.md (スキルでない規約ファイルとして「読む」枝の探索対象)"
fi
echo "deploy された skill / agent:"
ls .claude/skills/ 2>/dev/null | sed 's/^/  skill: /'
ls .claude/agents/ 2>/dev/null | sed 's/^/  agent: /'
