# E2E と対になる実装 skill の新設 (実装規約 + architecture を担う)

## 背景 / Why

E2E spec の規約・哲学は `e2e` skill にまとまっているが、**実装コードそのものの規約 / architecture を扱う skill が無い**。E2E skill と対になる「実装側の規約 + architecture を扱う skill」が欲しい。

## 状況

現状、E2E spec の規約・哲学は `e2e` skill にまとまっている (ロールベースセレクタ、natural language ヘルパー、GIVEN/WHEN/THEN、テスト独立性 等)。一方、**実装コードそのものの規約 / architecture を扱う skill が無い**。

近いものに `slice-tdd` があるが、これは TDD のリズムと分割が主で、「実装の規約」「architecture (レイヤ構造、依存方向、モジュール境界、命名規約 等)」はカバーしていない。E2E skill と対になる「実装側の規約 + architecture を扱う skill」が欲しい。

現状は code-reviewer subagent が SOLID 等の品質観点を持っているが、これは「レビューする側の観点」であって、「実装する側が従う規約」ではない。implementer 側に規約 skill が無いので、レビューでしか規律が効いていない構造になっている。

## 再開時の起点

1. skill の責務範囲を定義: 実装規約 (命名、責務分離、エラーハンドリング境界) / architecture (レイヤ、依存方向、モジュール境界) / 既存 skill との境界
2. `slice-tdd` / `code-reviewer` との責務切り分けを明確化 (slice-tdd は TDD リズム、code-reviewer はレビュー視点、新 skill は実装規約の single source of truth)
3. `e2e` skill と同じく framework / 言語固有部分の扱いを設計 (e2e 薄型化で議論している分離方針と整合)
4. skill 名候補を決める (例: `implementation`, `coding-rules`, `architecture` 等) → `skill-creator` で雛形作成

## 補足: MVP 版との関係

「実装 skill / E2E実行 skill を MVP で新設」(PR #5 MERGED で完了) は本格作り込みに対する MVP 版という位置づけ。方向性は同じで、規約 / architecture の充実は本項目で別途行うか、MVP 版が育って吸収する可能性がある。
