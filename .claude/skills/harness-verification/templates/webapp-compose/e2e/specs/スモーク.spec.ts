import { expect, test } from "@playwright/test";

test("トップページを開くと見出しが表示される", async ({ page }) => {
  await page.goto("/");
  await expect(
    page.getByRole("heading", { name: "動作確認用アプリ" }),
  ).toBeVisible();
});
