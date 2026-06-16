# define-requirements / basic-design と dialogue-principles の重複整理

## 背景 / Why

define-requirements / basic-design の対話関連の記述と dialogue-principles の内容に重複がありそう。skill 間で同じ思想 / ルールが二重 / 三重に書かれていると drift リスクが累積し、context にも二重課金が乗る (重複削減)。

## 状況

`.apm/skills/define-requirements/SKILL.md` および `.apm/skills/basic-design/SKILL.md` の対話関連の記述と、`.apm/skills/dialogue-principles/SKILL.md` の内容に重複がありそう。skill 間で同じ思想 / ルールが二重 / 三重に書かれていると drift リスクが累積し、context にも二重課金が乗る。

dialogue-principles を single source of truth として、各フェーズ skill 側は dialogue-principles を preload / 参照する形に整理するのが筋。ただし「対話そのもののルール」と「フェーズ固有の対話 (要件定義の聞き方 / 基本設計の聞き方)」の境界は要検討。

「main.instructions.md の重複洗い出し」の項目と方向性が近い (重複削減 + single source of truth 化)。

## 再開時の起点

1. 3 skill を並べて重複箇所を識別 (対話の姿勢 / 質問の仕方 / 押し付けない態度 / 共創を目指す等)
2. dialogue-principles に集約すべき内容と、フェーズ skill 固有として残すべき内容を切り分ける
3. フェーズ skill 側で dialogue-principles を preload / 引用する形に書き換え
4. 「main.instructions.md の重複洗い出し」の項目と一緒に走らせると、main.instructions.md の重複整理と歩調を合わせやすい
