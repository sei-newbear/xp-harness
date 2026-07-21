# git-workflow skill の description から `gh` 不使用ルール言及を除去 (具体ツール名 NG)

完了 (2026-07-21、v0.17.0)。`.apm/skills/git-workflow/SKILL.md` の description から具体ツール名の言及を除去し、Git 一般概念 (branch / commit / push / pull / rebase / conflict) の表現に統一。あわせて 571 字 → 309 字に短縮。運用ルール自体は skill 本文 (実装層) に残置しており、振る舞いは変えていない。検証で git-workflow の発火に回帰がないことを確認済み (新 6/7・旧 7/7)。
