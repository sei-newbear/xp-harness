# story-slicing の呼び出し指示を define-requirements 側に移す (発火不全の仮説対応)

## 背景 / Why

`story-slicing` skill が呼ばれないケースがあった (依頼者観測)。呼び出しタイミングが呼ばれ側の description にしか書かれておらず、呼ぶ側に言及が無いという構造的問題が原因と疑っている。呼び出しタイミングは呼ぶ側に書くのが筋 (責務境界)。

## 状況

`story-slicing` skill が呼ばれないケースがあった (依頼者観測)。原因として疑っているのは、**呼び出しタイミングが呼ばれ側 (`story-slicing/SKILL.md`) の description に書かれているだけで、呼ぶ側 (`define-requirements/SKILL.md`) には story-slicing への言及が無い** という構造的問題。

実状:
- `story-slicing/SKILL.md` L3 description: 「要件定義完成直後に必ず発火させる (define-requirements がユーザーストーリーを書き終えた直後)」
- `define-requirements/SKILL.md`: `story-slicing` への言及なし (grep 結果 0 hit)

呼ばれ側に書いても、呼ぶ側の context にロードされていない skill は発火しにくい。呼び出しタイミングは **呼ぶ側に書く** のが筋。

## 再開時の起点

1. `define-requirements/SKILL.md` のフェーズ終了タイミング (ユーザーストーリー書き終えた直後の section) に「直後に `story-slicing` skill を呼ぶ」指示を追加
2. `story-slicing/SKILL.md` の description から呼び出しタイミングの記述を削除 or 簡略化 (description は responsibility 宣言中心にする)
3. 同様の「呼ばれ側に呼び出しタイミングを書いているだけ」パターンが他に無いか確認 (例: `pre-implementation-reviewer`, `code-reviewer`, `e2e-reviewer` 等の発火タイミングが呼ぶ側の skill に書かれているか)
4. (派生) この構造的問題を philosophy / skill-creator 側のルールとして集約する (skill 設計の原則: 呼び出しタイミングは呼ぶ側に書く)
