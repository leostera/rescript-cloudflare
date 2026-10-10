let fetch = (request: Web.request, _env: JSON.t) => {
  let path = request->Web.requestUrl
  let status = if path->String.includes("health") {200} else {404}
  let body = if status == 200 {"ok"} else {"not found"}
  Async.resolved(Web.responseWithOptions(body, {status: Some(status), headers: None}))
}
