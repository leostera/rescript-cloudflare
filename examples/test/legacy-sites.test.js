import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { mkdtemp, mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { once } from "node:events";
import { tmpdir } from "node:os";
import path from "node:path";
import { setTimeout as delay } from "node:timers/promises";
import { fileURLToPath } from "node:url";
import net from "node:net";
import test from "node:test";
import { build } from "esbuild";

const repositoryRoot = fileURLToPath(new URL("../../", import.meta.url));
const examplePath = new URL("../src/LegacySitesExample.res.js", import.meta.url);
const assetFixturePath = new URL("./fixtures/assets/index.html", import.meta.url);

async function unusedLocalPort() {
  return new Promise((resolve, reject) => {
    const server = net.createServer();
    server.once("error", reject);
    server.listen(0, "127.0.0.1", () => {
      const { port } = server.address();
      server.close(() => resolve(port));
    });
  });
}

test("Wrangler local Workers Sites exposes its manifest and KV asset namespace to ReScript", async () => {
  const directory = await mkdtemp(path.join(tmpdir(), "reworked-wrangler-sites-"));
  const port = await unusedLocalPort();
  const bundle = await build({
    entryPoints: [examplePath.pathname],
    bundle: true,
    format: "iife",
    globalName: "LegacySitesExample",
    platform: "neutral",
    target: "es2022",
    write: false,
  });
  const workerScript = `${bundle.outputFiles[0].text}\naddEventListener("fetch", event => event.respondWith(LegacySitesExample.fetch(event.request)));`;
  const configPath = path.join(directory, "wrangler.jsonc");
  const scriptPath = path.join(directory, "worker.js");
  const publicDirectory = path.join(directory, "public");
  await mkdir(publicDirectory);
  await writeFile(path.join(publicDirectory, "index.html"), await readFile(assetFixturePath));
  await writeFile(scriptPath, workerScript);
  await writeFile(configPath, JSON.stringify({
    name: "reworked-local-workers-sites",
    compatibility_date: "2026-10-10",
    site: { bucket: "./public" },
  }));

  const wrangler = spawn(
    path.join(repositoryRoot, "node_modules/.bin/wrangler"),
    [
      "dev", "worker.js", "--local", "--port", String(port), "--ip", "127.0.0.1",
      "--config", configPath, "--show-interactive-dev-session=false", "--log-level", "error",
    ],
    {
      cwd: directory,
      env: { ...process.env, WRANGLER_SEND_METRICS: "false", NO_COLOR: "1" },
      stdio: ["ignore", "pipe", "pipe"],
    },
  );
  let logs = "";
  for (const stream of [wrangler.stdout, wrangler.stderr]) {
    stream.on("data", (chunk) => { logs += chunk.toString(); });
  }

  try {
    let response;
    for (let attempt = 0; attempt < 100; attempt++) {
      if (wrangler.exitCode !== null) throw new Error(`Wrangler exited ${wrangler.exitCode}: ${logs}`);
      try {
        response = await fetch(`http://127.0.0.1:${port}/`);
        break;
      } catch {
        await delay(50);
      }
    }
    assert.ok(response, `Wrangler did not start locally: ${logs}`);
    const body = await response.text();
    assert.equal(response.status, 200, `${body}\n${logs}`);
    assert.match(body, /local static asset/);
    const missing = await fetch(`http://127.0.0.1:${port}/not-found`);
    assert.equal(missing.status, 404);
  } finally {
    wrangler.kill("SIGTERM");
    await Promise.race([once(wrangler, "close"), delay(3000)]);
    await rm(directory, { recursive: true, force: true });
  }
});
