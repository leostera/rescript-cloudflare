import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Pipelines locally accepts a record batch", async () => {
  await withExample(
    "PipelineExample",
    { EVENTS: { type: "pipeline", name: "example-pipeline" } },
    async (fetch) => {
      const response = await fetch("/events", { method: "POST" });
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "pipeline accepted event locally");
    },
  );
});

test("Analytics Engine locally accepts a data point", async () => {
  await withExample(
    "AnalyticsExample",
    { EVENTS: { type: "analytics-engine-dataset", name: "example-events" } },
    async (fetch) => {
      const response = await fetch("/events", { method: "POST" });
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "analytics point accepted locally");
    },
  );
});
