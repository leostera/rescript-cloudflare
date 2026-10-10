type env = {@as("FLAG") flags: Flagship.binding}

let fetch = (_request: Web.request, env: env) =>
  Async.map(Flagship.getBooleanValue(env.flags, "feature_enabled", false), enabled =>
    Web.response(if enabled {"enabled"} else {"disabled"})
  )
