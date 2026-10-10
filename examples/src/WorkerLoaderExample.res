type env = {@as("LOADER") loader: WorkerLoader.loader}

@val external parseJson: string => JSON.t = "JSON.parse"

let fetch = (request: Web.request, env: env) => {
  let code: WorkerLoader.workerCode = {
    compatibilityDate: "2026-10-10",
    mainModule: "index.js",
    modules: parseJson("{\"index.js\":\"export default {fetch() { return new Response('loaded locally') }}\"}"),
  }
  let stub = WorkerLoader.load(env.loader, code)
  WorkerLoader.fetch(WorkerLoader.getDefaultEntrypoint(stub), request)
}
