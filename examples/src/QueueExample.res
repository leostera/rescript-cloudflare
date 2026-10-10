type env = {
  @as("JOBS") jobs: Queues.producer,
  @as("KV") kv: KV.namespace,
}
type queueEnv = {@as("KV") kv: KV.namespace}

let fetch = (request: Web.request, env: env) =>
  if Web.requestMethod(request) == "POST" {
    Async.map(Queues.sendString(env.jobs, "process this"), _ => Web.response("queued"))
  } else {
    Async.map(KV.getString(env.kv, "jobs:status"), Web.responseFromNullable)
  }

let queue = (batch: Queues.messageBatch, env: queueEnv) => {
  let messages = Queues.messages(batch)
  Async.map(KV.putString(env.kv, "jobs:status", "processed"), _ => {
    Array.forEach(messages, Queues.ack)
  })
}
