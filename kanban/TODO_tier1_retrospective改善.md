# retrospective skill の改善 (= 「skill / subagent 使用分析」サブ step 追加 + 「分析の honesty 監査」追加)

## 背景 / Why

2026-05-24 のふりかえりで retrospective skill 自体に 2 つの欠落が実証された。今回のセッションでこの 2 つを補強したら原因の言語化が大幅に深まったので、skill 本体に組み込む価値あり。

## 状況

2026-05-24 のふりかえりで retrospective skill 自体に 2 つの欠落が実証された。今回のセッションでこの 2 つを補強したら原因の言語化が大幅に深まったので、skill 本体に組み込む価値あり。

### 「skill / subagent 使用分析」サブ step が Step 1 に無い

現状の Step 1 (= 情報収集) は「よかった点 / 伸びしろ」をフラットに出すだけで、**skill 選択 / subagent 利用の妥当性** を見る視点が無い。harness の主要価値レバーは skill と subagent の選択 / 起動 / タイミングなのに、ふりかえりがそこを見ないと表面の伸びしろしか拾えない。

確認すべき項目:

- 利用可能だった skill / subagent
- 明示発火 / 起動した skill / subagent
- 「必ず発火」と書いてあるのに発火しなかった skill、呼ぶべきタイミングで呼ばなかった subagent
- 順序ミス / タイミングミス
- 暗黙適用で済ませた skill

今回のセッションで「skill 使用分析」を入れたら、表面の伸びしろが「skill 順序問題の現れ」として再分類され、根本原因の言語化が進んだ。同じ視点を subagent (= code-reviewer / e2e-reviewer / pre-implementation-reviewer / done-verifier / skill-reviewer) にも当てる必要あり (= subagent は Opus コストもかかるので、呼んだ / 呼ばなかったの判断軸の妥当性確認は価値が高い)。

### 「分析の honesty 監査」が Step 3 に無い

現状の Step 3 (= 深掘り分析) は「main session が自己分析を出す」と書いてあるが、その自己分析が **後付けで捏造された因果連鎖** でないかを検証する仕組みが無い。

今回のセッションで main session は「もっともらしい原因」を 3 つ並べ、user の指摘 (= 「それぞれ本当か?」) を受けて初めて捏造に気付いた。skill 側に「分析の honesty 監査」(= 検証できる事実と推測を分けて書け / 内部状態の主張は推測と明示せよ / 綺麗な因果図には捏造のサインを疑え) が組み込まれていれば、user の指摘無しでも 1 段深く降りられる可能性。

## 再開時の起点

1. retrospective skill 本文の Step 1 に「skill / subagent 使用分析」サブ step を追加 (= 利用可能だった / 明示発火・起動した / 必ず発火と書いてあるのに発火しなかった skill, 呼ぶべきタイミングで呼ばなかった subagent / 順序・タイミングミス / 暗黙適用、の項目)
2. retrospective skill 本文の Step 3 に「分析の honesty 監査」を追加 (= 検証できる事実と推測を分けて書け / 内部状態の主張は推測と明示せよ / 綺麗な因果図には捏造のサインを疑え)
3. 既存 Step との統合の仕方を判断 (= サブ step として明示分離 / 既存 Step 内で項目追加)
4. retrospective skill の使用例として、今回セッションのふりかえり内容を本文の例に書き加えるか判断
