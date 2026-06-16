# define-requirements skill に Constraints (制約) を input/output 両面で追加

## 背景 / Why

define-requirements skill は現状、Goal (= ユーザーストーリー + Why) と Acceptance (= Done) を明示的に引き出すが、Constraints (= 守るべき条件全般) を input/output 双方で扱えていない。結果、依頼者が制約を持ち出しても md に書き起こされず、基本設計フェーズで再発見するか実装中に気付く構造になっている。

## 状況

define-requirements skill は現状、Goal (= ユーザーストーリー + Why) と Acceptance (= Done) を明示的に引き出すが、Constraints (= 守るべき条件全般) を input/output 双方で扱えていない。

Constraints は技術的なものに限らず、以下を含む広い概念として扱う:
- **技術的**: 採用フレームワーク・ランタイムの制限 (例: Cloudflare Workers のサイズ上限、Vercel Functions の実行時間)、既存仕様との互換、依存ライブラリ
- **非機能**: 性能 (response time / throughput)、可用性、運用負荷
- **セキュリティ・コンプライアンス**: 認証認可、個人情報、業界規制 (GDPR / 個人情報保護法等)
- **コスト**: API 呼び出し料金、infra 料金、人件費の上限
- **期限・納期**: ローンチ日、業務上の deadline (月末締め等)
- **組織・社内ルール**: コーディング規約、承認フロー、利用可能なツール / SaaS の制限
- **リソース**: 人員、開発期間、利用可能な権限

現状のギャップ:
- **Input 側**: skill 本文「やること」(1〜5) に Constraints を引き出す項目がない。「依頼者が**技術的**制約を持ち出してきた場合は要件定義に影響するので議論する」(`.apm/skills/define-requirements/SKILL.md:149`) と受け身に一文あるだけで、しかも対象が技術的制約に narrow されている
- **Output 側**: 要件定義.md テンプレート (4 セクション: 背景と動機 / ユーザーストーリー / Done / スコープ外) に Constraints セクションがない

スコープ外と Constraints は性格が違う:
- **スコープ外**: 「今回はやらない、後でやるかも」(交渉可能な除外)
- **Constraints**: 「絶対に踏み外せないルール」(非交渉)

結果、依頼者が制約を持ち出しても md に書き起こされず、基本設計フェーズで再発見するか実装中に気付く構造になっている。

## 背景

Anthropic 公式が Opus 4.7 (賢くなった上位モデル) 向けに「**Goal / Constraints / Acceptance criteria** の 3 要素を最初に与えれば、その後は LLM が自律的に調査・対話で残りを埋める」というプロンプト書式を提示している。この 3 要素を要件定義 skill に反映させたい、というのが Tier 1 指定の根拠 (依頼者の意向、2026-05-20 レビュー)。

3 要素を要件定義 skill に当てると、Goal (= ユーザーストーリー + Why) と Acceptance (= Done) は既存の skill 構造でカバーされているが、**Constraints の取り扱いが input/output 両方で抜けている**ことが判明した。

「LLM への初期入力 (= 依頼者からの最初の合意点)」と「調べた結果の共有 md (= 要件定義.md)」は別物で、Constraints は両側に必要、という整理。

## 再開時の起点

1. Constraints を input 側 (skill 本文「やること」) で引き出す手順を追加
2. Output 側 (要件定義.md テンプレート) に Constraints セクションを追加
3. Constraints の例 (技術 / 非機能 / セキュリティ・コンプライアンス / コスト / 期限・納期 / 組織・社内ルール / リソース) を skill 本文に列挙し、**技術的制約に閉じないことを明示**
4. 既存の `SKILL.md:149` の「技術的制約」表現を Constraints 全般に書き換え (技術以外も漏らさない)
5. スコープ外と Constraints の区別を skill 本文で明示
6. 常設セクションにするか optional にするか方針を決める (該当なしのときの書き方も含む)
7. basic-design skill 側との cascade 整理 (関連: 「define-requirements / basic-design と dialogue-principles の重複整理」の項目)
