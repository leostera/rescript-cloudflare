type env = {@as("KV") kv: KV.namespace}

let fetch = (request: Web.request, env: env) => {
  let key = "example:greeting"
  let method = Web.requestMethod(request)
  let url = Web.requestUrl(request)
  if method == "POST" {
    Async.then(Web.requestText(request), value =>
      Async.then(KV.putString(env.kv, key, value), _ => Async.resolved(Web.response("stored")))
    )
  } else if method == "DELETE" {
    Async.map(KV.delete(env.kv, key), _ => Web.response("deleted"))
  } else if String.includes(url, "/keys") {
    let options: KV.listOptions = {prefix: Some("example:"), limit: Some(100), cursor: None}
    Async.map(KV.list(env.kv, options), result =>
      Web.response(Int.toString(Array.length(KV.listKeys(result))))
    )
  } else {
    Async.map(KV.getString(env.kv, key), Web.responseFromNullable)
  }
}
