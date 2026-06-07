#!/usr/bin/env python3
"""検証セッションの transcript を解析し、skill / subagent の発火事実を一覧化する。

Usage:
  analyze-session.py <sandbox-path>                 # 最新セッションを解析
  analyze-session.py <sandbox-path> --list          # セッション一覧
  analyze-session.py <sandbox-path> --session <ID>  # 指定セッションを解析
  analyze-session.py <sandbox-path> --grep <文字列>  # 合言葉などの出現確認を追加

transcript の場所: ~/.claude/projects/<sandbox 絶対パスの英数字以外を - に置換>/
  main セッション: <セッションID>.jsonl
  subagent:        <セッションID>/subagents/agent-*.jsonl (+ agent-*.meta.json)
"""
import argparse
import json
import re
import sys
from datetime import datetime
from pathlib import Path


def project_dir(sandbox: Path) -> Path:
    encoded = re.sub(r"[^A-Za-z0-9]", "-", str(sandbox.resolve()))
    return Path.home() / ".claude" / "projects" / encoded


def iter_jsonl(path: Path):
    with open(path, encoding="utf-8") as f:
        for line in f:
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue


def tool_uses(event: dict):
    msg = event.get("message")
    if not isinstance(msg, dict):
        return
    content = msg.get("content")
    if not isinstance(content, list):
        return
    for c in content:
        if isinstance(c, dict) and c.get("type") == "tool_use":
            yield c


def first_user_prompt(path: Path) -> str:
    for ev in iter_jsonl(path):
        if ev.get("type") != "user":
            continue
        content = ev.get("message", {}).get("content")
        text = ""
        if isinstance(content, str):
            text = content
        elif isinstance(content, list):
            text = " ".join(
                c.get("text", "") for c in content if isinstance(c, dict) and c.get("type") == "text"
            )
        text = text.strip()
        if text and not text.startswith("<"):
            return text
    return "(user プロンプトなし)"


def analyze_stream(path: Path, label: str, grep: str | None):
    """1 つの jsonl (main または subagent) から発火事実を抽出して表示する。"""
    skill_fires = []
    agent_launches = []
    skill_md_reads = []
    grep_hits = 0
    for ev in iter_jsonl(path):
        for tu in tool_uses(ev):
            name = tu.get("name")
            inp = tu.get("input", {})
            if name == "Skill":
                skill_fires.append(inp.get("skill") or inp.get("command", "?"))
            elif name in ("Task", "Agent"):
                agent_launches.append(
                    f"{inp.get('subagent_type', '(type 未指定)')} — {inp.get('description', '')}"
                )
            elif name == "Read":
                fp = inp.get("file_path", "")
                if fp.endswith("SKILL.md"):
                    skill_md_reads.append(fp)
        if grep:
            try:
                if grep in json.dumps(ev, ensure_ascii=False):
                    grep_hits += 1
            except (TypeError, ValueError):
                pass

    print(f"\n## {label}")
    print(f"  Skill 発火 ({len(skill_fires)} 件): {', '.join(skill_fires) if skill_fires else 'なし'}")
    if agent_launches:
        print(f"  subagent 起動 ({len(agent_launches)} 件):")
        for a in agent_launches:
            print(f"    - {a}")
    if skill_md_reads:
        print(f"  ⚠ SKILL.md を Read したケース ({len(skill_md_reads)} 件) — Skill tool 発火でなく Read で済まされた可能性:")
        for r in skill_md_reads:
            print(f"    - {r}")
    if grep:
        print(f"  grep '{grep}': {grep_hits} 行にヒット")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("sandbox", help="検証 sandbox のパス")
    ap.add_argument("--list", action="store_true", help="セッション一覧を表示")
    ap.add_argument("--session", help="解析するセッション ID (省略時は最新)")
    ap.add_argument("--grep", help="出現確認したい文字列 (合言葉など)")
    args = ap.parse_args()

    pdir = project_dir(Path(args.sandbox))
    if not pdir.is_dir():
        sys.exit(f"ERROR: transcript ディレクトリが見つかりません: {pdir}\n(このパスで Claude Code を起動したセッションがまだ無い可能性)")

    sessions = sorted(pdir.glob("*.jsonl"), key=lambda p: p.stat().st_mtime, reverse=True)
    if not sessions:
        sys.exit(f"ERROR: セッション (.jsonl) がありません: {pdir}")

    if args.list:
        print(f"# セッション一覧: {pdir}")
        for s in sessions:
            mtime = datetime.fromtimestamp(s.stat().st_mtime).strftime("%Y-%m-%d %H:%M")
            print(f"  {s.stem}  ({mtime})  {first_user_prompt(s)[:60]}")
        return

    if args.session:
        target = pdir / f"{args.session}.jsonl"
        if not target.exists():
            sys.exit(f"ERROR: セッションが見つかりません: {target}")
    else:
        target = sessions[0]

    print(f"# 解析対象: {target}")
    print(f"# 最初の user プロンプト: {first_user_prompt(target)[:120]}")

    analyze_stream(target, "main セッション", args.grep)

    subagents_dir = pdir / target.stem / "subagents"
    if subagents_dir.is_dir():
        for sub in sorted(subagents_dir.glob("agent-*.jsonl")):
            meta_path = sub.with_suffix("").with_suffix(".meta.json") if sub.suffix == ".jsonl" else None
            meta_path = sub.parent / (sub.stem + ".meta.json")
            agent_type = "(meta なし)"
            desc = ""
            if meta_path.exists():
                try:
                    meta = json.loads(meta_path.read_text(encoding="utf-8"))
                    agent_type = meta.get("agentType", agent_type)
                    desc = meta.get("description", "")
                except json.JSONDecodeError:
                    pass
            analyze_stream(sub, f"subagent: {agent_type} — {desc} ({sub.stem})", args.grep)
    else:
        print("\n(subagent transcript なし)")


if __name__ == "__main__":
    main()
