type bucket
type object
type listResult

type putOptions = {
  httpMetadata: option<JSON.t>,
  customMetadata: option<JSON.t>,
}
type listOptions = {
  prefix: option<string>,
  limit: option<int>,
  cursor: option<string>,
}

@send external get: (bucket, string) => promise<Nullable.t<object>> = "get"
@send external put: (bucket, string, string) => promise<Nullable.t<object>> = "put"
@send external putWithOptions: (bucket, string, string, putOptions) => promise<Nullable.t<object>> = "put"
@send external head: (bucket, string) => promise<Nullable.t<object>> = "head"
@send external delete: (bucket, string) => promise<unit> = "delete"
@send external list: (bucket, listOptions) => promise<listResult> = "list"

@send external objectText: object => promise<string> = "text"
@send external objectJson: object => promise<JSON.t> = "json"
@get external key: object => string = "key"
@get external etag: object => string = "etag"
@get external size: object => float = "size"
@get external customMetadata: object => Nullable.t<JSON.t> = "customMetadata"
@get external listedObjects: listResult => array<object> = "objects"
@get external listCursor: listResult => Nullable.t<string> = "cursor"
@get external listTruncated: listResult => bool = "truncated"
