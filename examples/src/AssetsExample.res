type env = {@as("ASSETS") assets: Assets.binding}

let fetch = (request: Web.request, env: env) => {
  let url = Web.requestUrl(request)
  if String.includes(url, "/api") {
    Async.resolved(Web.response("ReScript Worker API"))
  } else {
    Assets.fetch(env.assets, request)
  }
}
