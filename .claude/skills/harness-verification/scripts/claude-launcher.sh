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
  claude-launcher.sh launch <name> [dir] [session-id]
                                           起動 (dir 既定=\$PWD): claude --remote-control <name> を pty+FIFO で。
                                           session-id 指定で --resume 再開 (クラッシュ後の復帰に使う)
  claude-launcher.sh send   <name> <text>  プロンプト送信 (dialog 閉じ + クリア + Enter で submit 保証)
  claude-launcher.sh wait-idle <name> [quiet] [timeout]
                                           main+subagent の transcript(jsonl) mtime が quiet 秒(既定8)更新
                                           されなければ IDLE。処理が始まらなければ NOSTART (送信失敗の可能性)。
                                           timeout 既定400s
  claude-launcher.sh log    <name>         セッションの画面ログ (制御コード除去) を表示
  claude-launcher.sh list                  起動中セッション一覧
  claude-launcher.sh stop   <name>         セッション停止 + 後片付け (消えてから返る = 呼び出し後の再確認は不要)

注意:
  - 画面ログ(log) は端末の生ダンプで、過去の "Pollinating…" 等が残骸として残る。
    アイドル判定を log の grep でやると誤検知するので、待機は必ず wait-idle (transcript mtime) を使う。
  - send しても submit されず入力欄に残ることがある (通知 dialog が Enter を食う)。
    send は内部で dialog 閉じ→クリア→Enter を送るが、念のため送信後に log で処理開始を確認するとよい。
USAGE
}

require() { command -v "$1" >/dev/null || { echo "ERROR: '$1' が必要" >&2; exit 1; }; }

# sandbox dir から Claude Code の transcript ディレクトリを特定する (/ と . を - に置換)
transcript_dir() {
  local dir="$1"
  printf '%s/.claude/projects/%s' "$HOME" "$(printf '%s' "$dir" | sed 's#[/.]#-#g')"
}

cmd_launch() {
  local name="$1" dir="${2:-$PWD}" session="${3:-}"
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
  # env -u で親の session 変数 2 つを外す: 引き継ぐと子 claude が「親セッションの子」と判定され
  # standalone セッション扱いされず JSONL transcript が書かれない (= analyze-session.py が解析できない)。
  # env が claude を exec する形にする (env の後に shell ビルトイン exec を置くと env から見えず即死するため)。
  # session-id が渡されたら --resume で再開 (クラッシュ後の復帰など)
  local resume_opt=""
  [ -n "$session" ] && resume_opt="--resume $session"
  setsid bash -c "cd '$dir' && exec script -qfc 'env -u CLAUDE_CODE_CHILD_SESSION -u CLAUDE_CODE_SESSION_ID claude $resume_opt --remote-control $name --permission-mode auto' '$log' < '$fifo'" >/dev/null 2>&1 &
  local spid=$!
  echo "$hpid $spid" > "$pidf"
  # dir を絶対パスで保存: wait-idle が transcript ディレクトリを特定するのに使う
  ( cd "$dir" && pwd ) > "$STATE/$name.dir"
  echo "launched '$name' (dir=$dir)"
  echo "  log : $log"
  echo "  起動まで数秒。'claude-launcher.sh log $name' で 'Remote Control active' を確認 → モバイルから接続可"
}

cmd_send() {
  local name="$1"; shift
  local fifo="$STATE/$name.pipe"
  [ -p "$fifo" ] || { echo "ERROR: '$name' は起動していない" >&2; exit 1; }
  printf '\r' > "$fifo"            # welcome / 通知 dialog が出ていたら閉じる (Enter を食われて未送信になるのを防ぐ)
  printf '\025' > "$fifo"          # 入力ボックスをクリア (Ctrl-U): 前の未送信プロンプトや改行との混線を防ぐ
  printf '%s\r' "$*" > "$fifo"     # プロンプト + Enter
  echo "sent to '$name': $*"
}

cmd_wait_idle() {
  local name="$1" quiet="${2:-8}" timeout="${3:-400}"
  local dirf="$STATE/$name.dir"
  [ -f "$dirf" ] || { echo "ERROR: '$name' の dir 記録なし (改修前に launch された可能性。再 launch するか $dirf に sandbox パスを書く)" >&2; exit 1; }
  local tdir; tdir="$(transcript_dir "$(cat "$dirf")")"
  # main + subagent の全 jsonl の最新 mtime を見る。subagent 実行中は main transcript が止まるので、
  # main だけ見ると subagent 点検中を誤ってアイドル判定してしまう (subagents/agent-*.jsonl も拾う)
  _mtime() { find "$tdir" -name "*.jsonl" -printf '%T@\n' 2>/dev/null | sort -rn | head -1 | cut -d. -f1; }
  local start base; start=$(date +%s); base="$(_mtime)"; base="${base:-0}"
  # 処理開始 (mtime 更新) を待つ。始まらなければ send が submit されていない可能性 (通知が Enter を食う等)
  local started=0 i
  for ((i=0; i<15; i++)); do
    local m; m="$(_mtime)"; m="${m:-0}"
    [ "$m" -gt "$base" ] && { started=1; break; }
    sleep 1
  done
  if [ "$started" = 0 ]; then
    echo "NOSTART (15s 待っても transcript が更新されない。send が submit されていない可能性 → printf '\\r' で再送信してから wait-idle を)"
    return 2
  fi
  # 停止 (quiet 秒 mtime 更新なし) を待つ
  while :; do
    local last now; last="$(_mtime)"; last="${last:-0}"; now=$(date +%s)
    [ "$last" -ne 0 ] && [ $((now - last)) -ge "$quiet" ] && { echo "IDLE"; return 0; }
    [ $((now - start)) -ge "$timeout" ] && { echo "TIMEOUT (${timeout}s)"; return 1; }
    sleep 2
  done
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
  rm -f "$STATE/$name.pipe" "$STATE/$name.log" "$pidf" "$STATE/$name.dir"
  echo "stopped & cleaned '$name'"
}

[ $# -ge 1 ] || { usage; exit 1; }
sub="$1"; shift || true
case "${sub:-}" in
  launch)    [ $# -ge 1 ] || { usage; exit 1; }; cmd_launch "$@";;
  send)      [ $# -ge 2 ] || { usage; exit 1; }; cmd_send "$@";;
  wait-idle) [ $# -ge 1 ] || { usage; exit 1; }; cmd_wait_idle "$@";;
  log)       [ $# -ge 1 ] || { usage; exit 1; }; cmd_log "$@";;
  list)      cmd_list;;
  stop)      [ $# -ge 1 ] || { usage; exit 1; }; cmd_stop "$@";;
  *) usage; exit 1;;
esac
