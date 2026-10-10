type fetcher

@send external fetch: (fetcher, Web.request) => promise<Web.response> = "fetch"
