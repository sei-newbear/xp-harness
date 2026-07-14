# git-workflow skill の description から `gh` 不使用ルール言及を除去 (具体ツール名 NG)

## 背景 / Why

description は interface なので、具体ツール名 (`gh` / `gh cli`) は入れるべきでない。commit / branch / push などの Git 一般概念は OK だが、`gh` のような特定ツール名は consumer 環境によっては前提が変わるため NG (interface 純化)。

## 状況

`.apm/skills/git-workflow/SKILL.md` の frontmatter `description` (L10, L12) に「`gh` 不使用ルール」「`gh` 禁止」と具体ツール名が書かれている。description は interface なので、具体ツール名 (`gh` / `gh cli`) は入れるべきでない。

判断軸: **commit / branch / push などの Git 一般概念は OK** (Git そのものの概念なので普遍)。`gh` のような **特定ツール名は NG** (consumer 環境によっては前提が変わる)。「git-workflow の `gh` 禁止 / PR 作成依頼者責務の汎用性検討」の項目と関連。

## 再開時の起点

1. `.apm/skills/git-workflow/SKILL.md` frontmatter description から `gh` 言及を除去
2. description は「Git 操作の規律 (branch / commit / push / pull / rebase / conflict 等)」一般概念レベルの表現に統一
3. `gh` 禁止の具体ルール自体は skill 本文に残してよい (本文は実装層)、ただし「git-workflow の汎用性検討」の項目で汎用性自体も再検討予定
