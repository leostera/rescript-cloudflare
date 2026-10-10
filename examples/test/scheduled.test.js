import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Scheduled handler runs through Miniflare's local trigger endpoint", async () => {
  const workerSource = `
    import * as example from "./src/ScheduledExample.res.js";
    export default { fetch: example.fetch, scheduled: example.scheduled };
  `;

  await withExample(
    "ScheduledExample",
    { KV: { type: "kv", id: "scheduled-status" } },
    async (fetch) => {
      const trigger = await fetch("/cdn-cgi/local/scheduled?format=json&time=1791690000000");
      assert.equal(trigger.status, 200, await trigger.clone().text());
      assert.equal(JSON.parse(await trigger.text()).outcome, "ok");
      assert.equal(await (await fetch("/state")).text(), "cron ran locally");
    },
    {
      triggers: [{ type: "scheduled", schedule: "*/5 * * * *" }],
      workerSource,
      unsafeTriggerHandlers: true,
    },
  );
});
