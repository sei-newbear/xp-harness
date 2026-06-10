#!/usr/bin/env bash
# PreToolUse(Bash) 改修者ローカル安全装置:
# claude -p / --print (ヘッドレス = 2026-06-15~ 従量課金) を弾く。
# interactive (サブスク枠) で起動すること。harness-verification の鉄則のローカル enforcement。
cmd=$(jq -r '.tool_input.command // ""')
if printf '%s' "$cmd" | grep -Eq 'claude[^;&|]*[[:space:]](-p|--print)([[:space:]=]|$)'; then
  echo "blocked: claude -p / --print はヘッドレス=従量課金 (2026-06-15~)。interactive (サブスク枠) で起動してください。" >&2
  exit 2
fi
exit 0
