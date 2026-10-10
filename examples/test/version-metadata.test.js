import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Version metadata is available in the local Worker environment", async () => {
  await withExample(
    "VersionMetadataExample",
    { VERSION: { type: "version-metadata" } },
    async (fetch) => {
      const response = await fetch("/version");
      const [id, timestamp] = (await response.text()).split("|");
      assert.match(id, /^[a-f0-9-]{36}$/i);
      assert.ok(Number.isFinite(Date.parse(timestamp)));
    },
  );
});
