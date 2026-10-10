type cacheStorage
type cache
type request = Web.request
type response = Web.response
type matchOptions = JSON.t

@val external global: cacheStorage = "caches"
@get external default: cacheStorage => cache = "default"
@send external openCache: (cacheStorage, string) => promise<cache> = "open"
@send external match: (cache, request) => promise<Nullable.t<response>> = "match"
@send external matchWithOptions: (cache, request, matchOptions) => promise<Nullable.t<response>> = "match"
@send external put: (cache, request, response) => promise<unit> = "put"
@send external delete: (cache, request) => promise<bool> = "delete"
