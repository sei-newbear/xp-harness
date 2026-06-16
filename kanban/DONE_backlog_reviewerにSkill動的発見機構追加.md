# reviewer に Skill 動的発見機構追加

完了 (2026-05-24、実装 / E2E実行 skill 新設で消化、PR レビューで整理)。code-reviewer / e2e-reviewer の `tools:` に `Skill` を追加 (preload 外 skill を名指し発火できる能力)。名指し参照の案内は呼ぶ側 (reviewer 本文) でなく skill 本文側に集約 (DRY。reviewer は preload で規約を取得し、本文の案内に従って Skill tool で辿る)。done-verifier / pre-implementation-reviewer は当初 preload only 明示も検討したが、`tools:` で自明なため見送り。subagent の名指し発火は公式仕様で確認済 (code.claude.com/docs/en/sub-agents 409-426 行)、かつ probe テスト + consumer headless run で実機の発火を確認済。
