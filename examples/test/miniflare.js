import { readFile } from "node:fs/promises";
import { Miniflare } from "miniflare";
import { build } from "esbuild";
import { builtinModules } from "node:module";

const exampleSourcePath = new URL("../src/", import.meta.url);

export async function withExample(
  moduleName,
  bindings,
  run,
  {
    triggers,
    exports,
    workerSource: customWorkerSource,
    extraModules = {},
    compatibilityFlags = ["nodejs_compat"],
    assets,
    additionalWorkers = [],
    unsafeTriggerHandlers = false,
  } = {},
) {
  const examplePath = new URL(`${moduleName}.res.js`, exampleSourcePath);
  let compiledExample = await readFile(examplePath, "utf8");
  if (moduleName === "BrowserExample" || moduleName === "StreamExample") {
    const bundle = await build({
      entryPoints: [examplePath.pathname],
      bundle: true,
      format: "esm",
      platform: "neutral",
      mainFields: ["module", "main"],
      target: "es2022",
      external: builtinModules.flatMap((name) => [name, `node:${name}`]),
      write: false,
    });
    compiledExample = bundle.outputFiles[0].text;
  }
  const workerSource = customWorkerSource ?? `
    import * as example from "./src/${moduleName}.res.js";
    export default { fetch: example.fetch, queue: example.queue };
  `;
  const modules = {
    "worker.js": { type: "esm", contents: workerSource },
    [`src/${moduleName}.res.js`]: { type: "esm", contents: compiledExample },
    ...Object.fromEntries(
      Object.entries(extraModules).map(([name, contents]) => [name, { type: "esm", contents }]),
    ),
  };
  const miniflare = new Miniflare({
    telemetry: { enabled: false },
    unsafeTriggerHandlers,
    workers: [
      {
        config: {
          name: `example-${moduleName.toLowerCase()}`,
          compatibilityDate: "2026-10-10",
          compatibilityFlags,
          ...(triggers ? { triggers } : {}),
          ...(exports ? { exports } : {}),
          ...(assets ? { assets } : {}),
          manifest: { mainModule: "worker.js", modules },
          env: bindings,
        },
      },
      ...additionalWorkers.map((config) => ({ config })),
    ],
  });

  try {
    await run((path, init) => miniflare.dispatchFetch(`http://local${path}`, init));
  } finally {
    await miniflare.dispose();
  }
}
