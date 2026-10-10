@val external siteNamespace: KV.namespace = "__STATIC_CONTENT"
@val external siteManifest: JSON.t = "__STATIC_CONTENT_MANIFEST"
@get external indexHtmlKey: JSON.t => string = "index.html"

let fetch = (request: Web.request) => {
  let url = Web.requestUrl(request)
  let key = indexHtmlKey(siteManifest)
  if String.endsWith(url, "/") || String.includes(url, "index.html") {
    Async.map(KV.getString(siteNamespace, key), Web.responseFromNullable)
  } else {
    Async.resolved(Web.responseWithOptions("not found", {status: Some(404), headers: None}))
  }
}
