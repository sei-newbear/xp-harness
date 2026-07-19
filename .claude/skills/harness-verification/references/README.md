# 検証記録 (verification records)

harness-verification で回した検証を、**サンドボックスを残さず「再現できるレシピ＋結果」として自己完結で** 貯める場所。

- サンドボックスは throwaway（`setup-sandbox.sh` ＋下記「条件」で再生成できる）ので git に入れない
- `docs/working/` は working（いつ消えてもおかしくない）ので **依存しない** — 各記録はこのファイルだけで成立させる（結果・証拠を inline で書き写す）

## ファイル

- 1 検証 = 1 ファイル、`YYYY-MM-DD_対象.md`（`対象` はケバブケース・日本語可、`_` は日付との区切りにのみ使う）
- 検索: `../scripts/find-verifications.sh`
- format 点検: `../scripts/validate-verifications.sh`（新規記録を足したら通す）

## フォーマット（frontmatter の 5 キー ＋ 2 section が必須）

```markdown
---
目的: <何を確かめたいか、一行>
対象: <skill 名 / 変更名>
verdict: <PASS / 揺らぎ / FAIL / 混在 など、一行>
日付: <YYYY-MM-DD>
モデル: <検証セッション (main session) の正確な model ID。transcript の assistant メッセージから確認する (例: claude-sonnet-5)。UI 表示名や alias でなく ID で書く。シナリオでモデルを分けたら「シナリオ名=ID」で列挙>
---

# <タイトル>

## 条件（再現レシピ）
- sandbox: <setup-sandbox の flavor: bare / webapp / wiremock 等>
- 仕込み: <docs/working に置いた要件/設計 md・シード等の中身。ここに書き写して自己完結させる>
- ノーヒント依頼: <検証セッションに投げたプロンプトの全文>
- 前後比較 / 試行数: <旧/新の差し替え方・何本回したか>

## 結果
<発火・振る舞い・verdict の根拠を inline で。docs/working へのリンクに依存しない>
```

frontmatter の 5 キーと `## 条件` `## 結果` の 2 section が validate の必須項目。

モデルを必須にする理由: 発火・振る舞いはモデル依存で、上位モデルは弱い description を推論で補ってしまう（= 同じ検証でもモデルが違えば別の結果になりうる）。記録にモデルが無いと後から比較・再現できない。
