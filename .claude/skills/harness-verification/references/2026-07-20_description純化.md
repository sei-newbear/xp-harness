---
目的: description 純化 (subagent 呼び出し規約の明示 + skill description 短縮) で発火・振る舞いが回帰しないか、パス受け渡し規約が効くか
対象: PR #21 refactor/description-purification (subagent 4 件の呼び出し規約明示、skill 6 件の description 短縮、gh 言及除去)
verdict: 回帰なし PASS (dialogue-principles の要件対話入口で新 0/3・旧 3/3 の回帰を検出 → 呼び出し動線を追加して再検証で 3 経路とも 2/2 発火に回復。パス規約は新旧とも飽和的に機能 = 明文化として妥当)
日付: 2026-07-20
モデル: シナリオ1・3・4=claude-opus-4-8、シナリオ2=claude-sonnet-5 (全ランで transcript の実測値を確認)
---

# description 純化 (PR #21) の発火・振る舞い検証

## 条件（再現レシピ）

- **sandbox**: `setup-sandbox.sh desc-purification`（既定の front/api/e2e 分離構成）。改修 worktree から作成したため worktree の掃除とセットで削除する
- **前後比較の差し替え**: 旧 (main) / 新 (PR branch) の 6 skill (git-workflow / define-requirements / dialogue-principles / story-slicing / slice-tdd / propose-options の SKILL.md) + 4 agent (code-reviewer / e2e-reviewer / pre-implementation-reviewer / done-verifier) を抽出し、sandbox の `.claude/skills/` / `.claude/agents/` に cp 差し替え。差し替え後は指紋 (done-verifier description の「呼び出し側」言及数: 新=1 / 旧=0) で毎回確認
- **baseline**: `base-empty` tag (docs なし初期状態) / `seed-impl` tag (注文レビュー画面の要件定義.md・基本設計.md を仕込み) / `seed-review` tag (review.md = 見出し文言・health への version 追加・E2E 追加の分野混在 3 指摘)。ラン毎に `git reset --hard <tag>` + `git clean -fd` + 差し替え再適用
- **ノーヒント依頼 (全文)**:
  - シナリオ 1 (フルフロー、新旧各 1): 「注文レビュー画面を新しく作りたいんだけど。（git は worktree や branch を切らず、今のブランチのまま進めていい）」。要件・設計の対話は検証者が依頼者役で手駆動 (不正注文の早期発見 / 月末差し戻し負荷 / 高額 10 万・10 分内 3 件の閾値、の線で新旧同一回答)
  - シナリオ 2 (実装フェーズ続き、新旧各 2): 「docs/working/注文レビュー画面/ に要件定義.md と基本設計.md があります。実装フェーズに入って進めてください。（git は worktree や branch を切らず、今のブランチのまま進めていい）」
  - シナリオ 3 (define-requirements 初動、新旧各 3): 「review.md にレビュー指摘をまとめたから対応お願い」。初動 2 ターン (作業場所・モード質問に回答後、要件対話の最初のターンまで) を観測して停止
  - シナリオ 4 (ゴール渡し自走、新旧各 1 完走): 「注文レビュー画面を作りたい。運用管理者が要確認の注文を承認 / 差し戻しできるようにしてほしい。あとは任せる、いい感じに作って。（git は worktree や branch を切らず、今のブランチのまま進めていい）」。モードゲートで依頼者役が自走側を選択
- **駆動**: `claude-launcher.sh` (launch に `--model` を今回追加) + `analyze-session.py`。実装自走はドライバスクリプト、対話フェーズと自走のモードゲートは手駆動。パス受け渡しは jsonl の Agent tool_use の prompt を機械抽出して判定

## 結果

### 回帰なしを確認した観測点 (新旧同等または新が同等以上)

- **define-requirements 発火**: 新 5/5・旧 5/5 (シナリオ 3 初動 3+3、フルフロー、ゴール渡し)。曖昧な md まとめ依頼でも短縮版で確実に発火
- **done-verifier の skip 禁止**: 完走 8 ラン全てで完了宣言・完了フロー前に done-verifier 起動 (新 4/4・旧 4/4、再検証 ×2 のランも複数)。例示を 3→2 個に削っても実効性に変化なし
- **git-workflow**: 新 6/7・旧 7/7 (新の 1 落ちはフルフロー 1 本のみ、シナリオ 3 では 3/3)。gh 言及除去の悪影響なし
- **slice-tdd**: 新 4/4・旧 3/4 (旧で 1 落ち)。TDD サイクル自体は全ランで実施
- **story-slicing / propose-options / basic-design / handoff-docs**: フルフローで新旧とも発火 (story-slicing はゴール渡し自走で新 0/1・旧 1/1 の揺らぎ。既知の routing 空白地帯カードの範疇)
- **フルフローの成果**: 新 = 12 skill / subagent 15 / 7 コミット、旧 = 14 skill / subagent 20 / 11 コミット。どちらも要件定義 → 上流レビュー反映 → 基本設計 → 実装 4+ サイクル → done-verifier まで完走

