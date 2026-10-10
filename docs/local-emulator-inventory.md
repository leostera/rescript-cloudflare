# Cloudflare local-emulator inventory and coverage

**Status:** verified against the checked-in toolchain and the local Miniflare runtime. This is an emulator capability inventory, not a statement of Cloudflare production parity.

## Method and evidence

The project was created without an application toolchain, then pinned to:

- Wrangler `4.149.0` (root `package-lock.json`); its dependency resolves Miniflare `5.20261006.1-alpha` and workerd `1.20261006.1`.
- ReScript `12.3.1`; `@cloudflare/workers-types` `5.20261010.1` was used as a signature reference, not as proof of local runtime support.
- Node `v24.14.1` in the verification environment (the project declares Node `>=22`).

The inventory started from Wrangler's installed `node_modules/wrangler/config-schema.json`, Miniflare's installed `node_modules/miniflare/dist/src/index.d.ts` (`PLUGINS` and binding schemas), and the plugin implementations in `node_modules/miniflare/dist/src/index.js` plus embedded worker modules. Plugin registration/config schema alone was treated as a candidate, never as proof. Candidate operations were then exercised through `new Miniflare()` and local-only bindings. The integration harness is `examples/test/miniflare.js`; Miniflare tests use local `dispatchFetch`, while the legacy Workers Sites case starts the pinned Wrangler CLI with `dev --local` against loopback. No Cloudflare account, remote binding, deployment, or remote resource is used. A clean temporary copy installed successfully with `npm ci --offline --ignore-scripts` and built successfully. In the working tree, `npm run check` ran the ReScript build and full local integration suite: **23/23 tests passed**.

For adapter availability checks, local executable/image inspection found no PostgreSQL or MySQL server/client and no locally cached PostgreSQL/MySQL Docker image. Docker's active context pointed at the local OrbStack Unix socket; no image pull was requested. A container-attached Durable Object smoke probe against that local socket failed with a generic workerd 500 even when the handler returned a constant, so container support is not counted as verified.

### Classification

- **Verified local** means an integration test passed against the pinned Miniflare implementation.
- **Partially verified** means a useful subset passed; limitations are explicit.
- **Local adapter unavailable** means Miniflare has a local adapter/configuration path, but a needed host-local dependency was absent or the local probe failed.
- **Remote proxy only / forbidden** means the pinned plugin wires a remote proxy and no strictly local backend was established. These bindings were not invoked.
- **Infrastructure-only** means a helper plugin is not a user-facing Cloudflare product API.

## Verified local coverage

