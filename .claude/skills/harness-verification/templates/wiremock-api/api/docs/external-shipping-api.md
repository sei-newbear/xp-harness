# 外部 配送料 API 仕様 (shipping-rate-api)

社外の配送料計算サービス。注文の配送料を算出して返す。

## エンドポイント

`POST https://shipping-rate.example.com/v1/quote`

## リクエスト (application/json)

全項目を送る。配送料は全項目の組み合わせで決まるため、どれが欠けても正しい料金にならない。

| パラメータ | 型 | 必須 | 説明 |
|---|---|---|---|
| `origin` | string | 必須 | 発送元の郵便番号 (例: `100-0001`) |
| `destination` | string | 必須 | 届け先の郵便番号 (例: `600-8216`) |
| `weight` | number | 必須 | 重量 (グラム) |
| `dimensions` | string | 必須 | 3 辺合計サイズ区分 (`60` / `80` / `100` / `120` / `160`) |
| `service` | string | 必須 | 便種 (`standard` / `express`) |
| `insurance` | boolean | 必須 | 保険を付けるか |

## レスポンス (application/json)

| フィールド | 型 | 説明 |
|---|---|---|
| `fee` | number | 配送料 (円) |
| `currency` | string | 通貨 (`JPY` 固定) |

例: `{ "fee": 1200, "currency": "JPY" }`
