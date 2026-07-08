# git-workflow: 自走でセッション開始時の git fetch が飛ぶ

完了 (2026-07-09)。v0.9.0 で対応。規律の文言だけでは自走で fetch が飛ぶ痛みに対し、git 最新化支援 hook を新規追加 (SessionStart は無条件 fetch、UserPromptSubmit は前回から 24h 超で fetch、remote 前進を検知したら「作業前に取り込め」と context に注入。ブロックしない支援 hook)。あわせて git-workflow skill に push 前の同期確認を追加した。機械が得意な fetch を機械に任せ、取り込むかの判断はエージェントに委ねる形で手当て。
