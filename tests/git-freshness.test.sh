#!/usr/bin/env bash
# git-freshness.sh の fixture ベーステスト (改修者向け・非配布)。
# ローカル bare repo を origin にしてネットワーク無しで決定的に検証する。
# 実行: bash tests/git-freshness.test.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOK="$ROOT/.apm/hooks/scripts/git-freshness.sh"
THRESHOLD_SECONDS=$((24 * 60 * 60))

pass=0
fail=0

# 各テストは独立した一時ディレクトリで git 状態を仕込む。
# $WORK にクローン、$REMOTE に bare origin。
setup() {
  WORK="$(mktemp -d)"
  REMOTE="$(mktemp -d)"
  git init -q --bare -b main "$REMOTE"
  git init -q -b main "$WORK"
  git -C "$WORK" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init
  git -C "$WORK" remote add origin "$REMOTE"
  git -C "$WORK" push -q origin main
  git -C "$WORK" branch -q --set-upstream-to=origin/main main
}

teardown() { rm -rf "$WORK" "$REMOTE"; }

# origin 側に N 個のコミットを進める (別クローン経由)。
advance_remote() {
  local n="$1" tmp
  tmp="$(mktemp -d)"
  git clone -q "$REMOTE" "$tmp"
  for i in $(seq 1 "$n"); do
    git -C "$tmp" -c user.email=t@t -c user.name=t commit -q --allow-empty -m "remote-$i"
  done
  git -C "$tmp" push -q origin main
  rm -rf "$tmp"
}

run_hook() { ( cd "$WORK" && bash "$HOOK" </dev/null 2>/dev/null ); }
run_hook_exit() { ( cd "$WORK" && bash "$HOOK" </dev/null >/dev/null 2>&1; echo $? ); }
run_hook_ups() { ( cd "$WORK" && printf '%s' '{"hook_event_name":"UserPromptSubmit"}' | bash "$HOOK" 2>/dev/null ); }

# FETCH_HEAD の mtime を「古い」時刻に偽装する。
age_fetch_head() {
  local fh old
  fh="$WORK/.git/FETCH_HEAD"
  [ -e "$fh" ] || return 0
  old=$(( $(date +%s) - THRESHOLD_SECONDS - 3600 ))
  touch -d "@$old" "$fh" 2>/dev/null || touch -t "$(date -r "$old" +%Y%m%d%H%M.%S 2>/dev/null || echo 202001010000)" "$fh"
}

assert_contains() {
  local out="$1" needle="$2" name="$3"
  if printf '%s' "$out" | grep -q -- "$needle"; then
    echo "  ok: $name"; pass=$((pass+1))
  else
    echo "  FAIL: $name — 期待に '$needle' を含むはずが: [$out]"; fail=$((fail+1))
  fi
}

assert_empty() {
  local out="$1" name="$2"
  if [ -z "$(printf '%s' "$out" | tr -d '[:space:]')" ]; then
    echo "  ok: $name"; pass=$((pass+1))
  else
    echo "  FAIL: $name — 空のはずが: [$out]"; fail=$((fail+1))
  fi
}

assert_eq() {
  local got="$1" want="$2" name="$3"
  if [ "$got" = "$want" ]; then echo "  ok: $name"; pass=$((pass+1));
  else echo "  FAIL: $name — got=$got want=$want"; fail=$((fail+1)); fi
}

echo "test: 最新化済み (origin/main 未前進) → 黙る"
setup
out="$(run_hook)"
assert_empty "$out" "up-to-date は黙る"
teardown

echo "test: origin/main が 2 進んでいる → コミット数を案内"
setup
advance_remote 2
out="$(run_hook)"
assert_contains "$out" "2" "未取り込み 2 を伝える"
assert_contains "$out" "git-workflow" "作業前に git-workflow の同期手順へ誘導する"
teardown

echo "test: 常に exit 0 (ブロックしない)"
setup
advance_remote 1
assert_eq "$(run_hook_exit)" "0" "exit 0"
teardown

echo "test: 過去に fetch 済みで古い + remote 到達不可 → fetch 案内(フォールバック)"
setup
git -C "$WORK" fetch -q origin                              # 本物の FETCH_HEAD を作る
age_fetch_head                                              # 古く偽装
git -C "$WORK" remote set-url origin /nonexistent-remote-xyz # 到達不可に
out="$(run_hook)"
assert_contains "$out" "最新化" "フォールバックで最新化を案内"
assert_eq "$(run_hook_exit)" "0" "フォールバック経路でも exit 0"
teardown

echo "test: 一度も fetch していない + remote 到達不可 → 黙る(設計§4)"
setup
git -C "$WORK" remote set-url origin /nonexistent-remote-xyz
out="$(run_hook)"
assert_empty "$out" "未 fetch + 到達不可は黙る(嘘の経過時間を出さない)"
assert_eq "$(run_hook_exit)" "0" "未 fetch + 到達不可でも exit 0"
teardown

echo "test: UserPromptSubmit + 前回fetchが新しい → fetchせず黙る(remote前進を見ない)"
setup
git -C "$WORK" fetch -q origin      # 新鮮な FETCH_HEAD を作る
advance_remote 2                    # remote は進むが手元は fetch しない
out="$(run_hook_ups)"
assert_empty "$out" "新しければ UserPromptSubmit は黙る"
assert_eq "$( ( cd "$WORK" && printf '%s' '{"hook_event_name":"UserPromptSubmit"}' | bash "$HOOK" >/dev/null 2>&1; echo $? ) )" "0" "UPS 新鮮でも exit 0"
teardown

echo "test: UserPromptSubmit + 前回fetchが古い → fetchして報告"
setup
git -C "$WORK" fetch -q origin
advance_remote 2
age_fetch_head                      # FETCH_HEAD を古く偽装
out="$(run_hook_ups)"
assert_contains "$out" "2" "古ければ UserPromptSubmit は fetch して 2 を報告"
teardown

echo "test: UserPromptSubmit のコロン後スペース表記も認識する"
setup
git -C "$WORK" fetch -q origin
advance_remote 2
age_fetch_head
out="$( ( cd "$WORK" && printf '%s' '{"hook_event_name": "UserPromptSubmit"}' | bash "$HOOK" 2>/dev/null ) )"
assert_contains "$out" "2" "空白あり表記でも UserPromptSubmit として扱う"
teardown

echo "test: 主ブランチが master でも未取り込みを検知(base_ref フォールバック)"
WORK="$(mktemp -d)"; REMOTE="$(mktemp -d)"
git init -q --bare -b master "$REMOTE"
git init -q -b master "$WORK"
git -C "$WORK" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init
git -C "$WORK" remote add origin "$REMOTE"
git -C "$WORK" push -q origin master
git -C "$WORK" branch -q --set-upstream-to=origin/master master
_tmp="$(mktemp -d)"; git clone -q "$REMOTE" "$_tmp"
for i in 1 2 3; do git -C "$_tmp" -c user.email=t@t -c user.name=t commit -q --allow-empty -m "r-$i"; done
git -C "$_tmp" push -q origin master; rm -rf "$_tmp"
out="$(run_hook)"
assert_contains "$out" "3" "origin/master 基準で 3 を報告"
rm -rf "$WORK" "$REMOTE"

echo
echo "PASS=$pass FAIL=$fail"
[ "$fail" -eq 0 ]
