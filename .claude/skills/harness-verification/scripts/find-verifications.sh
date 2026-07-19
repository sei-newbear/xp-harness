#!/bin/bash
# 検証記録 (references/*.md) の検索。引数なしで一覧、キーワードで grep。
set -o pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../references" && pwd)"
shopt -s nullglob
recs=()
for f in "$DIR"/*.md; do
  [ "$(basename "$f")" = "README.md" ] && continue
  recs+=("$f")
done

if [ "${#recs[@]}" -eq 0 ]; then
  echo "(検証記録なし: $DIR)"; exit 0
fi

if [ $# -eq 0 ]; then
  echo "# 検証記録 (${#recs[@]} 件)"
  for f in "${recs[@]}"; do
    v=$(grep -m1 '^verdict:' "$f" | sed 's/^verdict: *//')
    p=$(grep -m1 '^目的:' "$f" | sed 's/^目的: *//')
    echo "- $(basename "$f" .md)  [${v:-?}]  ${p:-?}"
  done
  echo
  echo "検索: find-verifications.sh <キーワード> (目的/対象/結果 を横断 grep)"
else
  kw="$*"
  hit=0
  for f in "${recs[@]}"; do
    if grep -qiF "$kw" "$f"; then
      hit=1
      echo "===== $(basename "$f") ====="
      grep -nE '^(目的|対象|verdict):' "$f"
      grep -niF "$kw" "$f" | head -6 | sed 's/^/  /'
      echo
    fi
  done
  if [ "$hit" -eq 0 ]; then echo "(「$kw」に一致する記録なし)"; fi
fi
