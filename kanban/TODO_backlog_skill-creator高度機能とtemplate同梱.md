# 公式 skill-creator では足りない高度な機能 + skill-template 同梱

## 背景 / Why

xp-harness は skill / agent の作成・編集に Claude Code 公式 skill-creator skill を使う想定。skill 開発が増えてくると、公式 skill-creator だけでは足りない高度な機能 (eval / TDD / description optimizer 等) や、公式が install されていない consumer 向けの最小 template が必要になる。

## 状況

xp-harness は skill / agent の作成・編集に **Claude Code 公式 skill-creator skill** (consumer の `~/.claude/skills/` 等で利用可能と仮定) を使う想定。

不足する場面:
- eval 機構 (skill description / 本文の発火精度を機械的に評価)
- 敵対的シナリオ駆動の skill 開発 (TDD 方法論)
- description optimizer (発火精度の自動チューニング)
- 公式 skill-creator が install されていない consumer 向けの最小 template

## 再開時の起点

1. eval 機構のニーズが見えてきたら、harness 専用の eval skill を新規作成
2. 公式 skill-creator が install されていない consumer 向けに `.claude/skills/skill-template/` を harness に同梱する案を検討
