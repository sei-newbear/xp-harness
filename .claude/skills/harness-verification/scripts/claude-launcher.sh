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
  claude-launcher.sh wait-idle <name> [--timeout N]
                                           pty 画面(log)の mtime が quiet 秒(固定6)更新されなければ IDLE
                                           (処理中はスピナーが画面を書き続ける)。始まらなければ NOSTART。
                                           --timeout はターンの重さに応じて呼ぶ側が指定(既定300s)。超過で
                                           「まだ処理中 / 想定外停止」を切り分けた状態つき TIMEOUT を返す。
  claude-launcher.sh log    <name>         セッションの画面ログ (制御コード除去) を表示
  claude-launcher.sh list                  起動中セッション一覧
  claude-launcher.sh stop   <name>         セッション停止 + 後片付け (消えてから返る = 呼び出し後の再確認は不要)

注意:
  - アイドル判定は wait-idle が pty 画面(log)の mtime で行う。処理中はスピナーが毎フレーム画面を書く
    (thinking / subagent 実行中も) ので mtime が動き、idle で止まる。log の中身は grep しない (残骸で誤検知)。
    transcript の mtime も使わない (thinking 中は書かれず、長考を idle と誤判定する)。
  - send しても submit されず入力欄に残ることがある (通知 dialog が Enter を食う)。
    send は内部で dialog 閉じ→クリア→Enter を送るが、念のため送信後に log で処理開始を確認するとよい。
USAGE
}

require() { command -v "$1" >/dev/null || { echo "ERROR: '$1' が必要" >&2; exit 1; }; }

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
  local name="$1"; shift || true
  # idle 判定閾 (quiet) は固定。処理中/idle を分けるのは「画面が animate しているか」で、
  # これは Claude Code の描画性質でタスクに依らず一定なので固定でよい。値は実測に基づく:
  # 重い作業 (サブエージェント複数+生成) の stress で作業中ポーズは最大 2s、そこに 4s の余裕を取り 6s。
  # timeout はターンの正当な総時間 (タスク依存) の網なので呼ぶ側が指定する。
  local quiet=6 timeout=300
  while [ $# -gt 0 ]; do
    case "$1" in
      --timeout) timeout="$2"; shift 2;;
      --quiet)   quiet="$2";   shift 2;;   # 通常は渡さない (固定 4s)。work-pause が長い環境向けの escape hatch
      *) echo "ERROR: 不明な引数 '$1' (--timeout N / --quiet N)" >&2; exit 1;;
    esac
  done
  local log="$STATE/$name.log"
  [ -f "$log" ] || { echo "ERROR: '$name' の log なし (起動していない?)" >&2; exit 1; }
  # 信号は pty 画面 (log ファイル) の mtime。処理中はスピナーが毎フレーム画面を書くので mtime が
  # 進み続け、idle (静的プロンプト) になると止まる。thinking 中も subagent 実行中も画面は生きる (実測済)。
  # transcript の mtime は使わない (thinking 中は書かれず、長考を idle と誤判定するため)。
  _lmtime() { stat -c %Y "$log" 2>/dev/null || echo 0; }
  local start base; start=$(date +%s); base="$(_lmtime)"
  # 処理開始 (画面更新) を待つ。始まらなければ send が submit されていない可能性 (通知が Enter を食う等)
  local started=0 i
  for ((i=0; i<15; i++)); do
    [ "$(_lmtime)" -gt "$base" ] && { started=1; break; }
    sleep 1
  done
  if [ "$started" = 0 ]; then
    # 起動時から画面が静止 = 既に idle。これは「ターンが速く完了して既に入力待ち」か「send が未着手」の
    # どちらか。log-mtime だけでは両者を区別できないので、IDLE として返しつつ注意を添える (呼ぶ側は
    # log 末尾で『ターンの結果 / メニュー』が出ているか、『未送信の自分のプロンプト』が残っているかを見る)。
    echo "IDLE (画面が起動時から静止。ターン完了済みで入力待ち、または send 未着手のいずれか → log 末尾で中身を確認。未送信なら printf '\\r' > <name>.pipe で再送信)"
    return 0
  fi
  # idle (画面が quiet 秒更新なし) を待つ。timeout 超過で「状態つき TIMEOUT」を返し、放置でなく呼ぶ側を引き戻す。
  while :; do
    local lm now age; lm="$(_lmtime)"; now=$(date +%s); age=$((now - lm))
    [ "$age" -ge "$quiet" ] && { echo "IDLE"; return 0; }
    if [ $((now - start)) -ge "$timeout" ]; then
      echo "TIMEOUT (${timeout}s 経過): 画面の最終更新は ${age}s 前。"
      if [ "$age" -lt "$quiet" ]; then
        echo "  → まだ処理中 (画面が動いている)。長いターンなので --timeout を延ばして再 wait を。"
      else
        echo "  → 画面が止まっているのに idle 未検知。想定外なので実状態を確認 (下に画面末尾)。"
      fi
      echo "  --- 画面末尾 ---"
      cmd_log "$name" 2>/dev/null | tail -8
      return 1
    fi
    sleep 1
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
  # claude 本体だけでなく、それを包む script プロセスも対象にする (comm 条件を付けると script を見逃す)
  alive_pids() { ps -eo pid,args | awk -v n="$name" '$0 ~ ("remote-control " n "([[:space:]]|$)") {print $1}'; }
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
  launch)    [ $# -ge 1 ] || { usage; exit 1; }; cmd_launch "$@";;
  send)      [ $# -ge 2 ] || { usage; exit 1; }; cmd_send "$@";;
  wait-idle) [ $# -ge 1 ] || { usage; exit 1; }; cmd_wait_idle "$@";;
  log)       [ $# -ge 1 ] || { usage; exit 1; }; cmd_log "$@";;
  list)      cmd_list;;
  stop)      [ $# -ge 1 ] || { usage; exit 1; }; cmd_stop "$@";;
  *) usage; exit 1;;
esac
