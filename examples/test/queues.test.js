import assert from "node:assert/strict";
import test from "node:test";
import { setTimeout as delay } from "node:timers/promises";
import { withExample } from "./miniflare.js";

test("Queue producer dispatches a local consumer and acknowledges messages", async () => {
  await withExample(
    "QueueExample",
    {
      JOBS: { type: "queue", name: "example-jobs" },
      KV: { type: "kv", id: "queue-status" },
    },
    async (fetch) => {
      const queued = await fetch("/jobs", { method: "POST" });
      assert.equal(await queued.text(), "queued");

      await delay(150);
      const status = await fetch("/jobs");
      assert.equal(await status.text(), "processed");
    },
    { triggers: [{ type: "queue", name: "example-jobs", maxBatchTimeout: 0 }] },
  );
});
