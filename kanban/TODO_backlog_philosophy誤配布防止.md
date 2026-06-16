# philosophy skill (改修者向け) を consumer に誤配布しない仕組み

## 背景 / Why

philosophy skill は `.claude/skills/philosophy/` (APM 管理外) に置くことで配信を抑止しているが、consumer が `.claude/` を丸ごとコピー / 同名 skill 自作によって誤って philosophy 系 skill を取り込むシナリオがある (責務境界)。

## 状況

philosophy skill は `.claude/skills/philosophy/` (APM 管理外) に置くことで配信を抑止しているが、consumer が `.claude/` を丸ごとコピー / 同名 skill 自作によって誤って philosophy 系 skill を取り込むシナリオがある。

## 再開時の起点

1. namespace 分離の仕組みを検討 (例: harness 改修者向け skill は `_harness-dev-` prefix を付ける)
2. description に「xp-harness 自体の」など修飾語を明示して誤発火を抑制
3. consumer が間違えて取り込んだときの警告メカニズム
