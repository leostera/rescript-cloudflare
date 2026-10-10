import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Workflow binding runs a locally persisted step and returns its output", async () => {
  const workerSource = `
    import { WorkflowEntrypoint } from "cloudflare:workers";
    import * as workflow from "./src/WorkflowExample.res.js";

    export class ExampleWorkflow extends WorkflowEntrypoint {
      async run(event, step) {
        return step.do("process", async () => workflow.processPayload(event.payload));
      }
    }

    export default {
      async fetch(_request, env) {
        return Response.json({ summary: await workflow.describe(env.WORKFLOW) });
      },
    };
  `;

  await withExample(
    "WorkflowExample",
    { WORKFLOW: { type: "workflow", name: "example-workflow", worker: "example-workflowexample", exportName: "ExampleWorkflow" } },
    async (fetch) => {
      const response = await fetch("/workflow", { method: "POST" });
      const body = await response.text();
      assert.equal(response.status, 200, body);
      const result = JSON.parse(body);
      assert.equal(result.summary, "example-workflow|complete|order-42 processed by ReScript");
    },
    {
      exports: { ExampleWorkflow: { type: "workflow", name: "example-workflow" } },
      workerSource,
    },
  );
});
