# story-slicing の発火信頼性 — routing の空白地帯を塞ぐ

## 背景 / Why

story-slicing は「要件定義完成直後に必ず発火」する想定のフェーズ skill だが、実測で **発火が半々でバラつく**（要件完成まで複数回: 発火率 約 50〜67%）。要件定義完成後に INVEST 点検・分割が飛ばされると、大きすぎる/独立性のないストーリーがそのまま設計・実装に流れる。

## 状況

`main.instructions.md` 痩せ再構成の発火事後観測（`docs/working/main-instructions再構成/発火観測.md`）で顕在化。当初「痩せ後だけ未発火＝回帰」と見えたが、要件完成までを複数回回した実測で **新版 2/4・旧版 2/3 発火** と分かり、**痩せ非依存の揺らぎ**（新旧同挙動）と確定した。

根本原因は **routing の空白地帯**（grep で確認、痩せ非依存の既存構造）:

- `define-requirements` は次フェーズ誘導で **`basic-design` を案内**し story-slicing を飛ばす（`.apm/skills/define-requirements/SKILL.md` の「次のフェーズへの誘導」）
- `slice-tdd` は story-slicing を **「前段で済んでいる前提」** で受け取るだけ（`.apm/skills/slice-tdd/SKILL.md` L76）で、呼び出しはしない
- 誰も「要件完成 → story-slicing」を案内しておらず、story-slicing は **自分の description の自己発火頼み**

## 再開時の起点

1. define-requirements で要件定義から (発火条件・責務境界を対話で固める)
2. 直しの候補: `define-requirements` の「次のフェーズへの誘導」を **要件定義 → story-slicing → basic-design** にする（basic-design 直行をやめ、story-slicing を明示的に挟む）。instruction の routing に足すのは症状対処なので skill 側の誘導で直すのが筋
3. 直した後、要件完成まで複数回の発火観測で発火率が上がったか確認（harness-verification）
