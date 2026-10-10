type binding
type instance
type instanceStatus

type createOptions = {
  id: option<string>,
  params: option<JSON.t>,
}
type terminateOptions = JSON.t
type restartOptions = JSON.t
type event = {@as("type") type_: string, payload: JSON.t}

@send external create: (binding, createOptions) => promise<instance> = "create"
@send external get: (binding, string) => promise<instance> = "get"
@send external pause: instance => promise<unit> = "pause"
@send external resume: instance => promise<unit> = "resume"
@send external terminate: instance => promise<unit> = "terminate"
@send external terminateWithOptions: (instance, terminateOptions) => promise<unit> = "terminate"
@send external restart: instance => promise<unit> = "restart"
@send external restartWithOptions: (instance, restartOptions) => promise<unit> = "restart"
@send external sendEvent: (instance, event) => promise<unit> = "sendEvent"
@send external status: instance => promise<instanceStatus> = "status"

@get external id: instance => string = "id"
@get external statusName: instanceStatus => string = "status"
@get external error: instanceStatus => Nullable.t<JSON.t> = "error"
@get external output: instanceStatus => Nullable.t<JSON.t> = "output"
