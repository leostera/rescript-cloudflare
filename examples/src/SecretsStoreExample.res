type env = {@as("SECRET") secret: SecretsStore.secret}

let fetch = (_request: Web.request, env: env) =>
  Async.map(SecretsStore.get(env.secret), value => Web.response(value))
