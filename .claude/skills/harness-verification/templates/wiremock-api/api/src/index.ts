import { serve } from "@hono/node-server";
import { app } from "./app.js";

serve({ fetch: app.fetch, port: 3001 }, (info) => {
  console.log(`sandbox-api listening on http://localhost:${info.port}`);
});
