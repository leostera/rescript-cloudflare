type env = {@as("RATE") limit: RateLimit.binding}

let fetch = (_request: Web.request, env: env) =>
  Async.then(RateLimit.limit(env.limit, {key: "example-client"}), first =>
    Async.map(RateLimit.limit(env.limit, {key: "example-client"}), second => {
      let firstAllowed = if RateLimit.success(first) {"allowed"} else {"limited"}
      let secondAllowed = if RateLimit.success(second) {"allowed"} else {"limited"}
      Web.response(firstAllowed ++ "," ++ secondAllowed)
    })
  )
