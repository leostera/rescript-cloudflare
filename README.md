# Reworked Cloudflare + ReScript

An inventory-led investigation into Cloudflare Workers capabilities that the pinned Wrangler/Miniflare toolchain can exercise locally. This is an experimental monorepo; local emulator behavior is not a guarantee of production parity.

## Requirements and local checks

- Node.js `>=22` and npm
- Pinned Wrangler `4.149.0`, Miniflare `5.20261006.1-alpha`, ReScript `12.3.1`

```sh
npm ci
npm run build
npm run test:local
# combined build and integration check
npm run check
```

The integration tests run Miniflare and the pinned Wrangler CLI with `--local` against loopback; no deployment, package publication, Cloudflare login, or remote resource is used. Do not add `dev.remote`, account-managed bindings, or network-backed fixtures to the local suite.

## Layout

- `packages/cloudflare` — reusable ReScript FFI package, shaped for npm consumption but not published.
- `examples` — ReScript Workers/examples and emulator-backed local tests.
- `docs/local-emulator-inventory.md` — evidence-based inventory, service coverage matrix, and exclusions/limitations.

Only modules with passing local integration examples count as verified. Other service FFI declarations are explicitly marked experimental in the package README and inventory.
