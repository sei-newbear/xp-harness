# skill 編集時の思想 loading 仕組み

## 背景 / Why

新 skill を作る / 既存 skill を改修するときに、philosophy skill の判断軸を必ず参照した状態で進める仕組みが必要。現状は philosophy skill の description で「skill / agent 作成・改修時に発火」を強調しているが、確実に loading される保証はない (Claude の自律に依存)。skill が増えるほど drift リスクが累積する。

## 状況

新 skill を作る / 既存 skill を改修するときに、philosophy skill の判断軸を必ず参照した状態で進める仕組みが必要。現状は philosophy skill の description で「skill / agent 作成・改修時に発火」を強調しているが、確実に loading される保証はない (Claude の自律に依存)。

skill が増えるほど drift リスクが累積する。

## 再開時の起点

1. philosophy skill の description で更に発火条件を強化
2. or hook で skill 編集時に philosophy を強制 loading (ただし hook の保守コストとトレードオフ)
3. or `skill-creator` を改修して philosophy を pre-load
