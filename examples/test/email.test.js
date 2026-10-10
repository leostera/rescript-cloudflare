import assert from "node:assert/strict";
import test from "node:test";
import { withExample } from "./miniflare.js";

test("Email binding accepts a message into the local emulator only", async () => {
  await withExample(
    "EmailExample",
    {
      EMAIL: {
        type: "send-email",
        dev: { remote: false },
        allowedSenderAddresses: ["sender@example.test"],
        allowedDestinationAddresses: ["recipient@example.test"],
      },
    },
    async (fetch) => {
      const response = await fetch("/email");
      const body = await response.text();
      assert.equal(response.status, 200, body);
      assert.ok(body.length > 0);
    },
  );
});
