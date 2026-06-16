#!/usr/bin/env bash
# xp-harness 改修バックログ（かんばん）の状況表示。読み取り専用。
#   board.sh        … tier1 の TODO 一覧（次なにやるか）
#   board.sh todo   … TODO 全体（tier1 → backlog）
#   board.sh done   … DONE 一覧
#
# カードは <repo>/kanban/ の `ステータス_優先度_タイトル.md`。ファイル名だけ読む（本文は読まない）。
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || (cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd))"
KANBAN="$ROOT/kanban"

# ファイル名から「先頭 2 つの _」を落としてタイトルだけ取り出す
# （タイトル部に _ を含めない命名規約に依存。規約を破ると 3 つ目以降だけ残り静かに誤表示する）
title_of() { local b; b="$(basename "$1" .md)"; printf '%s\n' "${b#*_*_}"; }

count() { ls "$KANBAN/"$1 2>/dev/null | wc -l | tr -d ' '; }

list() {
  local glob="$1" f found=0
  for f in "$KANBAN/"$glob; do
    [ -e "$f" ] || continue
    found=1
    echo "- $(title_of "$f")"
  done
  [ "$found" -eq 1 ] || echo "(なし)"
}

case "${1:-tier1}" in
  tier1)
    echo "# TODO / tier1 ($(count 'TODO_tier1_*.md'))"
    echo
    list 'TODO_tier1_*.md'
    echo
    echo "— backlog $(count 'TODO_backlog_*.md') / DONE $(count 'DONE_*.md') （TODO 全体は \`board.sh todo\`、完了は \`board.sh done\`）"
    ;;
  todo)
    echo "# TODO"
    echo
    echo "## tier1 ($(count 'TODO_tier1_*.md'))"
    list 'TODO_tier1_*.md'
    echo
    echo "## backlog ($(count 'TODO_backlog_*.md'))"
    list 'TODO_backlog_*.md'
    echo
    echo "— DONE $(count 'DONE_*.md') 件（一覧は \`board.sh done\`）"
    ;;
  done)
    echo "# DONE ($(count 'DONE_*.md'))"
    echo
    list 'DONE_*.md'
    ;;
  *)
    echo "usage: board.sh [tier1|todo|done]" >&2
    exit 1
    ;;
esac
