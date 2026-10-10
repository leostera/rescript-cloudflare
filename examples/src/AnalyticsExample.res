type env = {@as("EVENTS") dataset: AnalyticsEngine.dataset}

let fetch = (_request: Web.request, env: env) => {
  AnalyticsEngine.writeDataPoint(env.dataset, {
    blobs: Some(["example-event", "local"]),
    doubles: Some([1.0]),
    indexes: Some(["example-event-index"]),
  })
  Async.resolved(Web.response("analytics point accepted locally"))
}
