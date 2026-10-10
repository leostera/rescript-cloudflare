import assert from "node:assert/strict";
import test from "node:test";
import { fileURLToPath } from "node:url";
import { withExample } from "./miniflare.js";

const assetsDirectory = fileURLToPath(new URL("./fixtures/assets", import.meta.url));

test("Assets binding serves a local file while the Worker owns API routes", async () => {
  await withExample(
    "AssetsExample",
    { ASSETS: { type: "assets" } },
    async (fetch) => {
      const asset = await fetch("/");
      assert.equal(asset.status, 200);
      assert.match(await asset.text(), /local static asset/);

      const api = await fetch("/api/health");
      assert.equal(await api.text(), "ReScript Worker API");
    },
    { assets: { directory: assetsDirectory, hasUserWorker: true } },
  );
});
