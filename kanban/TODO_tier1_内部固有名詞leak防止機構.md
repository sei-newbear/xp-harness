# 公開 OSS リポジトリへの内部固有名詞 leak 防止機構

## 背景 / Why

ふりかえり skill が活用されるほど内部 → 公開の翻訳機会が増え、「内部フィードバック → 公開リポジトリへの反映」のステップで内部固有名詞が意図せず公開 git 履歴に混入するリスクがある。公開リポジトリの git 履歴は force-push しない限り遡れるため、一度 commit に入った固有名詞は実質永久に残る。翻訳ステップでの leak 防止機構を予防的に整備したい。

## 状況

xp-harness には ふりかえり skill (`.apm/skills/retrospective/`) があり、 改修セッション内で得た内部フィードバック (= 社内の運用観察、 別 consumer プロジェクトでの利用経験、 関係者からの指摘等) を kanban / skill / docs に反映するワークフローが存在する。

この **「内部フィードバック → 公開リポジトリへの反映」 のステップ** で、 内部 consumer プロジェクト名 / 顧客名 / 社内組織名等が意図せず公開 git 履歴に混入するリスクがある。 現状は改修者本人 / main session の注意力に依存しており、 構造的なガードがない。

公開リポジトリの git 履歴は force-push しない限り遡れるため、 一度 commit に入った固有名詞は実質永久に残る。 ふりかえり skill が活用されるほど内部 → 公開の翻訳機会が増えるため、 翻訳ステップでの leak 防止機構を予防的に整備したい。

## 検討中の選択肢 (要 propose-options)

- **案 A**: `done-verifier` の責務を拡張し、 公開 OSS リポジトリでは commit / push 前に内部固有名詞の grep check を追加する
  - メリ: 既存 push 前 pattern を活用、 agent 追加コストなし、 self-host で動く
  - デメ: done-verifier の責務 (テスト再実行 / build / TODO 残検出) が肥大化する懸念
- **案 B**: hook (例: pre-commit hook) で機械的に grep check
  - メリ: 安く確実に止まる、 main session 介さず動く
  - デメ: 検知対象リストの保守が必要、 hook が consumer 環境にも入ると誤検知の元
- **案 C**: 新規 leak-check agent
  - メリ: 責務単一化、 明確
  - デメ: agent overhead が単一観点には大きすぎる

## 再開時の起点

1. 案 A / B / C を propose-options skill フォーマットで詰める (依頼者と認識合わせ)
2. 「公開 OSS リポジトリ」 の判定方法を決める (= xp-harness 固有 ON か、 `git remote -v` 自動判定か、 consumer に配布する場合は opt-in 設定か)
3. 検知対象の表現方法を決める (= 既知固有名詞リストを改修者の手元 (= リポジトリ外) で管理 + 汎用ツール (`gitleaks` 等) 再利用も検討)
4. 案 A の場合: done-verifier の責務マップが肥大化しすぎないか責務境界を確認 (= done-verifier のテスト/build/source dir 言及の完全除去の項目と接続)
5. 関連: skill 編集時の hook ベース自動チェックの項目と機構が近いので共通化可能か検討
