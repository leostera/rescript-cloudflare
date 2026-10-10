type binding
type videoHandle
type video
type videoList

@send external video: (binding, string) => videoHandle = "video"
@get external videos: binding => videoList = "videos"
@send external list: videoList => promise<array<video>> = "list"
@send external upload: (binding, string) => promise<video> = "upload"
@send external uploadWithOptions: (binding, string, JSON.t) => promise<video> = "upload"
@get external videoId: video => string = "id"
@send external details: videoHandle => promise<JSON.t> = "details"
@send external update: (videoHandle, JSON.t) => promise<JSON.t> = "update"
@send external delete: videoHandle => promise<unit> = "delete"
