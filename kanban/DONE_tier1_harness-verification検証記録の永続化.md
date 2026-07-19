# harness-verification 検証記録の永続化

完了 (2026-07-19)。検証記録を `.claude/skills/harness-verification/references/` に「再現レシピ + 結果」の自己完結ファイルで残す仕組みを追加 (v0.16.0 でリリース)。format 点検 (`validate-verifications.sh`) と横断検索 (`find-verifications.sh`) つき。あわせて検証セッションの駆動方法論 (FIFO 駆動の submit 確認・dialog 対策・wait-idle) を手順 3 に書き戻した。main-instructions 痩せ検証のふりかえり (バケツ 1) から生まれた改修。