| Capability | ReScript package / example | Test | Verified operations and limits |
|---|---|---|---|
| Workers core runtime and scheduled events | `Web`, `Async` / `WorkerCoreExample`, `ScheduledExample` | `storage.test.js`, `scheduled.test.js` | Local module worker, fetch routing, request method/body and response; scheduled handler invocation through Miniflare's test-only `/cdn-cgi/local/scheduled` endpoint with `unsafeTriggerHandlers`. Production scheduling/networking are not claimed. |
| Static assets binding | `Assets` / `AssetsExample` | `assets.test.js` | `ASSETS.fetch` serves a local fixture, while the Worker handles an API route. Asset deployment/CDN behavior is outside the emulator test. |
| Legacy Workers Sites | `KV`, `Web` / `LegacySitesExample` | `legacy-sites.test.js` | Wrangler `dev --local` injects the legacy `__STATIC_CONTENT` namespace and manifest into a classic Worker; the ReScript handler reads and serves the local fixture. Does not claim module-Worker or deployment parity. |
| Worker service binding | `ServiceBinding` / `ServiceBindingExample` | `service-bindings.test.js` | Fetch through a binding to a second locally configured Worker. No account-managed dispatch namespace. |
| Worker Loader | `WorkerLoader` / `WorkerLoaderExample` | `worker-loader.test.js` | Load an in-memory module and fetch its default entrypoint. Code is supplied locally; sandbox/security characteristics are not assessed. |
| Version metadata | `VersionMetadata` / `VersionMetadataExample` | `version-metadata.test.js` | Read and validate the local ID and timestamp. Local values are emulator metadata, not deployed-version identity. |
| Cache API | `Cache` / `CacheExample` | `storage.test.js` | Cache-aside `match`/`put` and `delete`, including `Cache-Control` needed by this emulator/runtime. Other cache semantics are not exhaustively tested. |
| Workers KV | `KV` / `KVExample` | `storage.test.js` | `get`, `put`, prefix `list`, and `delete` in a local namespace. The API exposes metadata/options too; those paths are not exercised here. |
| D1 | `D1` / `D1Example` | `storage.test.js` | `prepare`, bound insert, `run`, `first`, count, and delete against local SQLite-backed D1. Batch/raw/constraint parity is not claimed. |
| R2 | `R2` / `R2Example` | `storage.test.js` | `put`, body `get`, `head`, prefix `list`, and `delete`. Multipart, range, S3, and all metadata variants remain untested. |
| Durable Objects | `DurableObjects` / `CounterLogic` | `durable-objects.test.js` | Local namespace/stub fetch, persistent SQLite-backed storage `get`/`put` across requests, and a scheduled alarm that updates persisted state. WebSockets, transaction edge cases, and eviction are not covered. |
| Queues | `Queues` / `QueueExample` | `queues.test.js` | Send a message, local consumer batch delivery, state update, and acknowledgement. Retry/dead-letter, batching limits, and delivery guarantees are not inferred. |
| Workflows | `Workflows` / `WorkflowExample` | `workflows.test.js` | Create/run a local workflow instance, persist a step, and inspect the result/status. Retry, event, retention, and scale behavior are not assessed. |
| Rate limiting | `RateLimit` / `RateLimitExample` | `rate-limit.test.js` | Local namespace limit behavior across successive requests. Distributed production enforcement is not represented. |
| Pipelines | `Pipelines` / `PipelineExample` | `data-services.test.js` | Send a local record batch; Miniflare accepts it. No production sink/durable delivery guarantee or read-back surface is claimed. |
| Analytics Engine dataset | `AnalyticsEngine` / `AnalyticsExample` | `data-services.test.js` | `writeDataPoint` succeeds against the local simulator. Querying/retention/aggregation is not implemented or tested by this example. |
| Secrets Store | `SecretsStore` / `SecretsStoreExample` | `secrets-store.test.js` | Read a locally seeded secret. Test harness seeds it through Miniflare's internal `SecretsStoreSecret::admin_api`; this is emulator test setup, not a public Worker/product API. No real secrets are used. |
| Email Sending | `Email` / `EmailExample` | `email.test.js` | Accept and capture a syntactically valid email locally with test-only allowlists. No SMTP delivery or recipient contact occurs. |
| Flagship | `Flagship` / `FlagshipExample` | `flagship.test.js` | Evaluate a boolean flag locally. The harness seeds the definition through Miniflare's internal `FlagshipBinding::admin_api`; it is not an application/admin API recommendation. |
| Images | `Images` / `ImagesExample` | `images.test.js` | Local image `info`, resize/output transform, hosted-image upload/list/details/delete, and direct-upload link completion using a valid one-pixel PNG. Transforming uses Miniflare's local Sharp backend; this does not prove hosted Images service parity. Other transform formats are not covered. |
| Stream | `Stream` / `StreamExample` | `stream.test.js` | Local upload from a self-contained data URL, list, details, and delete metadata operations. The local service accepts dummy MP4 bytes; it does not exercise playback/transcoding. `createDirectUpload()` was separately probed and throws `BadRequestError: createDirectUpload is not supported in local mode`. |
| Browser Rendering | `BrowserRendering` / `BrowserExample` | `browser.test.js` | Launch local Puppeteer/browser, render a `data:` HTML document, read its title, and close. No hosted browser or external page is contacted. |

The 23 passing test cases correspond to these rows; the shared `storage.test.js` contains separate core, KV, D1, R2, and Cache tests. The scheduled trigger endpoint is a Miniflare-local test hook, not an application route or public Cloudflare API.

## Excluded, unavailable, or only partially verified

