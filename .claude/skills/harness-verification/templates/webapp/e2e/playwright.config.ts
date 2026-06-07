import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./specs",
  workers: 1,
  fullyParallel: false,
  use: {
    baseURL: "http://localhost:5173",
  },
  webServer: [
    {
      command: "npm run dev --prefix ../api",
      port: 3001,
      reuseExistingServer: true,
    },
    {
      command: "npm run dev --prefix ../front",
      port: 5173,
      reuseExistingServer: true,
    },
  ],
});
