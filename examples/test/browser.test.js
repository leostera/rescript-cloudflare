import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Browser Rendering launches a local browser for a data URL", async () => {
  await withExample(
    "BrowserExample",
    { BROWSER: { type: "browser", dev: { remote: false } } },
    async (fetch) => {
      const response = await fetch("/render");
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "local-browser");
    },
    { compatibilityFlags: ["nodejs_compat", "no_websocket_standard_binary_type"] },
  );
});
