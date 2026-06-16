# pre-implementation-reviewer の description に要件定義/基本設計パスを渡す前提を明示

## 背景 / Why

description だけ読んで呼び出すと paths を渡さず agent 側が手探りで探す事態になり得る。code-reviewer / e2e-reviewer と同根の問題で、subagent 一般の呼び出し規約として整理できる可能性がある (責務境界)。

## 状況

`.apm/agents/pre-implementation-reviewer.md` の frontmatter `description` (L3) では「`docs/working/<title>/要件定義.md` と `docs/working/<title>/基本設計.md` が書き終わった段階で、依頼者または main session が呼ぶ」と書かれているが、**呼び出し側がそのパスを引数として渡す前提** であることが軽い書き方になっており、明確に読み取れない。本文 (L14-16) では前提として明示されているが、description だけ読んで呼び出すと paths を渡さず agent 側が手探りで探す事態になり得る。

code-reviewer / e2e-reviewer の description にパスを明示する項目と同根の問題。subagent 一般の呼び出し規約として整理できる可能性がある。

## 再開時の起点

1. `.apm/agents/pre-implementation-reviewer.md` frontmatter の `description` に「呼び出し時に対象タイトルの要件定義 / 基本設計のパスを引数として渡すこと」を明示
2. code-reviewer / e2e-reviewer / 本項目を束ねた「subagent 呼び出し規約」として整理できないか検討
