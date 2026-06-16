# SECURITY.md の追加 (将来必要になったら)

## 背景 / Why

OSS 公開リポジトリの慣行として `SECURITY.md` (脆弱性報告ポリシー) を root に置くケースが多い。xp-harness は markdown ファイル中心で実行可能コードがほぼないため初版では同梱せず、将来必要になったら追加する (リリース運用)。

## 状況

OSS 公開リポジトリの慣行として `SECURITY.md` (脆弱性報告ポリシー) を root に置くケースが多い。xp-harness は markdown ファイル中心で実行可能コードがほぼないため、典型的な「脆弱性」(XSS / SQLi / auth bypass 等) 概念が当てはまりにくく、初版では同梱しない。

GitHub にはデフォルトで Security Advisory 投稿フォームが存在するため、SECURITY.md がなくても報告経路は失われない。

将来 harness 自体に実行可能コード (Action / script 等) が増えるか、第三者からの脆弱性報告が現実味を帯びたタイミングで追加する。

## 再開時の起点

1. 実行可能コード (`.github/workflows/`、CLI script 等) が harness に増えたか確認
2. `SECURITY.md` を root に配置 (Contributor Covenant の SECURITY 雛形、または GitHub の Security Advisory ガイド準拠)
3. README から link
