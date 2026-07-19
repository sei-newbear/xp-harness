#!/bin/bash
# 検証記録 (references/*.md) の format 点検。frontmatter 5キー + 2 section が必須。
# 新規記録を足したら通す。format 違反があれば exit 1。
set -o pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../references" && pwd)"
shopt -s nullglob
fail=0
n=0
for f in "$DIR"/*.md; do
  [ "$(basename "$f")" = "README.md" ] && continue
  n=$((n+1))
  errs=()
  head -1 "$f" | grep -qx -- '---' || errs+=("1行目が frontmatter 開始 '---' でない")
  for k in 目的 対象 verdict 日付 モデル; do
    grep -qE "^${k}: *[^ ]" "$f" || errs+=("ヘッダ '${k}:' が欠落 or 空")
  done
  grep -qE '^日付: *[0-9]{4}-[0-9]{2}-[0-9]{2}' "$f" || errs+=("日付が YYYY-MM-DD 形式でない")
  grep -qE '^## 条件' "$f" || errs+=("'## 条件' section が欠落")
  grep -qE '^## 結果' "$f" || errs+=("'## 結果' section が欠落")
  if [ "${#errs[@]}" -eq 0 ]; then
    echo "OK  $(basename "$f")"
  else
    fail=1
    echo "NG  $(basename "$f")"
    for e in "${errs[@]}"; do echo "    - $e"; done
  fi
done
echo "---"
if [ "$n" -eq 0 ]; then
  echo "(点検対象なし)"
elif [ "$fail" -eq 0 ]; then
  echo "→ 全 ${n} 記録が format 準拠"
else
  echo "→ format 違反あり"; exit 1
fi