| Capability | Classification | Evidence / reason and scope decision |
|---|---|---|
| Workers AI | Remote proxy only / forbidden | Miniflare's pinned `AI` plugin wires a `remoteProxyClientWorker()` service; no offline inference backend was established. `AI.res` is an unverified FFI declaration, not counted coverage. |
| Agent Memory | Remote proxy only / forbidden | Plugin implementation wires only its remote proxy. No local store/evaluation was invoked. |
| AI Search and namespaces | Remote proxy only / forbidden | Plugin implementation wires the remote proxy for both binding types. No Cloudflare resource was accessed. |
| Vectorize | Remote proxy only / forbidden | Plugin wraps the Vectorize API around its remote-proxy fetcher; no local vector index implementation was established. |
| Artifacts | Remote proxy only / forbidden | Plugin binding delegates to its remote proxy. Not invoked. |
| Dispatch Namespace / Workers for Platforms | Remote proxy only / forbidden | Local-dispatch wrapper still delegates dispatch to the remote-proxy service. Ordinary local Worker-to-Worker service bindings are separately verified above. |
| Analytics SQL | Remote proxy only / forbidden | The `analytics` binding uses a remote-proxy service. Only local Analytics Engine writes are covered. |
| Media | Remote proxy only / forbidden | Miniflare's Media plugin creates a remote-proxy binding; no local transformation backend was established. |
| mTLS certificate binding | Remote proxy only / forbidden | Plugin creates the remote proxy service for certificates. No local certificate binding was established. |
| VPC network/service | Remote proxy only / forbidden | The pinned plugin implementation maps these bindings to remote proxies; no private/local network endpoint was bound. |
| K2 streams | Remote-only / forbidden | Wrangler's schema/config behavior identifies K2 as using the real stream in development; it was not configured or invoked. |
| Hyperdrive | Local adapter unavailable in this environment | Miniflare expects a local PostgreSQL/MySQL connection string. No local server/client or cached DB image was available. No DB image was pulled and no remote URL was used. The binding declaration is unverified and no example is counted. |
| Container-attached Durable Objects | Local runtime probe failed | Local Docker/OrbStack and a cached Ubuntu image were present, but the pinned Miniflare/workerd probe returned a generic 500 even for a trivial DO handler with container config. No passing ReScript example exists; excluded pending an actionable local runtime result. |
| Stream direct uploads | Unsupported by local implementation | Explicit local probe returned `BadRequestError: createDirectUpload is not supported in local mode`; do not count it as local coverage. |
| Hello World service | Infrastructure-only | Miniflare test helper, not a Cloudflare product service; excluded from service coverage. |
| Legacy Workers Sites module format | Partial support | Wrangler's pinned schema still includes legacy `site.bucket`. The test confirms the classic service-worker format exposes the global manifest and KV namespace locally; a module Worker configured with the same `site.bucket` returned `undefined` for both globals and `env` bindings. The pinned Miniflare v5 constructor also rejects old `sitePath`/`legacy.sitePath` configuration directly; use Wrangler's local CLI for this legacy path. |

No mock or test-only local service is counted as the Cloudflare product itself. In particular, direct local Worker service bindings, internal setup APIs for Flagship/Secrets Store, Analytics Engine's simulator, and the Stream metadata simulation are identified separately from their production counterparts.

## Binding package status and interop gaps

`packages/cloudflare` is a ReScript-source npm workspace shaped for consumption; it is not published. Modules with rows in the verified table have passing example calls. The other FFI modules (`AI`, `AgentMemory`, `AISearch`, `Artifacts`, `Dispatch`, `Hyperdrive`, `Media`, `MTLS`, `VPC`, `Vectorize`, and other unexercised methods) are draft declarations only: `rescript build` verifies ReScript syntax/types within this source package, not Cloudflare runtime signatures. `@cloudflare/workers-types` was a reference, not a generated/checked binding source. Dynamic SDK shapes are represented as abstract values or `JSON.t`; nullability is explicitly represented with `Nullable.t` in exercised wrappers. Treat every untested signature as experimental.

The tested examples establish practical API slices, not complete SDK coverage. Specific untested slices include D1 batches/raw results, KV/R2 option metadata, Durable Object WebSockets/transaction edge cases, Queue retry policies, Workflow retries/events, Analytics Engine reads, advanced image transform options, and Stream playback/transcoding. These are disclosed rather than silently implied to work.

## Reproduction

```sh
npm ci
npm run build
npm run test:local
# or: npm run check
```

These commands use only the repository's pinned local dependencies, Miniflare, and Wrangler's `--local` mode. No publish, deploy, account login, Cloudflare remote binding, or remote resource operation is part of the workflow.