### パス受け渡し規約 (新規追加分の効果)

- **subagent 起動プロンプトへの要件定義・基本設計パスの明示**: 新 33/33 (docs がある全ラン)、旧 31/31。**旧 description でも飽和的にできており、規約追加は「観測された失敗の修正」ではなく「既にできていた良い挙動の interface への明文化」**
- **docs が無い完全自走 (シナリオ 4 新版)**: 呼び出し側が「要件定義.md は作成していません。代わりに口頭合意の要件を使ってください」とパス契約に明示応答 (サイクル 1・2 と done-verifier。サイクル 3・4 は省略 = セッション内劣化)

### 要対処: dialogue-principles の発火低下 (新版)

- **シナリオ 3 の要件対話入口 (モード合意後の最初の要件対話ターン)**: 旧 3/3 発火・新 0/3 発火 (全ラン claude-opus-4-8、生 jsonl で Skill tool_use ゼロ・SKILL.md Read ゼロを確認)
- ただしフルフロー (対話が深い) では新でも発火 (新 1/1・旧 1/1)、ゴール渡しでは新 1/1・旧 0/1。**「発火しなくなった」ではなく「対話入口での発火が遅く/細くなった」**が正確
- 新 description は発火対象の列挙 (「要件のヒアリングや基本設計の議論を進めるとき」「依頼者に確認したいとき」等) を圧縮しており、これが対話入口のマッチングを弱めたと推定

### 回帰への対処と再検証 (同日、新版のみ)

原因調査: define-requirements / basic-design のどちらの本文にも dialogue-principles を呼ぶ案内が **新旧とも無く**、発火は dialogue-principles 自身の description の自己発火と運用ルールの 2 行だけに支えられていた。description 短縮で自己発火が弱まり、支えが 1 本になって落ちた構造 (propose-options / handoff-docs は「呼ぶ」と書かれているのに dialogue-principles だけ案内がなく、代わりに「対話の型」という同趣旨の規律が各 skill に自前で書かれている状態)。

対処: 対話モードに入る 3 経路それぞれに「`dialogue-principles` skill を呼ぶ」を追加 (モード合意ゲートで対話モードを選んだとき / 依頼者がいきなり議論を始めたとき / 基本設計フェーズの開始時)。強度は「合意の瞬間に 1 回呼ぶ」に留め、継続注入は別カードの領域として入れない。

再検証の条件: 新版のみ・claude-opus-4-8・各経路 2 本・初動数ターンで停止。仕込みは経路ごとに `seed-review` / `base-empty` / `seed-req` (要件定義.md のみの新規 tag)。依頼文は順に「review.md にレビュー指摘をまとめたから対応お願い」「注文レビュー画面を作ろうと思ってるんだけど、いまの構成だと注文のデータも無いよね。どう作るのがいいと思う？」「@docs/working/注文レビュー画面/要件定義.md basic-design で設計を進めて」。質問への回答は手駆動 (作業場所は master、モードは対話)。

結果: **3 経路とも 2/2 発火** (生 jsonl の Skill tool_use で確認)。議論から入る経路の 2 本目はモード質問を出さず議論に即応答しつつ発火しており、今回足した枝が直接効いた形。

**残存する事実 (書き分け)**: 対処したのは上記 3 経路のみで、**description の自己発火が弱まったこと自体は残っている**。フェーズ skill を経由しない入口 (レビュー指摘への直接応答、実装中の設計判断の議論、skill 改修中の議論) は依然 description と運用ルールだけが支え。これらは退行が未観測のため今回は入れない判断 (痛みが出てから)。

### 付随観測

- ゴール渡し「あとは任せる」の初動: 新 2/2 でモード確認が出て対話寄り推奨、旧 1/1 で自走推奨 (n 小、参考)
- launcher の実運用知見: v2.1.215 で remote-control active の画面文言変更 + pty 空白潰れ (空白非依存 grep が必要)、welcome dialog による send 不発 → wait-idle の「起動時から静止」を未送信サインとして Enter 再送で解消

## 検証手順上の失敗 (次回への教訓)

- 実行中の bash スクリプトを編集して実行プロセスを破壊 (bash は逐次読み) → 1 ランを transcript から救済。**ドライバ編集はバッチ完了後に行う**
- `git tag -f <tag> -q` の `-q` 未対応がサイレント失敗し baseline 欠落 → 1 ラン無効。**tag 作成後は rev-parse で存在確認**
- baseline を branch にしたら検証セッションの branch 掃除で消えた → **baseline は tag にする**
- 50 分超の自走を TIMEOUT で止めてしまった (画面は稼働中) → resume + 「続けて」で復旧 (介入 1 回として記録)。**TIMEOUT 時は「まだ処理中か」を必ず見てから判断**
- 質問ウィジェットへの回答をスクリプトで自動化したら "User declined to answer questions" になり 1 ランが無効化 (複数質問ウィジェットは選択と Submit の状態遷移があり、機械的な Enter 連打で却下される)。**質問への回答は手駆動が確実** (画面を読んでから矢印と Enter を送る)
