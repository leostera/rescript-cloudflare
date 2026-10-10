@val external parseJson: string => JSON.t = "JSON.parse"
@get external outputText: Workflows.instanceStatus => Nullable.t<string> = "output"

let create = (binding: Workflows.binding) =>
  Workflows.create(binding, {
    id: Some("example-workflow"),
    params: Some(parseJson("{\"payload\":\"order-42\"}")),
  })

type payload = {payload: string}

let processPayload = (payload: payload) => payload.payload ++ " processed by ReScript"

let describe = (binding: Workflows.binding) =>
  Async.then(create(binding), instance =>
    Async.map(Workflows.status(instance), status => {
      let output = switch Nullable.toOption(outputText(status)) {
      | Some(value) => value
      | None => ""
      }
      Workflows.id(instance) ++ "|" ++ Workflows.statusName(status) ++ "|" ++ output
    })
  )
