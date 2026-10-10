type env = {@as("KV") kv: KV.namespace}

let fetch = (_request: Web.request, env: env) =>
  Async.map(KV.getString(env.kv, "scheduled:status"), Web.responseFromNullable)

let scheduled = (_event: JSON.t, env: env, _ctx: JSON.t) =>
  KV.putString(env.kv, "scheduled:status", "cron ran locally")
