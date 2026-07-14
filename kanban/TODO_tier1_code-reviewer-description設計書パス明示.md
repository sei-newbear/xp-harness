# code-reviewer の description に設計書/要件定義パスを渡す前提を明示

## 背景 / Why

main session (呼び出し側) は description ベースで agent 起動可否を判断するので、「何を一緒に渡すべきか」が description だけで分からないと、パス無しで呼び出してしまい agent 側が手探りで探す事態になる (責務境界)。

## 状況

`.apm/agents/code-reviewer.md` の本文 (L17-18) では「呼び出される時点で `docs/working/<title>/要件定義.md` / `基本設計.md` がある (読む)」が前提と書かれている。一方 frontmatter の `description` には「設計整合 (docs/working/<title>/基本設計.md との照合)」とは書いてあるものの、**呼び出し側がそのパスを渡すべき** ことが明示されていない。

main session (呼び出し側) は description ベースで agent 起動可否を判断するので、「何を一緒に渡すべきか」が description だけで分からないと、パス無しで呼び出してしまい agent 側が手探りで探す事態になる。

## 再開時の起点

1. `.apm/agents/code-reviewer.md` frontmatter の `description` に「呼び出し時に対象タイトルの要件定義 / 基本設計のパスを引数として渡すこと」を明示
2. main session 側 (instructions / 関連 skill) で code-reviewer を呼ぶ際の例示文言とも整合を取る
