#!/usr/bin/env bash
# xp-harness self-host (dogfooding) のセットアップ。
# .apm/skills/* と .apm/agents/*.md を .claude/ 配下に symlink する。冪等。
# 新規 skill / agent を追加したら再実行する。
#
# philosophy skill (.claude/skills/philosophy/) は APM 管理外で git tracked なので
# 対象外 (上書きしない)。
#
# CLAUDE.md からは @.apm/instructions/main.instructions.md で main instruction を
# 取り込むため、ここでは instruction の symlink は作らない。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

link() {
  local src="$1" dest="$2"
  if [[ -L "$dest" ]]; then
    if [[ "$(readlink "$dest")" == "$src" ]]; then
      echo "  ok: $dest"
      return
    fi
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    echo "  WARN: $dest exists and is not a symlink — left alone" >&2
    return
  fi
  ln -s "$src" "$dest"
  echo "  linked: $dest -> $src"
}

echo "skills:"
mkdir -p .claude/skills
for src_dir in .apm/skills/*/; do
  name="$(basename "$src_dir")"
  [[ "$name" == "philosophy" ]] && continue
  link "../../.apm/skills/$name" ".claude/skills/$name"
done

echo "agents:"
mkdir -p .claude/agents
for src_file in .apm/agents/*.md; do
  [[ -f "$src_file" ]] || continue
  name="$(basename "$src_file")"
  link "../../.apm/agents/$name" ".claude/agents/$name"
done

echo
echo "done. Claude Code を再起動すると skill / agent が認識される。"
echo "main instruction は CLAUDE.md の @.apm/instructions/main.instructions.md で取り込まれる。"
