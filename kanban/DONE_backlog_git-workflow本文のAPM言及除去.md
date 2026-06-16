# git-workflow 本文の APM 言及除去

完了 (2026-06-13)。git-workflow 本文の APM 機構言及 (`.apm/instructions/`、`apm compile`、`last-installed-wins`、`consumer`) を APM 非依存の汎用表現に書き換え。合わせて全 5 skill (`git-workflow` / `dialogue-principles` / `e2e` / `e2e-execution` / `implementation`) の `CLAUDE.md` ハードコードを agent 非依存化:

- 上書き効果アンカー箇所 (git-workflow / dialogue-principles): 「project の instruction (Claude Code なら CLAUDE.md) と skill が優先」という折衷表現で、上書き効果を維持しつつ agent 非依存化
- 規約ファイル例示箇所 (e2e / e2e-execution / implementation / git-workflow): 「CLAUDE.md / AGENTS.md 等のドキュメント」と agent-inclusive に変更
- override section: 実行時の振る舞い (project 固有ルールが優先 / 部分上書きが標準) だけに限定し、consumer 向けカスタマイズ how-to は README に移設
- README: ファイル全体置換より部分カスタマイズを推奨する判断を追記

sandbox 検証 (条件A: アンカーあり / 条件B: アンカーなし) で commit 自走の差を確認。アンカーあり→commit 作られた、なし→commit 作られなかった (経路の違いの可能性は残る)。
