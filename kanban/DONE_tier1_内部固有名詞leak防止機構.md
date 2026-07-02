# 公開 OSS リポジトリへの内部固有名詞 leak 防止機構

完了 (2026-07-02)。`disclosure-guard` skill ＋ `disclosure-auditor` subagent として実装。内部由来の知見を公開リポジトリにコミット / push する前に、会話文脈を持たない subagent が組織固有の固有名詞を独立点検する（grep でなく読んで判断、迷ったら止める）。方式は案 A（done-verifier 拡張）・案 B（hook）でなく、read-and-judge の独立点検（案 C 寄り）を採用。機密・認証情報は範囲外。skill-reviewer を通し、`.gitignore` の allowlist 未登録（commit されない穴）を修正、dogfood で自己点検 CLEAN。
