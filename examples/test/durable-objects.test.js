import assert from "node:assert/strict";
import test from "node:test";
import { setTimeout as delay } from "node:timers/promises";
import { withExample } from "./miniflare.js";

test("Durable Object stub routes to persistent ReScript-backed storage", async () => {
  const workerSource = `
    import { DurableObject } from "cloudflare:workers";
    import * as counter from "./src/CounterLogic.res.js";

    export class Counter extends DurableObject {
      fetch(request) {
        if (request.url.includes("/alarm")) {
          return counter.scheduleAlarm(this.ctx.storage).then(() => new Response("scheduled"));
        }
        if (request.url.includes("/current")) {
          return counter.current(this.ctx.storage).then((value) => new Response(value));
        }
        return counter.next(this.ctx.storage).then((value) => new Response(String(value)));
      }

      alarm() {
        return counter.next(this.ctx.storage).then(() => {});
      }
    }

    export default {
      fetch(request, env) {
        return env.COUNTER.getByName("room-a").fetch(request);
      },
    };
  `;

  await withExample(
    "CounterLogic",
    { COUNTER: { type: "durable-object", worker: "example-counterlogic", exportName: "Counter" } },
    async (fetch) => {
      assert.equal(await (await fetch("/count")).text(), "1");
      assert.equal(await (await fetch("/count")).text(), "2");
      assert.equal(await (await fetch("/alarm")).text(), "scheduled");

      let alarmValue = "";
      for (let attempt = 0; attempt < 50; attempt++) {
        alarmValue = await (await fetch("/current")).text();
        if (alarmValue === "3") break;
        await delay(20);
      }
      assert.equal(alarmValue, "3", "Durable Object alarm should update persisted state");
    },
    {
      exports: { Counter: { type: "durable-object", storage: "sqlite" } },
      workerSource,
    },
  );
});
