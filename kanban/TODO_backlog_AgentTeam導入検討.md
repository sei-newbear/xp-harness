# AgentTeam 導入検討

## 背景 / Why

Claude Code v2.1.32+ の実験的機能 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`。teammate 同士が直接通信する decentralized なマルチエージェント機構で、xp-harness の long-term 構想 (要件定義から agent ペアで意思決定 / ユーザーストーリーごとにチームを作って対応) と方向性が一致する可能性がある。

## 状況

Claude Code v2.1.32+ の実験的機能 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`。teammate 同士が直接通信する decentralized なマルチエージェント機構。

xp-harness の long-term 構想 (要件定義から agent ペアで意思決定 / ユーザーストーリーごとにチームを作って対応) と方向性が一致する可能性。

## 注意点

- lead 固定 / ネスト不可 / 1 セッションに 1 チームの制限あり
- 既存 agent 定義 (`code-reviewer.md` 等) を teammate role として再利用可能。**ただし `skills:` プリロード指定は teammate モードでは無効**になる点に注意
- 「subagent はペアプロ相手」哲学と teammate モードの整合を取る必要 (worker 模式に倒さない)

## 再開時の起点

1. 現行 subagent / skill の検証がもう一段進んでから本格導入を計画
2. 1 ストーリー単位の AgentTeam 試験導入を計画
3. 既存 agent 定義の teammate role 再利用方法の検証 (preload skill 不可問題への対応)
