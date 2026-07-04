import { serve } from "@hono/node-server";
import { Hono } from "hono";

const app = new Hono();

app.get("/health", (c) => c.json({ ok: true }));

serve({ fetch: app.fetch, port: 3001, hostname: "0.0.0.0" }, (info) => {
  console.log(`sandbox-api listening on http://0.0.0.0:${info.port}`);
});
