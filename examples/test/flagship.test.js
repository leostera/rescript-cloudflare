import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Flagship locally evaluates a seeded flag", async () => {
  const workerSource = `
    import * as example from "./src/FlagshipExample.res.js";

    export default {
      async fetch(request, env) {
        const admin = env.FLAG["FlagshipBinding::admin_api"]();
        await admin.putFlag({
          key: "feature_enabled",
          enabled: true,
          default_variation: "on",
          variations: { on: true, off: false },
          rules: [],
        });
        return example.fetch(request, env);
      },
    };
  `;

  await withExample(
    "FlagshipExample",
    { FLAG: { type: "flagship", id: "local-flagship", dev: { remote: false } } },
    async (fetch) => {
      const response = await fetch("/flag");
      assert.equal(await response.text(), "enabled");
    },
    { workerSource },
  );
});
