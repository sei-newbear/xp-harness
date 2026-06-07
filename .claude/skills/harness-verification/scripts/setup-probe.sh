#!/usr/bin/env bash
# skill の連鎖発火 (preload skill → 別 skill を Skill tool で呼ぶ) を切り出して
# 検証するためのプローブ一式を sandbox に配置 / 削除する。
#
# Usage: setup-probe.sh <sandbox-path>          # 配置
#        setup-probe.sh <sandbox-path> --clean  # 削除
#
# 仕掛け: skill-probe subagent が probe-preloaded を preload され、
# その指示で probe-target を Skill tool で呼ぶ。probe-target は合言葉
# PROBE_TARGET_FIRED_OK を最終出力に含めるので、transcript で発火を観測できる。
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <sandbox-path> [--clean]" >&2
  exit 1
fi

SANDBOX="$(cd "$1" && pwd)"

PROBE_AGENT="${SANDBOX}/.claude/agents/skill-probe.md"
PROBE_PRELOADED="${SANDBOX}/.claude/skills/probe-preloaded"
PROBE_TARGET="${SANDBOX}/.claude/skills/probe-target"

if [ "${2:-}" = "--clean" ]; then
  rm -f "${PROBE_AGENT}"
  rm -rf "${PROBE_PRELOADED}" "${PROBE_TARGET}"
  echo "プローブ一式を削除しました: ${SANDBOX}"
  exit 0
fi

mkdir -p "${SANDBOX}/.claude/agents" "${PROBE_PRELOADED}" "${PROBE_TARGET}"

cat > "${PROBE_AGENT}" <<'EOF'
---
name: skill-probe
description: Skill 追従の検証用 subagent。preload した skill の指示に厳密に従って動く。手動検証でのみ使う。
tools: Read, Bash, Skill
model: sonnet
skills:
  - probe-preloaded
---

# Skill 追従 検証用 subagent

あなたは検証用の subagent。**preload された skill の指示に厳密に従って動く**。それ以外の余計なことはしない。preload された skill に書かれた手順を実行し、最終結果を報告する。
EOF

cat > "${PROBE_PRELOADED}/SKILL.md" <<'EOF'
---
description: 検証用の preload skill。subagent に preload され、別 skill の呼び出しを指示する。
---

# preload skill (A)

このタスクでは、必ず **`probe-target` skill を Skill tool で呼び出し**、その skill に書かれた指示に従うこと。`probe-target` を呼ばずに作業を終えてはならない。
EOF

cat > "${PROBE_TARGET}/SKILL.md" <<'EOF'
---
description: 検証用の target skill。preload されず、Skill tool 経由でのみ呼ばれる。
---

# target skill (B)

この skill が呼ばれたら、最終出力に必ず `PROBE_TARGET_FIRED_OK` という文字列をそのまま含めること。これはこの skill を実際に読んだ証拠になる。
EOF

echo "プローブ一式を配置しました: ${SANDBOX}"
echo "  ${PROBE_AGENT}"
echo "  ${PROBE_PRELOADED}/SKILL.md"
echo "  ${PROBE_TARGET}/SKILL.md"
echo ""
echo "起動プロンプト例 (改修者が sandbox で Claude Code を起動して貼る):"
echo '  検証タスクです。Task ツールで skill-probe という subagent を 1 回だけ起動し、「preload された skill の指示通りに動いて、最終結果を報告して」とだけ伝えてください。重要: あなた (main) 自身は probe-preloaded / probe-target などの skill ファイルを読まないこと。skill-probe が返した結果をそのまま報告してください。'
