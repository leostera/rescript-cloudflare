import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Workers core example routes health checks", async () => {
  await withExample("WorkerCoreExample", {}, async (fetch) => {
    const response = await fetch("/health");
    assert.equal(response.status, 200);
    assert.equal(await response.text(), "ok");
  });
});

test("KV example writes and reads a namespaced value", async () => {
  await withExample("KVExample", { KV: { type: "kv", id: "example-kv" } }, async (fetch) => {
    const write = await fetch("/kv", { method: "POST", body: "hello from KV" });
    assert.equal(await write.text(), "stored");

    const read = await fetch("/kv");
    assert.equal(await read.text(), "hello from KV");

    const listedBeforeDelete = await fetch("/keys");
    assert.equal(await listedBeforeDelete.text(), "1");

    const remove = await fetch("/kv", { method: "DELETE" });
    assert.equal(await remove.text(), "deleted");

    const listedAfterDelete = await fetch("/keys");
    assert.equal(await listedAfterDelete.text(), "0");
  });
});

test("D1 example creates a table, inserts a note, and counts rows", async () => {
  await withExample(
    "D1Example",
    { DB: { type: "d1", name: "example-d1", id: "example-d1" } },
    async (fetch) => {
      const firstWrite = await fetch("/notes", { method: "POST", body: "first note" });
      assert.equal(await firstWrite.text(), "saved");
      const secondWrite = await fetch("/notes", { method: "POST", body: "second note" });
      assert.equal(await secondWrite.text(), "saved");

      const read = await fetch("/notes");
      assert.equal(await read.text(), "2");

      const clear = await fetch("/notes", { method: "DELETE" });
      assert.equal(await clear.text(), "cleared");
      assert.equal(await (await fetch("/notes")).text(), "0");
    },
  );
});

test("R2 example stores and reads an object body", async () => {
  await withExample(
    "R2Example",
    { BUCKET: { type: "r2", name: "example-bucket" } },
    async (fetch) => {
      const write = await fetch("/objects", { method: "POST", body: "stored in R2" });
      assert.equal(await write.text(), "stored");

      const read = await fetch("/objects");
      assert.equal(await read.text(), "stored in R2");

      assert.equal(await (await fetch("/head")).text(), "present");
      assert.equal(await (await fetch("/list")).text(), "1");
      assert.equal(await (await fetch("/objects", { method: "DELETE" })).text(), "deleted");
      assert.equal(await (await fetch("/list")).text(), "0");
    },
  );
});

test("Cache API example caches the response for the request", async () => {
  await withExample("CacheExample", {}, async (fetch) => {
    const first = await fetch("/cache-me");
    assert.equal(await first.text(), "origin response");

    const second = await fetch("/cache-me");
    assert.equal(await second.text(), "cached response");

    assert.equal(await (await fetch("/cache-me", { method: "DELETE" })).text(), "deleted");
    assert.equal(await (await fetch("/cache-me", { method: "DELETE" })).text(), "missing");
    assert.equal(await (await fetch("/cache-me")).text(), "origin response");
  });
});
