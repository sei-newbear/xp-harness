import { describe, it, expect } from "vitest";
import { app } from "../src/app.js";

async function 見積もりを取得する(body: Record<string, unknown>) {
  return app.request("/shipping/quote", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

describe("配送料見積もり", () => {
  it("東京→京都の通常便の配送料を返す", async () => {
    const res = await 見積もりを取得する({
      origin: "100-0001",
      destination: "600-8216",
      weight: 500,
      dimensions: "60",
      service: "standard",
      insurance: false,
    });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.fee).toBe(1200);
  });

  it("東京→札幌のお急ぎ便の配送料を返す", async () => {
    const res = await 見積もりを取得する({
      origin: "100-0001",
      destination: "060-0001",
      weight: 1200,
      dimensions: "80",
      service: "express",
      insurance: true,
    });
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.fee).toBe(1800);
  });
});
