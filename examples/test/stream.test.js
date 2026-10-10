import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Stream locally uploads metadata, lists, retrieves, and deletes a video", async () => {
  await withExample(
    "StreamExample",
    { STREAM: { type: "stream", dev: { remote: false } } },
    async (fetch) => {
      const upload = await fetch("/videos", { method: "POST" });
      assert.equal(upload.status, 200);
      assert.ok((await upload.text()).length > 0);
      assert.equal(await (await fetch("/videos/details")).text(), "present");
      assert.equal(await (await fetch("/videos")).text(), "1");
      assert.equal(await (await fetch("/videos", { method: "DELETE" })).text(), "deleted");
      assert.equal(await (await fetch("/videos")).text(), "0");
    },
  );
});
