type service

@send external fetch: (service, Web.request) => promise<Web.response> = "fetch"
