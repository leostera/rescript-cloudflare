type loader
type workerStub
type workerEntrypoint

type workerCode = {
  compatibilityDate: string,
  mainModule: string,
  modules: JSON.t,
}

@send external load: (loader, workerCode) => workerStub = "load"
@send external get: (loader, string, (unit => workerCode)) => workerStub = "get"
@send external getDefaultEntrypoint: workerStub => workerEntrypoint = "getEntrypoint"
@send external getEntrypoint: (workerStub, string) => workerEntrypoint = "getEntrypoint"
@send external fetch: (workerEntrypoint, Web.request) => promise<Web.response> = "fetch"
