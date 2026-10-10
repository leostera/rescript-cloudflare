import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Secrets Store binding reads a locally seeded test value", async () => {
  const workerSource = `
    import * as example from "./src/SecretsStoreExample.res.js";

    export default {
      async fetch(request, env) {
        await env.SECRET["SecretsStoreSecret::admin_api"]().create("local-test-only");
        return example.fetch(request, env);
      },
    };
  `;

  await withExample(
    "SecretsStoreExample",
    { SECRET: { type: "secrets-store-secret", storeId: "local-store", secretName: "test-secret" } },
    async (fetch) => {
      const response = await fetch("/secret");
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "local-test-only");
    },
    { workerSource },
  );
});
