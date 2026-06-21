// 外部 配送料 API (shipping-rate-api) のクライアント。
// 仕様: api/docs/external-shipping-api.md

const BASE_URL =
  process.env.SHIPPING_API_BASE_URL ?? "https://shipping-rate.example.com";

export type ShippingQuoteInput = {
  origin: string;
  destination: string;
  weight: number;
  dimensions: string;
  service: string;
  insurance: boolean;
};

export type ShippingQuoteResult = {
  fee: number;
  currency: string;
};

export async function quoteShipping(
  input: ShippingQuoteInput,
): Promise<ShippingQuoteResult> {
  const res = await fetch(`${BASE_URL}/v1/quote`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      origin: input.origin,
      destination: input.destination,
      weight: input.weight,
      dimensions: input.dimensions,
      service: input.service,
      insurance: input.insurance,
    }),
  });
  if (!res.ok) {
    throw new Error(`shipping-rate-api error: ${res.status}`);
  }
  return (await res.json()) as ShippingQuoteResult;
}
