# xp-harness 既存 skill の description を公式推奨に短縮

完了 (2026-07-21、v0.17.0)。500-900 字台だった 6 skill (git-workflow / define-requirements / dialogue-principles / story-slicing / slice-tdd / propose-options) を 212-309 字に短縮。What+When 構成・Key use case 先頭・発火除外条件は維持し、他 skill 名や具体ツール名の言及を除去した。あわせて define-requirements / slice-tdd の frontmatter を厳密 YAML で解析できる形に修正 (description 内の「: 」で落ちていた既存問題)。

短縮の副作用として dialogue-principles が要件対話の入口で発火しなくなる回帰が出た (旧 3/3 → 新 0/3)。原因は両フェーズ skill に「呼ぶ」案内が元から無く、発火が description の自己発火頼みだったこと。対話モードに入る 3 経路に呼び出し動線を足して解消 (再検証で 3 経路とも 2/2 発火)。経緯は `.claude/skills/harness-verification/references/2026-07-20_description純化.md`。
