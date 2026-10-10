import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("RateLimit binding applies the configured local limit", async () => {
  await withExample(
    "RateLimitExample",
    { RATE: { type: "rate-limit", namespace: "example", simple: { limit: 1, period: 60 } } },
    async (fetch) => {
      const response = await fetch("/limit");
      assert.equal(await response.text(), "allowed,limited");
    },
  );
});
