type namespace
type fetcher

type options = JSON.t

@send external get: (namespace, string) => fetcher = "get"
@send external fetch: (fetcher, Web.request) => promise<Web.response> = "fetch"
