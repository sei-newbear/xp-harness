# basic-design / define-requirements の末尾「/clear で次フェーズへ」案内の要否検討

## 背景 / Why

basic-design / define-requirements の末尾にほぼ同じ構造の「次のフェーズへの誘導」section があり、`/clear` でセッションをリセットして次フェーズへ進む案内を出すよう書かれている。この案内が本当に必要か検討する (責務境界)。

## 状況

以下 2 ファイルの末尾に、ほぼ同じ構造の「次のフェーズへの誘導」section があり、`/clear` でセッションをリセットして次フェーズへ進む案内を出すよう書かれている:

- `.apm/skills/basic-design/SKILL.md` L334-347 (実装フェーズへの誘導)
- `.apm/skills/define-requirements/SKILL.md` L223-238 (基本設計フェーズへの誘導)

この案内が本当に必要か検討する。考えられる論点:

- そもそも skill 側で `/clear` を促す責務があるのか (instruction / phase-flow 側の責務では?)
- 同じパターンが 2 ファイルで繰り返されているので DRY 観点で集約余地
- 「強制ではなく任意のガイド」と書いてある通り価値が薄いなら削除候補
- 残すなら、Claude Code 固有機構 (`/clear`) を skill 本文に書くのは cross-agent 対応の項目と衝突する点も検討

## 再開時の起点

1. 両 section の運用上の有用性をふりかえる (実際に使われているか / ユーザーが従っているか)
2. 残す場合: 共通化先を検討 (`phase-flow` 系 instruction or skill, あるいは Claude Code 固有部分の分離)
3. 削除する場合: 両 skill から該当 section を除去、phase 遷移は instruction 側 or ユーザー判断に委ねる
