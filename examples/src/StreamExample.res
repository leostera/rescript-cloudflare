type env = {@as("STREAM") stream: Stream.binding}

let fetch = (request: Web.request, env: env) => {
  let method = Web.requestMethod(request)
  let url = Web.requestUrl(request)
  let videos = Stream.videos(env.stream)
  if method == "POST" {
    let localVideo = "data:video/mp4;base64,AAAA"
    Async.map(Stream.upload(env.stream, localVideo), video =>
      Web.response(Stream.videoId(video))
    )
  } else if method == "DELETE" {
    Async.then(Stream.list(videos), items =>
      switch Array.get(items, 0) {
      | Some(item) =>
        Async.map(Stream.delete(Stream.video(env.stream, Stream.videoId(item))), _ =>
          Web.response("deleted")
        )
      | None => Async.resolved(Web.response("missing"))
      }
    )
  } else if String.includes(url, "/details") {
    Async.then(Stream.list(videos), items =>
      switch Array.get(items, 0) {
      | Some(item) =>
        Async.map(Stream.details(Stream.video(env.stream, Stream.videoId(item))), _ =>
          Web.response("present")
        )
      | None => Async.resolved(Web.response("missing"))
      }
    )
  } else {
    Async.map(Stream.list(videos), items => Web.response(Int.toString(Array.length(items))))
  }
}
