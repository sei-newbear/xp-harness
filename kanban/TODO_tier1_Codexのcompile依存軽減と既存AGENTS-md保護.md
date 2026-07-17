# Codex の compile 依存の軽減と既存 AGENTS.md 保護

## 背景 / Why

Codex は中央運用ルールを `AGENTS.md` で受け取り、それは `apm compile --target codex` が生成する（`apm install` だけでは配られない。Claude/Cursor は install が rules ディレクトリに直接配るので compile 不要、という非対称）。

問題は 2 つ:

1. **compile 前提そのものが導入の摩擦**: Codex 利用者だけ install に加えて compile が要る
2. **compile が既存 AGENTS.md を上書きする**: `apm compile` は `AGENTS.md` を APM 所有で丸ごと書き換える（実証済。`--target claude` は `CLAUDE.md` を同様に上書き）。Codex 利用者は自前の `AGENTS.md` を持つことが多いので、無警告で走らせると失われる

## 状況

- v0.14.0 は **最小対応で shipped**: README に「compile が AGENTS.md を上書きする」警告と、「利用者ルールは `.apm/instructions/` に置けば compile がマージする」安全経路を明記するに留めた
- 実証済の事実（`docs/working/Codex対応/要件定義.md` 付録）: compile の出力ファイルは target で決まる（codex→AGENTS.md、claude→CLAUDE.md）。`.apm/instructions/` に置いた利用者ルールは xp-harness の運用ルールとマージされる

## 取り組む方向 (propose-options で議論)

- **install 一発化 (compile 不要にする)**: 中央運用ルールを skill 側だけで成立させ、Codex でも install だけで完結させる。中央ルール（main.instructions）の skill 化が要り、既存の「main-instructions スリム化 / skill 重複洗い出し」カード群と一体で考える
- **compile 前提のまま安全性を上げる**: 既存 AGENTS.md の自動退避・マージ支援、または compile 実行前の警告・バックアップ導線

## 再開時の起点

1. 上記 2 方向を propose-options で議論（install 一発化 vs compile 前提の安全化）
2. main-instructions スリム化カード群との関係を整理（中央ルールの skill 化が絡む）
3. 実地検証（本業 Codex）で compile 前提の摩擦が実際どれだけ痛いか観測してから深さを決める
