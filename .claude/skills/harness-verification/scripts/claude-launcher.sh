#!/usr/bin/env bash
# claude-launcher.sh — サブスク(interactive)枠の claude をバックグラウンド起動し、
# FIFO 経由で駆動 / モバイル(Remote Control)から操作する。
# claude -p (2026-06-15 から従量課金) を使わず interactive 枠で回すための仕組み。
#
# 仕組み:
#   - 対話 claude は TTY が無いと print 相当で落ちる → `script`(util-linux)で擬似TTY(pty)を与える
#   - 外からキー入力するため stdin を FIFO に → `echo > fifo` でプロンプト送信
#   - `--remote-control <name>` でリレー登録 → claude.ai / モバイルから同セッションを操作可能
set -euo pipefail

STATE="${CLAUDE_LAUNCHER_STATE:-$HOME/.claude-launcher}"
mkdir -p "$STATE"

usage() {
  cat <<USAGE
Usage:
  claude-launcher.sh launch <name> [dir]   起動 (dir 既定=\$PWD): claude --remote-control <name> を pty+FIFO で
  claude-launcher.sh send   <name> <text>  起動中セッションにプロンプト送信 (Enter 付き)
  claude-launcher.sh log    <name>         セッションの画面ログ (制御コード除去) を表示
  claude-launcher.sh list                  起動中セッション一覧
  claude-launcher.sh stop   <name>         セッション停止 + 後片付け (消えてから返る = 呼び出し後の再確認は不要)
USAGE
}

require() { command -v "$1" >/dev/null || { echo "ERROR: '$1' が必要" >&2; exit 1; }; }

cmd_launch() {
  local name="$1" dir="${2:-$PWD}"
  require script; require claude; require setsid
  local fifo="$STATE/$name.pipe"
  local log="$STATE/$name.log"
  local pidf="$STATE/$name.pids"
  [ -e "$fifo" ] && { echo "ERROR: '$name' は既に存在。先に stop して下さい" >&2; exit 1; }
  mkfifo "$fifo"
  # 書き込み側を開けっ放しにして EOF を防ぐ holder (setsid で独立セッション=グループリーダー)
  setsid bash -c "exec sleep infinity > '$fifo'" >/dev/null 2>&1 &
  local hpid=$!
  # pty を与えて claude を detached 起動。stdin は FIFO、画面は log に記録
  setsid bash -c "cd '$dir' && exec script -qfc 'claude --remote-control $name --permission-mode auto' '$log' < '$fifo'" >/dev/null 2>&1 &
  local spid=$!
  echo "$hpid $spid" > "$pidf"
  echo "launched '$name' (dir=$dir)"
  echo "  log : $log"
  echo "  起動まで数秒。'claude-launcher.sh log $name' で 'Remote Control active' を確認 → モバイルから接続可"
}

cmd_send() {
  local name="$1"; shift
  local fifo="$STATE/$name.pipe"
  [ -p "$fifo" ] || { echo "ERROR: '$name' は起動していない" >&2; exit 1; }
  printf '\025' > "$fifo"          # 入力ボックスをクリア (Ctrl-U): 前の未送信プロンプトとの混線を防ぐ
  printf '%s\r' "$*" > "$fifo"     # プロンプト + Enter
  echo "sent to '$name': $*"
}

cmd_log() {
  local name="$1"
  local log="$STATE/$name.log"
  [ -f "$log" ] || { echo "ERROR: log なし: $log" >&2; exit 1; }
  sed -r "s/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\x1b\][^\x07]*\x07//g; s/\r/\n/g" "$log" | grep -avE '^[[:space:]]*$' || true
}

cmd_list() {
  shopt -s nullglob
  local found=0 p n
  for p in "$STATE"/*.pipe; do n=$(basename "$p" .pipe); echo "  $n"; found=1; done
  [ "$found" = 0 ] && echo "  (起動中セッションなし)" || true
}

cmd_stop() {
  local name="$1"
  local pidf="$STATE/$name.pids"
  # 記録した holder / script をプロセスグループごと SIGTERM (setsid でグループリーダー)。pkill -f は自爆事故があるので使わない。
  if [ -f "$pidf" ]; then
    local p
    for p in $(cat "$pidf"); do kill -- "-$p" 2>/dev/null || true; done
  fi
  # 終了をタイムアウト付きで監視し、残れば SIGKILL。stop は実際に消えてから返す。
  alive_pids() { ps -eo pid,comm,args | awk -v n="$name" '$2=="claude" && $0 ~ ("remote-control " n "([[:space:]]|$)") {print $1}'; }
  local i
  for i in $(seq 1 20); do [ -z "$(alive_pids)" ] && break; sleep 0.5; done
  local left; left="$(alive_pids)"
  [ -n "$left" ] && kill -9 $left 2>/dev/null || true
  rm -f "$STATE/$name.pipe" "$STATE/$name.log" "$pidf"
  echo "stopped & cleaned '$name'"
}

[ $# -ge 1 ] || { usage; exit 1; }
sub="$1"; shift || true
case "${sub:-}" in
  launch) [ $# -ge 1 ] || { usage; exit 1; }; cmd_launch "$@";;
  send)   [ $# -ge 2 ] || { usage; exit 1; }; cmd_send "$@";;
  log)    [ $# -ge 1 ] || { usage; exit 1; }; cmd_log "$@";;
  list)   cmd_list;;
  stop)   [ $# -ge 1 ] || { usage; exit 1; }; cmd_stop "$@";;
  *) usage; exit 1;;
esac
