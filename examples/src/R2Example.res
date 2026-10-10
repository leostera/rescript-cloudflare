type env = {@as("BUCKET") bucket: R2.bucket}

let fetch = (request: Web.request, env: env) => {
  let key = "example:greeting"
  let method = Web.requestMethod(request)
  let url = Web.requestUrl(request)
  if method == "POST" {
    Async.then(Web.requestText(request), value =>
      Async.map(R2.put(env.bucket, key, value), _ => Web.response("stored"))
    )
  } else if method == "DELETE" {
    Async.map(R2.delete(env.bucket, key), _ => Web.response("deleted"))
  } else if String.includes(url, "/head") {
    Async.map(R2.head(env.bucket, key), object =>
      switch Nullable.toOption(object) {
      | Some(_) => Web.response("present")
      | None => Web.response("missing")
      }
    )
  } else if String.includes(url, "/list") {
    let options: R2.listOptions = {prefix: Some("example:"), limit: Some(100), cursor: None}
    Async.map(R2.list(env.bucket, options), result =>
      Web.response(Int.toString(Array.length(R2.listedObjects(result))))
    )
  } else {
    Async.then(R2.get(env.bucket, key), object =>
      switch Nullable.toOption(object) {
      | Some(value) => Async.map(R2.objectText(value), Web.response)
      | None => Async.resolved(Web.response("missing"))
      }
    )
  }
}
