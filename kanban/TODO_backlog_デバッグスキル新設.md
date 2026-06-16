# デバッグスキル新設 (systematic-debugging 相当)

## 背景 / Why

バグ修正の質を底上げするための skill。「4 phase root cause investigation」を強制する skill が xp-harness にはない。`slice-tdd` は「テストを書く規律」であって「根本原因を探る規律」ではないため、バグ修正時に同じパターンを繰り返さないための skill が必要。

## 状況

バグ修正の質を底上げするための skill。「4 phase root cause investigation」(Root Cause → Pattern Analysis → Hypothesis and Testing → Implementation) を強制する skill が xp-harness にはない。

`slice-tdd` は「テストを書く規律」であって「根本原因を探る規律」ではない。バグ修正時に同じパターンを繰り返さないための skill が必要。

## 再開時の起点

1. 4 phase root cause investigation の業界事例を読む
2. xp-harness の対話駆動・自走モードに合わせて文化的調整
3. slice-tdd との連携方式 (バグ修正時に systematic-debugging → slice-tdd の流れ)
