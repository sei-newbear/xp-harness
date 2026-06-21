import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globalSetup: ["./test/global-setup.ts"],
    include: ["test/**/*.e2e.test.ts"],
    env: {
      SHIPPING_API_BASE_URL: "http://localhost:18080",
    },
    testTimeout: 20000,
    hookTimeout: 70000,
  },
});
