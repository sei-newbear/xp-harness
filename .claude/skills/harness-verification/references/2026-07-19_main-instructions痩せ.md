---
目的: 痩せた main.instructions.md で全フェーズ skill の発火・全フローの振る舞いが回帰しないか
対象: main.instructions.md ゼロベース再構成 (164→54 行, v0.15.0)
verdict: 回帰なし PASS (付随: story-slicing 発火は新旧とも揺らぎ=痩せ非依存)
日付: 2026-07-19
モデル: 未記録 (モデル記録の必須化前。当時の環境既定で実行)
---

# main.instructions.md 痩せ版の発火・振る舞い検証

## 条件（再現レシピ）

- **sandbox**: `setup-sandbox.sh <名> --bare`（発火観測が主目的でアプリ不要）
- **仕込み（前後比較の deploy 差し替え）**: instruction は apm で `.claude/rules/main.md` に deploy される（frontmatter が `applyTo:` → `paths:` に変換、本文は無変換）。旧＝164 行版、新＝54 行版を作り、`.claude/rules/main.md` を旧/新で cp 差し替えして前後比較。実装フェーズ検証では `docs/working/注文レビュー画面/` に要件定義.md・基本設計.md を置いた途中状態を仕込む。シナリオは「運用管理者が要確認の注文を一覧で見て承認/差し戻しする画面（注文レビュー画面）」。
- **ノーヒント依頼（全文）**:
  - フルフロー: 「注文レビュー画面を新しく作りたいんだけど。（git は worktree や branch を切らず、今のブランチのまま進めていい）」。**対話フェーズ（要件定義・基本設計）は 1 発プロンプトで再現できないため、検証者が依頼者役で対話を回す**（Why/Done/スコープに答える、推奨案を選ぶ）。実装フェーズで自走に切り替わる。
  - retrospective: 別セッションで「さっきまでの注文レビュー画面の作業、今日のふりかえりをしよう。」
  - ゴール渡し自走: 「…あとは任せる、いい感じに作って」（substantial）/「/health を返すエンドポイントを追加して。あとは任せる」（trivial）
- **前後比較 / 試行数**: フルフロー各 1 本。story-slicing 発火は要件完成まで 新 4 本・旧 3 本。substantial＋任せるでのモード確認は 各 3 本。駆動は `claude-launcher.sh`（interactive）＋ `analyze-session.py`。長い実装フェーズはドライバスクリプトで一気通貫に回す（micro-step で人を呼び戻さない）。

## 結果

- **全フェーズ skill が発火・回帰なし PASS**。フルフロー 1 本（新版）で **9 skill 発火**（`define-requirements` / `dialogue-principles` / `handoff-docs` / `basic-design` / `propose-options` / `slice-tdd` / `e2e` / `e2e-execution` / `implementation`）＋ **subagent 4**（`handoff-verifier`×2 / `code-reviewer` / `e2e-reviewer`）。要件定義.md・基本設計.md・Cycle1 実装コミットを生成。
- **対話→自走のモード切替が機能**。対話フェーズは 1 問ずつ・迎合しない（「全注文目視はスケールしない」と正直に指摘）・書き起こし前確認。実装は自走に切替。
- **サイクル**: Cycle1 は正典（E2E-red → green〈orders→views→routes 層を最小実装〉→ code-reviewer → リファクタ無し〈理由を commit に記載〉→ commit）。薄い層は自前テスト無しで E2E が担保。Cycle2 は承認ロジック層に**ユニットテストの入れ子小サイクル**（orders.test.ts red→実装→green 試行）を踏んだ。
- **止まり方**: 実装依頼以降 AskUserQuestion もチャット発話も 0（連続自走）。設計全部固めた後なので手戻り判断が無く止まらないのが正しい。設計逸脱（SQLite ドライバ better-sqlite3→node:sqlite、ビルド環境都合）を実装レイヤーと判定し自走で直して基本設計.md 更新（進みすぎ無し）。
- **レビュー処理**: code-reviewer の Critical 2 件（DB ドライバの設計 md 未更新 / vitest スコープで無関係テスト失敗）を commit 前に提案どおり対応。e2e-reviewer の Suggestion 2 件は後回し/次サイクル（Suggestion=任意）。Security 指摘なし。ペアプロ捕捉が効いた（設計 md 更新漏れを reviewer が捕捉）。
- **retrospective**: 作業途中の中断では暴発せず「全ストーリー未完了なので今日はやらない」と見送り、別セッションの明示トリガーで発火。
- **ゴール渡し自走**: 「任せる」を自走合意と解釈して直行（trivial は define-requirements ごとスキップ、substantial は define-requirements 発火後に自走）。「任せる」無しならモード質問が出て自走を選べる。

## 付随観測（痩せ非依存）

- **story-slicing の発火が不安定（揺らぎ）**: 要件完成後に発火すべきだが 新 2/4・旧 2/3 でバラつく。原因は routing の空白地帯（`define-requirements` は次フェーズ誘導で `basic-design` を案内し story-slicing を飛ばす、`slice-tdd` は「前段で済んでいる前提」、誰も呼ばず self-fire 頼み）。old/new 同構造なので痩せの回帰ではない。
- **substantial＋任せるで最小合意確認をスキップ**: 新 3/3 直行・旧 1/3 確認＝痩せ非依存。
