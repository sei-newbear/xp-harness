import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// api への proxy 先は docker-compose のサービス名 (api)。
// ローカル (compose 外) で動かす場合は API_PROXY_TARGET で上書きできる。
const apiTarget = process.env.API_PROXY_TARGET ?? "http://api:3001";

export default defineConfig({
  plugins: [react()],
  server: {
    host: "0.0.0.0",
    port: 5173,
    proxy: {
      "/api": {
        target: apiTarget,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ""),
      },
    },
  },
});
