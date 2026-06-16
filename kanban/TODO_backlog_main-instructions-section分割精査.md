# `.apm/instructions/main.md` の section 分割精査

## 背景 / Why

現状 `.apm/instructions/main.instructions.md` は 1 ファイル集約。section ごとに分割すると `apm compile` の Distribution Score 最適化機能 (複数 instruction を target dir に分散配置) を活かせる。ただし分割単位は中身を精査しないと決まらず、場当たり的な分割は逆戻りリスクになる。

## 状況

現状 `.apm/instructions/main.instructions.md` は 1 ファイル集約。section ごとに分割すると `apm compile` の Distribution Score 最適化機能 (複数 instruction を target dir に分散配置) を活かせる。

ただし「分割の単位」は中身を精査しないと決まらない。場当たり的に分割すると後で逆戻りリスク。

## 再開時の起点

1. 現 main.instructions.md を読み返し、論理的に独立な section を識別
2. 分割候補: `xp-philosophy` / `phase-flow` / `cross-rules` / `dialogue-type` / `review-handling` / `implementation-rules` 等
3. 分割すると Distribution Score がどう変わるかを `apm compile --dry-run` で確認
4. consumer 側の `.apm/instructions/<own>.md` 命名規約とも整合させる
