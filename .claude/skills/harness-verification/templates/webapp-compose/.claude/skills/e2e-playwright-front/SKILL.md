---
description: このプロジェクトの E2E spec (e2e/ 配下、Playwright) を書く・編集するときに発火させる front E2E の流儀。ロールベースセレクタ・日本語ヘルパー関数・GIVEN/WHEN/THEN 構造・テスト独立性・ファイル配置の規約を扱う。
---

# front E2E の流儀 (Playwright)

このプロジェクトの E2E は「動作確認スクリプト」ではなく**仕様書**として読めることを目指す。迷ったら「非エンジニアが読んで意図を追えるか」で判断する。

## セレクタはユーザー視点で

優先順位: `getByRole` (役割と文言) → `getByLabel` / `getByText` (見える文字) → `getByTestId` → `page.locator('#id')` は最終手段。ID セレクタは実装詳細に結合し、仕様書としての価値を失う。

## 操作はヘルパー関数 (日本語名) に切り出す

- テスト本体は**ステップを並べただけ**に見える状態を保つ。Playwright API の生呼び出しは `e2e/steps/` のヘルパーに隠蔽する
- 関数名は日本語で意図を表現する (例: `メモを追加する(page, { 本文 })`)
- テスト本体に `page.click` / `page.locator` / `expect(page...)` が出てきたらヘルパーへ昇格させるサイン
- ヘルパーは嘘をつかない: 受け取った引数は実装内で必ず使う

## 前提 (GIVEN) と行動 (WHEN/THEN) を describe / test で分離する

- GIVEN: `test.describe` の名前 (名詞句) + `beforeEach` で前提状態を作る
- WHEN/THEN: `test` 本体 (動詞句で始まり結果まで言い切る名前)
- 外側 describe (機能名) > 内側 describe (GIVEN 句) > test 名 を連結すると、完結した日本語の仕様文になるのが目印

## テスト独立性

- 前提となる状態は必ず `beforeEach` で**自分で作る** (他テストの副作用に頼らない、`afterEach` だけに頼らない)
- 実行順序が変わっても、単独で実行しても、正しく動くこと

## ファイル配置

- spec は `e2e/specs/<シナリオ名>.spec.ts`、1 ファイル 1 シナリオ。連番は付けない
- ヘルパーは `e2e/steps/` 配下
