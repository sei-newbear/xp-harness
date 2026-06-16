# git-workflow skill の `gh` 禁止 / PR 作成依頼者責務の汎用性検討

## 背景 / Why

git-workflow skill の「`gh` コマンドは使わない」「PR 作成は依頼者の責務」は元々 attendance-workers の環境固有経験則として生まれたルール。汎用 OSS としては consumer ごとに合わない可能性がある (例: `gh` を install 前提で運用するチームもある)。

## 状況

git-workflow skill には:
- 「`gh` コマンドは使わない」(挙動の安定性を優先)
- 「PR 作成は依頼者の責務」(守備範囲は git push まで)

がある。これらは元々 attendance-workers の環境固有経験則として生まれたルール。汎用 OSS としては consumer ごとに合わない可能性がある (例: `gh` を install 前提で運用するチームもある)。

## 取り得る案

- 案 a: core 哲学として残し、根拠を「責務分離」(守備範囲は git push まで) に書き直す
- 案 b: 中立化 (`gh` 禁止を外す、PR 作成方法は consumer の自前 instruction で決める)
- 案 c: 現状維持 + 「consumer は自前 instruction で override してよい」を skill 本文で明示

## 再開時の起点

1. consumer のフィードバックを集める (`gh` 使いたい / PR 作成も harness で扱いたい等)
2. 案 a / b / c のどれが筋か propose-options で議論
