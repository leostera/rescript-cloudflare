# `@reworked/cloudflare-rescript`

ReScript FFI bindings for Cloudflare Workers runtime and platform bindings. This is a source package: Cloudflare supplies runtime values (for example `env.MY_KV`); the package neither constructs bindings nor implements an emulator. It is experimental and has not been published.

## Use from a ReScript workspace

Add the package as an npm and ReScript dependency, then call its module directly:

```rescript
let get = KV.getString
```

Cloudflare APIs that return nullable values are represented using `Nullable.t`; dynamic SDK shapes may use `JSON.t`. Pass the values supplied by the Worker runtime.

## Runtime validation

Only a module/operation slice with a passing local test is verified. The coverage matrix in [`docs/local-emulator-inventory.md`](../../docs/local-emulator-inventory.md) maps validated operations to examples and tests. Other service modules and unexercised methods are draft FFI declarations: ReScript compilation checks source-level consistency, not their runtime signature or availability. Use the pinned Workers types as a reference and verify against the target emulator/runtime before relying on them.

The local examples do not use Cloudflare accounts, deploy, publish, or access remote resources. Test-only internal Miniflare APIs used to seed local Flagship/Secrets Store data are not public application APIs.

## Development

```sh
npm run build --workspace @reworked/cloudflare-rescript
npm run test:local
```
