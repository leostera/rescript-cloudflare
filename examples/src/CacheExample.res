@val external parseJson: string => JSON.t = "JSON.parse"

let fetch = (request: Web.request, _env: JSON.t) => {
  let cache = Cache.default(Cache.global)
  if Web.requestMethod(request) == "DELETE" {
    let keyRequest = Web.requestFromUrl(Web.requestUrl(request))
    Async.map(Cache.delete(cache, keyRequest), deleted =>
      Web.response(if deleted {"deleted"} else {"missing"})
    )
  } else {
    Async.then(Cache.match(cache, request), cached =>
      switch Nullable.toOption(cached) {
      | Some(response) => Async.resolved(response)
      | None => {
          let headers = Some(parseJson("{\"Cache-Control\":\"public, max-age=300\"}"))
          let cachedResponse = Web.responseWithOptions("cached response", {status: Some(200), headers})
          let originResponse = Web.responseWithOptions("origin response", {status: Some(200), headers})
          Async.map(Cache.put(cache, request, Web.clone(cachedResponse)), _ => originResponse)
        }
      }
    )
  }
}
