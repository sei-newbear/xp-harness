# e2e SKILL.md 本文の「日本語名」表記を「natural language」に揃える

## 背景 / Why

設計 §4.6 で「日本語ヘルパー」→「natural language ヘルパー」(project の言語選択を尊重) と方針確定し、description および e2e-reviewer 本文は更新済。一方 SKILL.md 本文に「日本語名」表記が残存しており、description と本文の表記不整合は読み手の混乱を招くため本文も揃える (interface 純化)。

## 状況

設計 §4.6 で「日本語ヘルパー」→「natural language ヘルパー」(project の言語選択を尊重) と方針確定し、`.apm/skills/e2e/SKILL.md` の description および `.apm/agents/e2e-reviewer.md` 本文は更新済。一方 SKILL.md 本文の見出し / 説明文 / 手順には「日本語名」表記が残存している:

- L33: `### 2. 操作はヘルパー関数（日本語名）に切り出す`
- L37 周辺: `**関数名は日本語で意図を表現**`
- L191 周辺: 「日本語名」言及

description と本文の表記不整合は読み手の混乱を招くため、本文も「natural language」に揃える。

## 再開時の起点

1. SKILL.md 本文の該当 3 箇所を grep で再確認
2. 「日本語名 / 日本語で」表現を「natural language 名 / project の言語で」等に置換
3. 例として残っている日本語関数名 (`taro` 等の dummy 値以外) を、必要に応じて project の言語の自由度を強調する文言に調整
4. e2e-reviewer.md / philosophy SKILL.md など関連 file との表記整合を最終確認
