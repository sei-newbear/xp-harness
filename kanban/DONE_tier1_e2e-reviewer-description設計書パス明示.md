# e2e-reviewer の description に設計書/要件定義パスを渡す前提を明示

完了 (2026-07-21、v0.17.0)。`.apm/agents/e2e-reviewer.md` の description に「呼び出し側は対象タイトルの要件定義 (あれば基本設計も) のパスをプロンプトで渡すこと」を明示し、235 字に短縮。code-reviewer / pre-implementation-reviewer / done-verifier も同じ規約で揃えた (subagent 一般の呼び出し規約として 4 件横断で整理)。
