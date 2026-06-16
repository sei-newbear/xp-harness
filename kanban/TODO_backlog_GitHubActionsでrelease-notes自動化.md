# GitHub Actions で release notes 自動化 (CHANGELOG.md 廃止)

## 背景 / Why

CHANGELOG.md を repo root に手動でメンテするのは面倒。代わりに GitHub Releases の release notes を Actions で自動生成する運用にする (リリース運用)。

## 状況

CHANGELOG.md を repo root に手動でメンテするのは面倒。代わりに GitHub Releases の release notes を **Actions で自動生成**する運用にする。

候補 action / 方式:
- `release-please` (Google 製、conventional commits から CHANGELOG / release notes / version bump を自動化)
- `release-drafter` (PR ラベルから release notes を draft 生成)
- `gh release create` を tag push trigger で叩く独自 Action

採用 action / 方式は実装時に propose-options で議論。

## 再開時の起点

1. `release-please` / `release-drafter` / 独自 Action の 3 案を比較
2. conventional commits (feat: / fix: / chore: 等) の運用ルール を harness の commit 規約に組み込むか判断
3. `.github/workflows/release.yml` を整備
4. 初回 tag (`v0.1.0`) を push したときの自動生成挙動を確認
