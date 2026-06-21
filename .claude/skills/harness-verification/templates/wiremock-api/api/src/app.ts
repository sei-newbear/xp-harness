import { Hono } from "hono";
import { quoteShipping } from "./shipping-client.js";

export const app = new Hono();

app.get("/health", (c) => c.json({ ok: true }));

// 注文の配送料見積もり。外部 配送料 API に問い合わせて料金を返す。
app.post("/shipping/quote", async (c) => {
  const body = await c.req.json();
  const quote = await quoteShipping({
    origin: body.origin,
    destination: body.destination,
    weight: body.weight,
    dimensions: body.dimensions,
    service: body.service,
    insurance: body.insurance,
  });
  return c.json(quote);
});
