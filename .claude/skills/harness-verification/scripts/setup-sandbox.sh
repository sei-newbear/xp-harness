#!/usr/bin/env bash
# 検証用 sandbox 環境を構築する。
# Usage: setup-sandbox.sh <sandbox-name>
# 作成先: <xp-harness の親ディレクトリ>/xp-harness-test/<sandbox-name>/
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <sandbox-name>" >&2
  exit 1
fi

NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

git add -A
git commit -q -m "sandbox 初期状態 (apm install 済)"

echo ""
echo "sandbox 構築完了: ${SANDBOX}"
echo "deploy された skill / agent:"
ls .claude/skills/ 2>/dev/null | sed 's/^/  skill: /'
ls .claude/agents/ 2>/dev/null | sed 's/^/  agent: /'
