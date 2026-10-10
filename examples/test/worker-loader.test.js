import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Worker Loader executes a locally supplied module", async () => {
  await withExample(
    "WorkerLoaderExample",
    { LOADER: { type: "worker-loader" } },
    async (fetch) => {
      const response = await fetch("/dynamic");
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "loaded locally");
    },
  );
});
