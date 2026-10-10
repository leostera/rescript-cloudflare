type env = {@as("EVENTS") pipeline: Pipelines.binding}

@val external parseJson: string => JSON.t = "JSON.parse"

let fetch = (_request: Web.request, env: env) =>
  Async.map(
    Pipelines.send(env.pipeline, [parseJson("{\"event\":\"local-test\",\"count\":1}")]),
    _ => Web.response("pipeline accepted event locally"),
  )
