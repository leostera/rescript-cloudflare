import assert from "node:assert/strict";
import test from "node:test";
import { readFile } from "node:fs/promises";
import { withExample } from "./miniflare.js";

test("Images binding transforms and manages hosted images locally", async () => {
  const onePixelPng = await readFile(new URL("./fixtures/one-pixel.png", import.meta.url));

  await withExample(
    "ImagesExample",
    { IMAGES: { type: "images", dev: { remote: false } } },
    async (fetch) => {
      const response = await fetch("/image", { method: "POST", body: onePixelPng });
      assert.equal(response.status, 200);
      assert.equal(await response.text(), "1x1 image/png");

      const transformed = await fetch("/transform", { method: "POST", body: onePixelPng });
      assert.equal(transformed.status, 200, await transformed.clone().text());
      assert.equal(await transformed.text(), "image/png");

      const upload = await fetch("/hosted/upload", { method: "POST", body: onePixelPng });
      assert.equal(await upload.text(), "local-rescript-image");
      assert.equal(await (await fetch("/hosted/details")).text(), "present");
      assert.equal(await (await fetch("/hosted/list")).text(), "1");
      assert.equal(await (await fetch("/hosted/image", { method: "DELETE" })).text(), "deleted");
      assert.equal(await (await fetch("/hosted/list")).text(), "0");

      const direct = await fetch("/hosted/direct", { method: "POST" });
      const [directId, directUploadUrl] = (await direct.text()).split("\n");
      assert.equal(directId, "local-direct-image");
      const uploadUrl = new URL(directUploadUrl);
      const boundary = "----rescript-local-image-upload";
      const body = Buffer.concat([
        Buffer.from(`--${boundary}\r\nContent-Disposition: form-data; name="file"; filename="direct.png"\r\nContent-Type: image/png\r\n\r\n`),
        onePixelPng,
        Buffer.from(`\r\n--${boundary}--\r\n`),
      ]);
      const completed = await fetch(uploadUrl.pathname + uploadUrl.search, {
        method: "POST",
        headers: { "content-type": `multipart/form-data; boundary=${boundary}` },
        body,
      });
      assert.equal(completed.status, 200, await completed.clone().text());
      assert.equal(await (await fetch("/hosted/direct/details")).text(), "present");
      assert.equal(await (await fetch("/hosted/direct-image", { method: "DELETE" })).text(), "deleted");
    },
  );
});
