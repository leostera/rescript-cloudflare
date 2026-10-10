type namespace
type listResult
type listKey
type metadataResult

type getOptions = {cacheTtl: int}
type putOptions = {
  expirationTtl: option<int>,
  expiration: option<int>,
  metadata: option<JSON.t>,
}
type listOptions = {
  prefix: option<string>,
  limit: option<int>,
  cursor: option<string>,
}

@send external getString: (namespace, string) => promise<Nullable.t<string>> = "get"
@send external getStringWithOptions: (namespace, string, getOptions) => promise<Nullable.t<string>> = "get"
@send external getWithMetadata: (namespace, string) => promise<metadataResult> = "getWithMetadata"
@send external putString: (namespace, string, string) => promise<unit> = "put"
@send external putStringWithOptions: (namespace, string, string, putOptions) => promise<unit> = "put"
@send external delete: (namespace, string) => promise<unit> = "delete"
@send external list: (namespace, listOptions) => promise<listResult> = "list"

@get external metadataValue: metadataResult => Nullable.t<string> = "value"
@get external metadata: metadataResult => Nullable.t<JSON.t> = "metadata"
@get external listKeys: listResult => array<listKey> = "keys"
@get external listCursor: listResult => Nullable.t<string> = "cursor"
@get external listComplete: listResult => bool = "list_complete"
@get external keyName: listKey => string = "name"
@get external keyMetadata: listKey => Nullable.t<JSON.t> = "metadata"
