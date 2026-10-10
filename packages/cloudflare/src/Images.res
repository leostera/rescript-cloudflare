type binding
type readableStream = Web.readableStream
type transformer
type result

type inputOptions = JSON.t
type transformOptions = JSON.t
type outputOptions = JSON.t
type hosted
type imageHandle
type imageList
type directUpload

@send external info: (binding, readableStream) => promise<JSON.t> = "info"
@send external infoWithOptions: (binding, readableStream, inputOptions) => promise<JSON.t> = "info"
@send external input: (binding, readableStream) => transformer = "input"
@send external inputWithOptions: (binding, readableStream, inputOptions) => transformer = "input"
@send external transform: (transformer, transformOptions) => transformer = "transform"
@send external output: (transformer, outputOptions) => promise<result> = "output"
@get external hosted: binding => hosted = "hosted"
@send external upload: (hosted, readableStream, JSON.t) => promise<JSON.t> = "upload"
@send external createDirectUpload: (hosted, JSON.t) => promise<directUpload> = "createDirectUpload"
@get external directUploadId: directUpload => string = "id"
@get external directUploadUrl: directUpload => string = "uploadURL"
@send external list: (hosted, JSON.t) => promise<imageList> = "list"
@send external image: (hosted, string) => imageHandle = "image"
@send external details: imageHandle => promise<Nullable.t<JSON.t>> = "details"
@send external delete: imageHandle => promise<bool> = "delete"
@get external listImages: imageList => array<JSON.t> = "images"
@get external imageId: JSON.t => string = "id"

@send external contentType: result => string = "contentType"
@send external response: result => Web.response = "response"
