# e2e-reviewer の description に設計書/要件定義パスを渡す前提を明示

## 背景 / Why

main session は description ベースで agent 起動可否を判断するので、呼び出し側がパスを渡すべきことが description に明示されていないと、パス無しで呼び出して agent 側が手探りで探す事態になる (責務境界)。code-reviewer の同種の問題と同じ構造。

## 状況

`.apm/agents/e2e-reviewer.md` 本文 (L18) で「`docs/working/<title>/要件定義.md` に Done が書かれている (読む)」が前提と書かれている。一方 frontmatter の `description` には、呼び出し側がそのパスを渡すべきことが明示されていない。code-reviewer の description に設計書パスを明示する項目と同じ構造。

## 再開時の起点

1. `.apm/agents/e2e-reviewer.md` frontmatter の `description` に「呼び出し時に対象タイトルの要件定義 (および必要なら基本設計) のパスを引数として渡すこと」を明示
2. code-reviewer の同種項目と合わせて、subagent 一般の呼び出し規約として整理できないか検討 (pre-implementation-reviewer / done-verifier にも波及する可能性)
