import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const NAME = "sandbox-wiremock";
const PORT = 18080;
const __dirname = dirname(fileURLToPath(import.meta.url));

export async function setup() {
  spawnSync("docker", ["rm", "-f", NAME], { stdio: "ignore" });
  const mappings = resolve(__dirname, "../wiremock/mappings");
  const r = spawnSync(
    "docker",
    [
      "run",
      "-d",
      "--name",
      NAME,
      "-p",
      `${PORT}:8080`,
      "-v",
      `${mappings}:/home/wiremock/mappings`,
      "wiremock/wiremock:latest",
    ],
    { stdio: "inherit" },
  );
  if (r.status !== 0) throw new Error("WireMock コンテナの起動に失敗しました");

  const deadline = Date.now() + 60000;
  while (Date.now() < deadline) {
    try {
      const res = await fetch(`http://localhost:${PORT}/__admin/mappings`);
      if (res.ok) return;
    } catch {
      // まだ起動中
    }
    await new Promise((r) => setTimeout(r, 500));
  }
  throw new Error("WireMock が時間内に ready になりませんでした");
}

export async function teardown() {
  spawnSync("docker", ["rm", "-f", NAME], { stdio: "ignore" });
}
