# announce-release 次リリースに載せる

## 背景 / Why
`announce-release` skill（リリース周知テキスト生成、改修者向け）を新規追加し main に push 済み（commit `6b4466d`）。次のリリースノートに「開発者向け Added」として載せると、この skill の存在が consumer 側の改修者にも伝わる。

## 状況
skill 本体は完成・push 済み。まだどのリリースにも含まれていない（未タグ）。`release` skill は前タグ→現 main のコミットを拾って分類するため、次に release を回せば範囲に自動で入る想定。取りこぼし防止の頭出しとしてカード化。

## 再開時の起点
次に `release` skill を回すとき、Step 4 のリリースノート作成で `announce-release` skill 追加を「開発者向け → Added」に含める（利用者向けではない＝配布対象外の改修者向け skill）。
