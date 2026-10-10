type env = {@as("SERVICE") service: ServiceBinding.fetcher}

let fetch = (request: Web.request, env: env) => ServiceBinding.fetch(env.service, request)
