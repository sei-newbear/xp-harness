# リリース時に `latest` タグを更新する仕組み

## 背景 / Why

上位の目的は **「consumer が install 時に最新版を簡単に取れる」**。具体的には APM などの package manager で `xp-harness@latest` のような書き方をしたら最新リリースが解決される、というシナリオを成立させたい。

## 状況

上位の目的は **「consumer が install 時に最新版を簡単に取れる」**。具体的には APM などの package manager で `xp-harness@latest` のような書き方をしたら最新リリースが解決される、というシナリオを成立させたい。

第一歩 (= 検証手段) として **git tag `latest` を毎リリースで最新 commit に付け替える運用** を試す。`@latest` 解決が tag ベースで動くかを実際に確認し、足りない部分があれば次の手段 (= GitHub Release マーカー / APM 側の version 解決ロジック / その他) を順に検討する。

関連: 「GitHub Actions で release notes 自動化」の項目と同じ「リリース運用」系統だが独立 TODO。release notes 自動化と一緒に整備すると Action が共通化できる可能性。

## 再開時の起点

1. git tag `latest` の付け替え方式を決める (= リリース時に手動 `git tag -f latest <commit>` + `git push -f origin latest` で運用するか、GitHub Actions で自動化するか)
2. force push を伴うので運用ルールを整理 (= `latest` tag は常に最新を指す移動 tag、固定 tag (`v0.x.x`) と運用責務を切り分ける)
3. consumer 側で `xp-harness@latest` が期待通り解決されるかを実環境で検証
4. 解決されない場合の次手 (= GitHub Release の "Latest" マーカー / APM 側の version 解決ロジック改修 / その他) を propose-options で整理
5. 関連: 「GitHub Actions で release notes 自動化」の項目と並走する場合は Action を共通化できないか検討
