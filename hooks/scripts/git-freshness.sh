#!/usr/bin/env bash
# git 最新化支援 hook (SessionStart / UserPromptSubmit)。
#
# 目的: 自走するエージェントが stale なローカル状態で作業を始めないよう、
#       remote が進んでいることに「気づき」を注入する支援 hook。
#
# 振る舞い:
#   - SessionStart (または event 不明): 無条件で fetch する。
#   - UserPromptSubmit: 前回 fetch から一定時間(既定 24h)超のときだけ fetch する
#     (毎依頼でネットワークを叩かないため)。
#   - fetch 成功して HEAD より origin の主ブランチが進んでいれば、その差分を stdout に注入。
#   - fetch 失敗(オフライン/remote 無し/timeout)なら、前回 fetch からの経過が古い場合だけ
#     「fetch して」と案内する(フォールバック)。失敗そのものには触れない。
#   - 何も伝えることが無ければ黙る。常に exit 0 (ブロック・矯正しない = 支援)。
#
# 注意: stdout に出した文字列がエージェントの context に注入される (exit 0)。
#       jq には依存しない (consumer 環境に無い可能性があるため)。

set -uo pipefail

# 既定値。閾値のカスタマイズ機構は要件のスコープ外なので env override は設けない
# (将来必要になったら別途)。
THRESHOLD_SECONDS=$((24 * 60 * 60))   # 24h
FETCH_TIMEOUT_SECONDS=10

# git repo でなければ静かに終了。
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# --- stdin から hook event を判定 (jq 非依存) ---
input="$(cat 2>/dev/null || true)"
event="SessionStart"
case "$input" in
  *'"hook_event_name":"UserPromptSubmit"'* | *'"hook_event_name": "UserPromptSubmit"'*)
    event="UserPromptSubmit" ;;
esac

# --- ファイルの mtime (エポック秒) を portable に取る ---
mtime_of() {
  local f="$1"
  [ -e "$f" ] || return 1
  stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null
}

fetch_head_path() {
  local gitdir
  gitdir="$(git rev-parse --git-dir 2>/dev/null)" || return 1
  printf '%s/FETCH_HEAD' "$gitdir"
}

# 前回 fetch からの経過秒。FETCH_HEAD が無ければ「非常に古い」扱いで大きな値。
seconds_since_last_fetch() {
  local fh now mt
  fh="$(fetch_head_path)" || { echo 999999999; return; }
  if [ ! -e "$fh" ]; then echo 999999999; return; fi
  now="$(date +%s)"
  mt="$(mtime_of "$fh")" || { echo 999999999; return; }
  echo $(( now - mt ))
}

# origin の主ブランチ ref を解決 (origin/HEAD → 無ければ origin/main → origin/master)。
base_ref() {
  local ref
  ref="$(git symbolic-ref -q refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/@@')"
  if [ -n "$ref" ]; then printf '%s' "$ref"; return; fi
  if git rev-parse --verify -q origin/main >/dev/null 2>&1; then printf 'origin/main'; return; fi
  if git rev-parse --verify -q origin/master >/dev/null 2>&1; then printf 'origin/master'; return; fi
  printf 'origin/main'
}

# timeout があれば使う。
run_fetch() {
  if command -v timeout >/dev/null 2>&1; then
    timeout "$FETCH_TIMEOUT_SECONDS" git fetch --quiet origin >/dev/null 2>&1
  elif command -v gtimeout >/dev/null 2>&1; then
    # macOS + coreutils では timeout でなく gtimeout。
    gtimeout "$FETCH_TIMEOUT_SECONDS" git fetch --quiet origin >/dev/null 2>&1
  else
    git fetch --quiet origin >/dev/null 2>&1
  fi
}

# fetch を試す前に「前回 fetch の有無と経過」を測る。失敗した fetch が FETCH_HEAD を
# 新規作成/mtime 書き換えするため、フォールバック判定・UserPromptSubmit のゲートは
# この「fetch 前の状態」を使う。
fh_before="$(fetch_head_path 2>/dev/null || true)"
had_fetch_head=0
[ -n "$fh_before" ] && [ -e "$fh_before" ] && had_fetch_head=1
age="$(seconds_since_last_fetch)"

# --- fetch するか決める ---
should_fetch=1
if [ "$event" = "UserPromptSubmit" ] && [ "$age" -le "$THRESHOLD_SECONDS" ]; then
  should_fetch=0
fi

if [ "$should_fetch" -eq 0 ]; then
  exit 0
fi

if run_fetch; then
  # fetch 成功 → 未取り込みコミット数を算出。
  ref="$(base_ref)"
  behind="$(git rev-list --count "HEAD..$ref" 2>/dev/null || echo 0)"
  if [ "${behind:-0}" -gt 0 ]; then
    echo "git 最新化のお知らせ: ${ref} が ${behind} コミット進んでいます (未取り込み)。取り込みを検討してください。"
  fi
  exit 0
fi

# fetch 失敗 → フォールバック: 過去に一度でも fetch していて、その経過が古ければ案内。
# 一度も fetch していない (FETCH_HEAD 不在) なら「経過時間」を騙れないので静かに抜ける (設計 §4)。
if [ "$had_fetch_head" -eq 1 ] && [ "$age" -gt "$THRESHOLD_SECONDS" ]; then
  hours=$(( age / 3600 ))
  echo "git 最新化のお知らせ: 前回の同期から約 ${hours} 時間経過しています。git fetch で最新化してください。"
fi
exit 0
