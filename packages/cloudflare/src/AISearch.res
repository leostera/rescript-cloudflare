type namespace
type instance

type searchOptions = JSON.t

@send external get: (namespace, string) => instance = "get"
@send external create: (namespace, JSON.t) => promise<instance> = "create"
@send external delete: (namespace, string) => promise<unit> = "delete"
@send external search: (namespace, JSON.t) => promise<JSON.t> = "search"
@send external instanceSearch: (instance, JSON.t) => promise<JSON.t> = "search"
@send external stats: instance => promise<JSON.t> = "stats"
