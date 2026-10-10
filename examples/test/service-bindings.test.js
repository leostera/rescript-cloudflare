import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Service bindings call another local Worker", async () => {
  const targetWorker = {
    name: "local-target",
    compatibilityDate: "2026-10-10",
    manifest: {
      mainModule: "target.js",
      modules: {
        "target.js": {
          type: "esm",
          contents: `export default { fetch(request) { return new Response("target:" + new URL(request.url).pathname) } }`,
        },
      },
    },
    env: {},
  };

  await withExample(
    "ServiceBindingExample",
    { SERVICE: { type: "worker", worker: "local-target" } },
    async (fetch) => {
      const response = await fetch("/api/items");
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "target:/api/items");
    },
    { additionalWorkers: [targetWorker] },
  );
});
