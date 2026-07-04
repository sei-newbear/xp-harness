import { defineConfig } from "@playwright/test";

// E2E は docker-compose で起動したフルスタック (db + api + front) に対して実行する。
// スタックの起動は `npm run e2e` (run-e2e.sh) が行う。webServer 設定は使わない。
export default defineConfig({
  testDir: "./specs",
  workers: 1,
  fullyParallel: false,
  use: {
    baseURL: "http://localhost:5173",
    trace: "retain-on-failure",
  },
});
