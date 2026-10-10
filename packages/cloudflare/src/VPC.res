type binding

@get external id: binding => string = "id"
@send external fetch: (binding, Web.request) => promise<Web.response> = "fetch"
