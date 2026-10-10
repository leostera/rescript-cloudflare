type env = {@as("IMAGES") images: Images.binding}
type imageInfo = JSON.t

@get external width: imageInfo => int = "width"
@get external height: imageInfo => int = "height"
@get external format: imageInfo => string = "format"
@val external parseJson: string => JSON.t = "JSON.parse"

let fetch = (request: Web.request, env: env) => {
  let method = Web.requestMethod(request)
  let url = Web.requestUrl(request)
  let hosted = Images.hosted(env.images)
  if method == "POST" && String.includes(url, "/hosted/direct") {
    Async.map(Images.createDirectUpload(hosted, parseJson("{\"id\":\"local-direct-image\",\"expiresIn\":3600}")), result =>
      Web.response(Images.directUploadId(result) ++ "\n" ++ Images.directUploadUrl(result))
    )
  } else if method == "POST" && String.includes(url, "/hosted") {
    switch Nullable.toOption(Web.requestBody(request)) {
    | Some(image) =>
      Async.map(
        Images.upload(hosted, image, parseJson("{\"id\":\"local-rescript-image\",\"filename\":\"pixel.png\"}")),
        metadata => Web.response(Images.imageId(metadata)),
      )
    | None => Async.resolved(Web.response("image body required"))
    }
  } else if method == "POST" && String.includes(url, "/transform") {
    switch Nullable.toOption(Web.requestBody(request)) {
    | Some(image) => {
        let transform = parseJson("{\"width\":1,\"height\":1}")
        let output = parseJson("{\"format\":\"image/png\"}")
        let transformer = Images.transform(Images.input(env.images, image), transform)
        Async.map(Images.output(transformer, output), result =>
          Web.response(Images.contentType(result))
        )
      }
    | None => Async.resolved(Web.response("image body required"))
    }
  } else if method == "POST" {
    switch Nullable.toOption(Web.requestBody(request)) {
    | Some(image) =>
      Async.map(Images.info(env.images, image), info =>
        Web.response(Int.toString(width(info)) ++ "x" ++ Int.toString(height(info)) ++ " " ++ format(info))
      )
    | None => Async.resolved(Web.response("image body required"))
    }
  } else if String.includes(url, "/list") {
    Async.map(Images.list(hosted, parseJson("{\"limit\":10}")), result =>
      Web.response(Int.toString(Array.length(Images.listImages(result))))
    )
  } else if method == "DELETE" {
    let imageId = if String.includes(url, "/direct") {"local-direct-image"} else {"local-rescript-image"}
    Async.map(Images.delete(Images.image(hosted, imageId)), deleted =>
      Web.response(if deleted {"deleted"} else {"missing"})
    )
  } else if String.includes(url, "/details") {
    let imageId = if String.includes(url, "/direct") {"local-direct-image"} else {"local-rescript-image"}
    Async.map(Images.details(Images.image(hosted, imageId)), metadata =>
      switch Nullable.toOption(metadata) {
      | Some(_) => Web.response("present")
      | None => Web.response("missing")
      }
    )
  } else {
    Async.resolved(Web.response("not found"))
  }
}
