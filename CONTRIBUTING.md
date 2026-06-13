# xp-harness 改修ガイド

xp-harness 本体 (skill / agent / instruction) を改修する人向けのガイド。利用者向けの情報は [README.md](./README.md) を参照。

## 内部構造

```
xp-harness/
├── README.md                            # 利用者向け
├── CONTRIBUTING.md                      # このファイル (改修者向け)
├── ROADMAP.md                           # 将来 TODO
├── apm.yml                              # APM manifest
│
├── .apm/                                # ★ APM 配信対象 (apm install で届く)
│   ├── skills/<...>/SKILL.md
│   ├── agents/<...>.md
│   └── instructions/main.instructions.md
│
└── .claude/                             # ★ APM 管理外、harness 改修者用
    ├── skills/                          # philosophy / skill-design-style / harness-verification 等
    └── agents/skill-reviewer.md
```

- `.apm/` 配下は APM 配信対象。利用者の `apm install` で `.claude/skills/`, `.claude/agents/`, `.claude/rules/` に deploy される
- `.claude/` 配下 (改修者向け skill / agent) は APM 管理外、配信されない。harness 改修者が git clone して直接利用する

## 作業フロー

harness を改修するには git clone して直接編集する (`apm install` 経由ではない):

```bash
cd /path/to/xp-harness
bash scripts/setup-dev.sh   # 初回 / skill 追加時 (冪等)
claude                      # philosophy + .apm/ 配下が認識される
```

`scripts/setup-dev.sh` が `.apm/skills/<x>` → `.claude/skills/<x>` / `.apm/agents/<x>.md` → `.claude/agents/<x>.md` の symlink を作る。`.apm/instructions/main.instructions.md` は `CLAUDE.md` からの `@` transclusion で取り込まれる。

改修した skill / agent は Claude Code 再起動 (or `/skills`) で即時反映。

## 前提

- **公式 skill-creator skill** (Anthropic 提供) が `~/.claude/skills/` 等に install 済であること
- xp-harness の `philosophy` skill (`.claude/skills/philosophy/`) と公式 `skill-creator` が並行発火する流れで skill を改修する

## 注意

正式な self-host (`apm install . --target claude`) は APM の循環依存検出により実現不可。上記の symlink 方式は dogfooding 用の暫定対応。

## リリース

version 管理とリリース手順は `.claude/skills/release/SKILL.md` を参照 (`/release` で発火)。
