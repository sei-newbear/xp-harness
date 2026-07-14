# AgentTeam 導入検討

## 背景 / Why

Claude Code v2.1.32+ の実験的機能 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`。teammate 同士が直接通信する decentralized なマルチエージェント機構で、xp-harness の long-term 構想 (要件定義から agent ペアで意思決定 / ユーザーストーリーごとにチームを作って対応) と方向性が一致する可能性がある。

## 状況

Claude Code v2.1.32+ の実験的機能 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`。teammate 同士が直接通信する decentralized なマルチエージェント機構。

xp-harness の long-term 構想 (要件定義から agent ペアで意思決定 / ユーザーストーリーごとにチームを作って対応) と方向性が一致する可能性。

## tier1 スコープ: 調査スパイクに限定 (2026-07-14)

tier1 に上げるのは **調査スパイク (機構理解 + 制約の実地検証)** まで。**本格導入・試験導入の判断はスパイク結果待ちで据え置く** (philosophy の 4 象限で AgentTeam の本格導入は「痛みが明確化していない / スコープ外」= 象限4。スパイクは低コストの調査なので先行してよい)。

スパイクで潰すこと:
- teammate モードの実際の挙動 (lead 固定 / ネスト不可 / 1 セッション 1 チームの制限が xp-harness の使い方に効くか)
- 既存 agent 定義を teammate role で再利用したとき `skills:` プリロードが無効になる問題の回避策があるか
- 「subagent はペアプロ相手」哲学と teammate モードが両立するか (worker 模式に倒れないか)

スパイクの出力 (できる / できない・痛み・価値) を踏まえて、本格導入を象限4 から採用に移すか改めて判断する。

## 注意点

- lead 固定 / ネスト不可 / 1 セッションに 1 チームの制限あり
- 既存 agent 定義 (`code-reviewer.md` 等) を teammate role として再利用可能。**ただし `skills:` プリロード指定は teammate モードでは無効**になる点に注意
- 「subagent はペアプロ相手」哲学と teammate モードの整合を取る必要 (worker 模式に倒さない)

## 再開時の起点

1. 現行 subagent / skill の検証がもう一段進んでから本格導入を計画
2. 1 ストーリー単位の AgentTeam 試験導入を計画
3. 既存 agent 定義の teammate role 再利用方法の検証 (preload skill 不可問題への対応)
